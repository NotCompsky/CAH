#!/bin/bash


DIR="$(dirname "$(dirname "$(readlink -f "$0")")")"
imagemagick_cmd=convert # magick


type="$1"
msg="$2"
logo="$3"
out="$4"


if [[ -f "$out" ]]; then
    echo "Already exists: $out"
    exit 0
fi
    
    
black_back="$DIR/res/uKXt3lY.png"
white_back="$DIR/res/EKo1KSx.png"
front="$DIR/res/EojZ6uO.png"

# NOTE: $front is white - we invert for writing black cards

# Font is (nearest to) Helvetica Bold

w=3288
h=4488

x_offset=375
y_offset=272

x1="$x_offset"
y1="$y_offset"
x2=$((w - x_offset))
y2=$((h - y_offset))

textbox_w=$((x2 - x1))
textbox_h=$((y2 - y1))

#font="Helvetica-Bold"
#"Liberation-Sans-Bold"
# closest to Helvetica-Bold
font="Liberation-Sans-Bold"

font_size=301

tmp_card_txt_fp=/tmp/card-text.png
tmp1=/tmp/card1.png

"$imagemagick_cmd" -background white -size "$textbox_w" -font "Helvetica-Bold" -fill '#000000' -pointsize "$((3*font_size/4))" "pango:$msg" "$tmp_card_txt_fp"

"$imagemagick_cmd" "$front" "$tmp_card_txt_fp" -size "$w"x"$h" -geometry "+$x1+$y1+$x2+$y2" -composite "$tmp1"

if [[ "$logo" = "" ]]; then
    dummy=1
else
	"$imagemagick_cmd" "$tmp1" "$logo" -size "$w"x"$h" -geometry "+440+3800+778+4051" -composite "$tmp1"
fi

if [[ "$type" = "w" ]]; then
    mv "$tmp1" "$out"
else
	"$imagemagick_cmd" "$tmp1" -negate "$out"
fi
