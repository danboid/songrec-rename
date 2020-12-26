# songrec-rename

**songrec-rename** is a shell script to automate the naming of music files.
It uses the open source Shazam client `songrec` to identify tracks.

**songrec-rename** will rename every wav, flac, ogg and mp3 file that can 
be identified in the current working directory.

## Installing songrec under Ubuntu

```
sudo apt-add-repository ppa:marin-m/songrec -y -u
sudo apt install songrec -y
```

## Downloading and installing songrec-rename

```
git clone https://github.com/danboid/songrec-rename.git
sudo cp songrec-rename/songrec-rename.sh /usr/local/bin/songrec-rename
sudo chmod +x /usr/local/bin/songrec-rename
```

## Using songrec-rename

`cd` into a directory containing music files then run `songrec-rename`
