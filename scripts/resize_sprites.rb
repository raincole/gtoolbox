#!/usr/bin/env ruby

# Resample spirits exported by Photoshop
# Usage: scripts/resize_sprites.rb android/assets/img/sprite/food/carrot
# which reads carrot_xxxx_yyyy.png files and output carrot_???x???_xxxx.png files
#
require 'json'
require 'rmagick'
include Magick

config_path = File.join(File.dirname(__FILE__), 'config')
resolution_config = JSON.parse(File.read(File.join(config_path,'/resolution.json')), :symbolize_names => true)

image_name = ARGV[0]
Dir["#{image_name}_*.png"].each do |input_path|
  match = /#{image_name}_(\d+).*\.png/.match(input_path)
  index = match[1]

  puts "#{input_path} -> "

  resolution_config[:widths].each do |width|
    base_width = resolution_config[:baseWidth]
    height = resolution_config[:baseHeight] * width / resolution_config[:baseWidth]
    resolution= "#{width}x#{height}"
    output_path = "#{image_name}_#{resolution}_#{index}.png"
    
    origin_image = ImageList.new(input_path)[0]
    scaled_image = origin_image.resize(origin_image.columns * width / base_width, origin_image.rows * width / base_width)
    scaled_image.write(output_path)

    puts "\t #{output_path}"
  end

  File.delete(input_path)
end
