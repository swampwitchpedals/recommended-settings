#!/bin/sh

# Usage
# recommended-settings.sh 2 1 3 4 5 1 4 source.png output.png

OFFSET_GEOMETRY="96x96+33+45"
CROP="680x380+20+110"


# Converts a knob position (0-10) to that position's value in degrees
# for a standard potentiometer (-150º, 150º)
function convert_degrees() {
	echo $(( 30*$1 - 150 ))
}

# Converts a rotary position (0-7) to that position's value in degrees
# for a Vimex 8 position sensor (-90º, 90º)
function convert_position() {
	echo $(( (180*$1)/7 - (180/7 + 90) ))
}

# Adds 7 knobs (technically 8, number 5 is transparent)
# on a transparent background
# with offset shadows
# in a 4 x 2 grid
# and shift everything correctly, composite and crop to just the knobs
montage -background none \
	\( knob.png -distort SRT 0.8,$(convert_degrees $1) \) \
	\( knob.png -distort SRT 0.8,$(convert_degrees $2)  \) \
	\( knob.png -distort SRT 0.8,$(convert_degrees $3)  \) \
	\( knob.png -distort SRT 0.8,$(convert_degrees $4)  \) \
        \( knob.png -distort SRT 0.8,0 -alpha transparent \) \
	\( knob.png -distort SRT 0.8,$(convert_degrees $5)  \) \
	\( knob.png -distort SRT 0.8,$(convert_degrees $6)  \) \
	\( knob.png -distort SRT 0.8,$(convert_position $7)  \) \
	-transparent white \
       	-shadow -geometry +1+1 \
	-tile 4x2 -geometry $OFFSET_GEOMETRY png:- \
| magick - -geometry +35+65 $8 +swap -composite -crop $CROP +repage $9


# Then create an audio file
# ffmpeg -i setting.png -i setting.m4a -acodec libaac  -pix_fmt yuvj420p -vcodec libx264  -ac 2 -ar 48000 setting-output.mov
