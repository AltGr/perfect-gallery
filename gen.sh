#!/bin/bash -ue

DIR="$1"; shift
PHOTOS=("$@")
OUT="$DIR/photos.json"

mkdir -p "$DIR/large"
mkdir -p "$DIR/thumbs"
cp index.html jquery.min.js perfectLayout.min.js "$DIR"

echo "var photos = [" >"$OUT"
i=0
for p in "${PHOTOS[@]}"; do
    read w h orient < <(identify -format '%w %h %[EXIF:Orientation]\n' $p)
    case "$orient" in
        1|3) RATIO=$(bc -l <<<"$w / $h") ;;
        *) RATIO=$(bc -l <<<"$h / $w")
    esac
    base=$(basename $p)
    convert -auto-orient -resize 1920x1920\> -interlace Plane -quality 75% "$p" "$DIR/large/$base"
    convert -auto-orient -thumbnail 540x540\> -strip -interlace Plane -quality 60% "$p" "$DIR/thumbs/$base"
    if [ $i -ne 0 ]; then echo "," >>"$OUT"; fi
    echo -n "  { data: \"large/$base\", src: \"thumbs/$base\", ratio: $RATIO }" >>"$OUT"
    i=$((i+1))
    printf "\r[KResizing images: %02d%%" $((i * 100 / ${#PHOTOS[*]}))
done
echo

echo >>"$OUT"
echo "];" >>"$OUT"

xdg-open "$DIR/index.html"
