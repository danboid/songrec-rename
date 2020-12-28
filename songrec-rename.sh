#!/bin/bash
# songrec-rename - automatic naming of music files using songrec 
# by Dan MacDonald 2020

if ! command -v songrec &> /dev/null
then
    echo "You must install songrec before you can run this script"
    exit
fi

for t in $(ls *.wav *.WAV *.mp3 *.MP3 *.ogg *.ogg *.flac *.FLAC); do
    songrec audio-file-to-recognized-song "$t" > srr.tmp
    subtitle=$(grep subtitle srr.tmp | cut -c 18- | sed 's/",//')
    title=$(grep title srr.tmp | sed -n 5p | cut -c 15- | sed 's/",//')
    extension=$(echo $t | tail -c 5)
	
    if [ ! -z "$title" ]; then 
        echo "Renaming $t to $subtitle - $title$extension"
        mv "$t" "$subtitle - $title$extension"
    else
        echo "$t is unrecognized by Shazam"
    fi
	
    title=""
    subtitle=""
    rm srr.tmp
done
