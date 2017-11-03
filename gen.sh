#!/bin/bash -ue

PHOTOS=(*.JPG)
OUT=photos.json

echo "var photos = [" >"$OUT"

mkdir -p large
mkdir -p thumbs

first=1
for p in "${PHOTOS[@]}"; do
    read w h orient < <(identify -format '%w %h %[EXIF:Orientation]\n' $p)
    case "$orient" in
        1|3) RATIO=$(bc -l <<<"$w / $h") ;;
        *) RATIO=$(bc -l <<<"$h / $w")
    esac
    base=$(basename $p)
    convert -auto-orient -resize 1920x1920\> -interlace Plane -quality 75% $p large/$base
    convert -auto-orient -thumbnail 540x540\> -strip -interlace Plane -quality 60% $p thumbs/$base
    if [ $first -eq 0 ]; then echo "," >>"$OUT"; fi
    echo -n "  { data: \"large/$p\", src: \"thumbs/$p\", ratio: $RATIO }" >>"$OUT"
    first=0
    echo -n "."
done
echo

echo >>"$OUT"
echo "];" >>"$OUT"
