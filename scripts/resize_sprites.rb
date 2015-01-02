#!/usr/bin/env ruby

# Resample spirits exported by Photoshop
# Usage: scripts/resize_spirits android/assets/img/sprite/food/carrot
# which reads carrot_xxxx_yyyy.png files and output carrot_???x???_xxxx.png files
#
require 'rmagick'
include Magick

BASE_WIDTH = 960
BASE_HEIGHT = 1536
scales = [2, 4, 6, 8, 10, 12]

image_name = ARGV[0]
Dir["#{image_name}_*.png"].each do |input_path|
  match = /#{image_name}_(\d+).*\.png/.match(input_path)
  index = match[1]

  puts "#{input_path} -> "

  scales.each do |scale|
    width = BASE_WIDTH * scale / 12
    height = BASE_HEIGHT * scale / 12
    resolution = "#{width}x#{height}"
    output_path = "#{image_name}_#{resolution}_#{index}.png"
    
    origin_image = ImageList.new(input_path)[0]
    scaled_image = origin_image.resize(origin_image.columns * scale / 12, origin_image.rows * scale / 12)
    scaled_image.write(output_path)

    puts "\t #{output_path}"
  end

  File.delete(input_path)
end
