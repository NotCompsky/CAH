#!/bin/bash

CFG_FILE=~/.config/compsky/CAH.txt

if [ -f "$CFG_FILE" ]; then
    DIR=$(cat "$CFG_FILE")
else
    read -p "Root directory of compsky/CAH: " DIR
    echo "$DIR" > "$CFG_FILE"
fi

OUTDIR=/tmp/compsky/CAH

mkdir -p "$OUTDIR/cards/w"
mkdir "$OUTDIR/cards/b"

if [ -d "$DIR/data" ]; then
    dummy=1
else
    cp -r "$DIR/data.eg" "$DIR/data"
fi

if [ -d "$DIR/res" ]; then
    mkdir "$DIR/res"
fi
for f in uKXt3lY.png EKo1KSx.png EojZ6uO.png; do
    if [ -f "$DIR/res/$f" ]; then
        dummy=1
    else
        echo "Downloading https://i.imgur.com/$f"
        curl "https://i.imgur.com/$f" -o "$DIR/res/$f"
        sleep 1
    fi
done

for bw in b w; do
    for fp in "$DIR/data/$bw/"*.txt; do
        logo=""
        while read line; do
            if [[ "$line" = "" ]]; then
                continue
            fi
            if [[ "${line:0:1}" = "#" ]]; then
                continue
            fi
            if [[ "${line:0:6}" = "%logo=" ]]; then
                logo="${line:6}"
            fi
            echo "$line"
            hash="$((0x$(sha1sum <<<"$line")0))"
            "$DIR/new-card.sh" $bw "$line" "$logo" "$OUTDIR/cards/$bw/$hash.png"
        done < "$fp"
    done
done
