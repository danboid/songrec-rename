#!/bin/bash

# songrec-rename - automatic naming of music files using songrec. 

# by Dan MacDonald

# An internet connection is required to run this script successfully.

# If run with no options, it will rename music files in the current dir.

# If you add the -r option it will rename all music files in all folders 
# including and within the current one.

# Use the -i option to add id3 tags to mp3 files if you have id3tool installed.


if ! command -v songrec &> /dev/null
then
    echo "You must install songrec before you can run this script."
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

if [[ "${id3}" -eq 1 && ! $(command -v id3tool) ]] ; then
    echo "You must install id3tool to add id3tags to mp3 files."
    exit
fi

srr() {
for t in *; do
    # Try to identify current file.
    songrec audio-file-to-recognized-song "$t" > srr.tmp
    
    # subtitle is the artist name.
    subtitle=$(grep '"subtitle"' srr.tmp | cut -c 18- | sed 's/",//'| sed 's/&/and/g')
    
    # title is the name of the track.
    title=$(grep tracktitle srr.tmp | cut -c 24- | sed 's/"//' | sed 's/+/ /g' | sed 's/%..//g' | sed 's/&/and/g')
    
    # Store the file extension.
    extension=$(echo "$t" | sed 's/.*\.//')
    
    if [ "$id3" -eq 1 ]; then
        album=$(grep -A 2 metadata srr.tmp | sed '1,2d' | cut -c 22- | sed 's/",//')
        year=$(grep -A 10 metadata srr.tmp | sed '1,10d' | cut -c 22- | sed 's/",//')
    fi
	
    if [ ! -z "$title" ]; then 
        if [[ "$extension" == "mp3" && "$id3" -eq 1 ]]; then
            echo "Adding id3 tags to $subtitle-$title."
            id3tool -t "$title" -r "$subtitle" -a "$album" -y "$year" "$t"
        fi
        echo "Renaming $t to $subtitle-$title.$extension"
        mv -n "$t" "$subtitle-$title.$extension"
    else
        echo "$t is unrecognized by Shazam."
    fi
    rm srr.tmp
    while [ -f srr.tmp ];
    do
        sleep 1
    done	
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
