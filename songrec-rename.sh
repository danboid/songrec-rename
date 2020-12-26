#!/bin/bash
# songrec-rename - rename music files using songrec 
# by Dan MacDonald 2020

for t in $(ls *.wav *.WAV *.mp3 *.MP3 *.ogg *.ogg *.flac *.FLAC); do
    songrec audio-file-to-recognized-song $t > srr.tmp
	subtitle=$(grep subtitle srr.tmp | cut -c 18- | sed 's/",//')
	title=$(grep title srr.tmp | sed -n 5p | cut -c 15- | sed 's/",//')
	extension=$(echo $t | tail -c 5)
	
	if [ ! -z "$title" ]; then 
	    echo "Renaming $t to $subtitle - $title$extension"
	    mv "$t" "$subtitle - $title$extension"
	else
		echo "$t not matched"
	fi
	
	title=""
	subtitle=""
	rm srr.tmp
	
done

