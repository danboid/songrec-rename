# songrec-rename

**songrec-rename** is a shell script to automate the naming of music files.
It uses the open source Shazam client [songrec](https://github.com/marin-m/SongRec/) to identify tracks.

**songrec-rename** accepts wav, flac, ogg and mp3 files as input.

## Installing songrec under Ubuntu

```
sudo apt update && sudo apt install software-properties-common
sudo apt-add-repository ppa:marin-m/songrec -y -u
sudo apt install songrec -y
```

See the [songrec homepage](https://github.com/marin-m/SongRec/) for instructions
on installing songrec under other Linux distros or building it from source.

## Downloading and installing songrec-rename

Clone this repo:

```
git clone https://github.com/danboid/songrec-rename.git
```

then (under Ubuntu 20.04+ or if you have **~/.local/bin** in your $PATH)

```
cp songrec-rename/songrec-rename.sh ~/.local/bin/songrec-rename
```

or (under Ubuntu 18.04 and earlier, without **~/.local/bin** in your $PATH)

```
sudo cp songrec-rename/songrec-rename.sh /usr/local/bin/songrec-rename
```

`songrec-rename` requires `jq` and optionally `id3v2` for adding id3 tags.

```
sudo apt install jq id3v2 -y
```

## Using songrec-rename

`cd` into a directory containing music files (wav, flac, ogg or mp3) then run `songrec-rename`. If you add the `-r` option it will rename all music files in all directories within the current one, recursively.

If you have **id3v2** installed and you use the **-i** option **songrec-rename** will add id3 tags to mp3 files.

Note that if you have more than one copy of a track within a directory, **songrec-rename** will only rename the first instance of any duplicated tracks.
