! This repository has moved to https://gitlab.com/AltGr/perfect-gallery !

A very simple  image gallery (HTML + js) based on
[perfect-layout](https://github.com/axyz/perfect-layout)

Prerequisites: bash and ImageMagick

Usage:

    ./gen.sh NAME PIC1.JPG PIC2.JPG ...

This generates a NAME directory that contains a stand-alone gallery and is
expected to be served directly from a web server. The directory contains the
resized pictures, their thumbnails, and an `index.html` file (plus the
javascript dependencies).

Features:
- beautiful and simple layout
- nothing extra, no borders, no text, just the pictures filling the whole space
- full-size pictures on click
- manual slideshow (keyboard, mouse, touch) with preloading
- mobile friendly

All image processing is done using [ImageMagick](http://imagemagick.org), which
needs to be installed on your machine when generating the gallery. The
javascript uses [jQuery](http://jquery.com/) and
[perfect-layout](https://github.com/axyz/perfect-layout). I needed a replacement
for `chromatic.io`, which disappeared, couldn't find anything I liked, and found
perfect-layout which had the hard part solved, so put this together. 

This is licensed under GPLv3, see the file LICENSE for details.
