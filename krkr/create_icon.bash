#!/bin/bash

set -ex

export BASE=krkr

export size=(256 64 48 32 24 16)
export bits=(32 8 4 1)

echo Making bitmaps from your svg...

for i in ${size[@]}; do
    for j in ${bits[@]}; do
        rsvg-convert -w $i -h $i ${BASE}_bits_${j}.svg -o ${BASE}_bits_${j}_${i}_unc.png
    done
done

echo Compressing...

for i in ${size[@]}; do
	cp ${BASE}_bits_1_${i}_unc.png ${BASE}_bits_1_${i}.png
	cp ${BASE}_bits_4_${i}_unc.png ${BASE}_bits_4_${i}.png
	# convert ${BASE}_bits_8_${i}_unc.png -type TrueColorMatte png8:${BASE}_bits_8_${i}.png
	pngquant -f --speed 1 -o ${BASE}_bits_8_${i}.png ${BASE}_bits_8_${i}_unc.png
	cp ${BASE}_bits_32_${i}_unc.png ${BASE}_bits_32_${i}.png
done

#for i in ${bits[@]}; do
#	if [ "$i" != "8" -a "$i" != "4" -a "$i" != "1" ];
#		then optipng -clobber -o 7 -out ${BASE}_bits_${i}_256.png ${BASE}_bits_${i}_256_unc.png;
#	fi;
#done
optipng -clobber -o 7 -out ${BASE}_bits_32_256.png ${BASE}_bits_32_256_unc.png;

echo Converting to favicon.ico...

icotool -c -o "${BASE}.ico" $(for i in ${size[@]}; do for j in ${bits[@]}; do if [ "$i" == "256" -a "$j" == "32" ]; then printf "\\055r";else printf "\\055\\055bit-depth=$j\n";fi;printf "${BASE}_bits_${j}_${i}.png\n";done;done)
