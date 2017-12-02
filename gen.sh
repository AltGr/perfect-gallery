#!/bin/bash -ue

DIR="$1"; shift
PHOTOS=("$@")
OUT="$DIR/photos.json"

mkdir -p "$DIR/large"
mkdir -p "$DIR/thumbs"
if [ ! -e jquery.min.js ]; then
    wget -O jquery.min.js https://code.jquery.com/jquery-2.2.4.min.js
fi
if [ ! -e perfectLayout.min.js ]; then
    wget -O perfectLayout.min.js https://raw.githubusercontent.com/axyz/perfect-layout/d56bc2d9c5212e5d79ff63994ef434a3ec2acd16/dist/perfectLayout.min.js
fi
cp index.html "$DIR"
cp jquery.min.js "$DIR"
cp perfectLayout.min.js "$DIR"

echo "[" >"$OUT"
i=0
for p in "${PHOTOS[@]}"; do
    read w h orient < <(identify -format '%w %h %[EXIF:Orientation]\n' $p)
    case "$orient" in
        1|3) RATIO=$(bc -l <<<"$w / $h") ;;
        *) RATIO=$(bc -l <<<"$h / $w")
    esac
    base=$(basename $p)
    convert -auto-orient -resize 1920x1920\> -interlace Plane -quality 75% "$p" "$DIR/large/$base"
    convert -auto-orient -thumbnail 640x640\> -strip -interlace Plane -quality 64% "$p" "$DIR/thumbs/$base"
    if [ $i -ne 0 ]; then echo "," >>"$OUT"; fi
    LC_ALL=C printf '  { "data": "large/%s", "src": "thumbs/%s", "ratio": %f }' "$base" "$base" "$RATIO" >>"$OUT"
    i=$((i+1))
    printf "\r[KResizing images: %02d%%" $((i * 100 / ${#PHOTOS[*]}))
done
echo

echo >>"$OUT"
echo "]" >>"$OUT"

xdg-open "$DIR/index.html"
