#!/bin/bash
# songrec-rename - automatic naming of music files using songrec 
# by Dan MacDonald 2020

if ! command -v songrec &> /dev/null
then
    echo "You must install songrec before you can run this script"
    exit
fi

for t in *; do
    songrec audio-file-to-recognized-song "$t" > srr.tmp
    subtitle=$(grep '"subtitle"' srr.tmp | cut -c 18- | sed 's/",//')
    title=$(grep tracktitle srr.tmp | cut -c 24- | sed 's/"//' | sed 's/+/ /g' | sed 's/%..//g')
    extension=$(echo $t | sed 's/.*\.//')
	
    if [ ! -z "$title" ]; then 
        echo "Renaming $t to $subtitle - $title.$extension"
        mv "$t" "$subtitle - $title.$extension"
    else
        echo "$t is unrecognized by Shazam"
    fi
	
    title=""
    subtitle=""
    rm srr.tmp
done
