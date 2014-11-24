#!/usr/bin/env bash

# Make sprite sheet from image sequence
# Usage: tools/concat_sprite matty 5
# which reads 'matty_???x???_xxxx.png files and output ???x???/matty.png, 5 columns per row

scales=(2 4 6 8 10 12)
for scale in ${scales[@]}
do
    resolution="$((960*scale/12))x$((1536*scale/12))"
    input="${1}_${resolution}_*.png"
    dirname=$(dirname ${1})
    basename=$(basename ${1})
    output_dir="${dirname}/${resolution}"
    output="${output_dir}/${basename}.png"
    mkdir $output_dir &> /dev/null
    montage -mode concatenate -background none -tile ${2}x $input $output &&
        rm $input
done


