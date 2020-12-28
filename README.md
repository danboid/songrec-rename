# songrec-rename

**songrec-rename** is a shell script to automate the naming of music files.
It uses the open source Shazam client `songrec` to identify tracks.

**songrec-rename** will rename every wav, flac, ogg and mp3 file that can 
be identified in the current working directory.

## Installing songrec under Ubuntu

```
sudo apt update && sudo apt install software-properties-common
sudo apt-add-repository ppa:marin-m/songrec -y -u
sudo apt install songrec -y
```

## Downloading and installing songrec-rename

```
git clone https://github.com/danboid/songrec-rename.git
cp songrec-rename/songrec-rename.sh ~/.local/bin/songrec-rename
chmod +x ~/.local/bin/songrec-rename
```

## Using songrec-rename

`cd` into a directory containing music files (wav, flac, ogg or mp3) then run `songrec-rename`
