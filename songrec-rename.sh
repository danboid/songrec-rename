#!/bin/bash
# songrec-rename - automatic naming of music files using songrec
# by Dan MacDonald
#
# If run with no options, it will rename music files in the current dir.
# If you add the -r option it will rename all music files in all folders 
# including and within the current one.


if ! command -v songrec &> /dev/null
then
    echo "You must install songrec before you can run this script"
    exit
fi

while getopts r opt; do
   case $opt in
     r ) recurse=1 ;;
  esac
done

srr() {
for t in *; do
    songrec audio-file-to-recognized-song "$t" > srr.tmp
    subtitle=$(grep '"subtitle"' srr.tmp | cut -c 18- | sed 's/",//'| sed 's/&/and/g')
    title=$(grep tracktitle srr.tmp | cut -c 24- | sed 's/"//' | sed 's/+/ /g' | sed 's/%..//g' | sed 's/&/and/g')
    extension=$(echo $t | sed 's/.*\.//')
	
    if [ ! -z "$title" ]; then 
        echo "Renaming $t to $subtitle-$title.$extension"
        mv "$t" "$subtitle-$title.$extension"
    else
        echo "$t is unrecognized by Shazam"
    fi
	
    title=""
    subtitle=""
    rm srr.tmp
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
