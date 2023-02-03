#!/bin/bash

# songrec-rename - automatic naming of music files using songrec. 

# by Dan MacDonald

# An internet connection is required to run this script successfully.

# If run with no options, it will rename music files in the current dir.

# If you add the -r option it will rename all music files in all folders 
# including and within the current one.

# Use the -i option to add id3 tags to mp3 files if you have id3v2 installed.


if ! command -v songrec &> /dev/null
then
    echo "You must install songrec before you can run songrec-rename."
    exit
fi

# Don't add id3tags by default.
id3=0

# Don't recurse directories by default.
recurse=0

while getopts ":ri" opt; do
   case $opt in
     i ) id3=1 ;;
     r ) recurse=1 ;;
     \? ) echo -e "Usage: songrec-rename [-i] [-r]\n-i Add ID3 tags\n-r Recurse subdirectories"; exit 1;;
  esac
done

if [[ "${id3}" -eq 1 && ! $(command -v id3v2) ]] ; then
    echo "You must install id3v2 to add id3tags to mp3 files."
    exit
fi

if ! command -v jq &> /dev/null ; then
    echo "You must install jq to use songrec-rename."
    exit
fi

srr() {
for t in *; do
    # Try to identify current file.
    songrec audio-file-to-recognized-song "$t" > srr.json
    
    # subtitle is the artist name.
    subtitle=$(jq -r '.track.subtitle' srr.json | sed 's/&/and/g' | sed 's/*//g' | sed 's/"//g' | sed 's/\\//g')
    
    # title is the name of the track.
    title=$(jq -r '.track.title' srr.json | sed 's/&/and/g' | sed 's/*//g' | sed 's/"//g' | sed 's/\\//g')
    
    # Store the file extension.
    extension=$(echo "$t" | sed 's/.*\.//')
    
    if [ "$id3" -eq 1 ]; then
        album=$(jq -r 'if .track.sections[0].metadata[0].text == null then "" else .track.sections[0].metadata[0].text end' srr.json)
        year=$(jq -r 'if .track.sections[0].metadata[2].text == null then "" else .track.sections[0].metadata[2].text end' srr.json)
    fi

    if [[ "$title" != "null" ]]; then
        if [[ "$extension" == "mp3" && "$id3" -eq 1 ]]; then
            echo "Adding id3 tags to $subtitle-$title."
            id3v2 -t "$title" -a "$subtitle" -A "$album" -y "$year" "$t"
        fi

        echo "Renaming $t to $subtitle-$title.$extension"
        mv -n "$t" "$subtitle-$title.$extension"
    else
        echo "ERROR: $t is unrecognized by songrec."
    fi

    rm srr.json
    while [ -f srr.json ];
    do
        sleep 1
    done
    sleep 1
	
    year=""
    album=""
    title=""
    subtitle=""
done
}

if [[ "${recurse}" -eq 1 ]] ; then
    BASEDIR=$(pwd)
    find . -type d | sort | while read -r DIR; do
        cd "$BASEDIR/$DIR" || exit 1
        srr
    done
    else
        srr
fi
