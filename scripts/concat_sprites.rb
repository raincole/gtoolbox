#!/usr/bin/env ruby

# Make sprite sheet from image sequence
# Usage: scripts/concat_sprite.rb android/assets/img/sprite/character/matty/idle-1 5
# which reads 'idle-1_???x???_xxxx.png files and output ???x???/matty.png, 5 columns per row

require 'json'
require 'rmagick'
include Magick

name = ARGV[0]
columns = ARGV[1]
config_path = File.join(File.dirname(__FILE__), 'config')
resolution_config = JSON.parse(File.read(File.join(config_path,'/resolution.json')), :symbolize_names => true)

resolution_config[:widths].each do |width|
  height = resolution_config[:baseHeight] * width / resolution_config[:baseWidth]
  resolution= "#{width}x#{height}"
  input = "#{name}_#{resolution}_*.png"
  dirname = File.dirname(input)
  output_dir = "#{dirname}/#{resolution}"
  basename = File.basename(name)
  output = "#{output_dir}/#{basename}.png"
  Dir.mkdir(output_dir) unless File.exists?(output_dir)
  puts "Output file #{output}..."
  puts `montage -mode concatenate -background none -tile #{columns}x #{input} #{output}`
  puts `rm #{input}`
  
end


