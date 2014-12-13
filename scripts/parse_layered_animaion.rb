#!/usr/bin/env ruby

# Parse position, scale and rotation from layered animation(like food or cosmetic)
# Usage: scripts/parse_layered_animation.rb android/assets/img/character/matty +food+eat_normal_1 240 240
# which reads position/scale/rotation from '+food+eat_normal_1_****.png files
# and frame information from '+food+eat_normal_1.json' file
# and then write back into '+food+eat_normal_1.json'
# assuming the size of original food image is 240, 240

require 'json'
require 'rmagick'
include Magick

base_dir = ARGV[0]
file_name = ARGV[1]
original_width = ARGV[2].to_f
original_height = ARGV[3].to_f

json_path = File.join(base_dir, file_name+'.json')

puts "Reading JSON #{json_path}..."

frames = JSON.parse(File.read(json_path))['__frames__'];

image_blob = File.join(base_dir,file_name+'*.png')
info = []

Dir[image_blob].map do |image_path|
  puts "Reading image #{image_path}..."

  index = image_path.match('.*_(\d+)\.png')[1].to_i
  image = ImageList.new(image_path)[0]
  top_x = top_y = nil
  bottom_x = bottom_y = nil
  image.each_pixel do |pixel, c, r|
    if pixel.red > pixel.blue && pixel.red > pixel.green
      bottom_x = c.to_f
      bottom_y = (image.rows - 1 - r).to_f
    end
    if pixel.blue > pixel.red && pixel.blue > pixel.green
      top_x = c.to_f
      top_y = (image.rows - 1 - r).to_f
    end
  end  

  if top_x && bottom_x
    position = {
      :x => (bottom_x + top_x) / 2,
      :y => (bottom_y + top_y) / 2
    }

    delta_x = top_x - bottom_x
    delta_y = top_y - bottom_y
    length = Math.hypot(delta_x, delta_y)

    scale = {
      :x => length / original_width,  # assume it's equal to y
      :y => length / original_height,
    }

    rotation = Math.acos(
      (delta_x*0 + delta_y*original_height) / (original_height * length)
    )
    rotation = 360 - rotation if 0 * delta_y - original_height * delta_x < 0

    info[index] = {
      :visible => true,
      :position => position,
      :scale => scale,
      :rotation => rotation,
    }
  else
    info[index] = {
      :visible => false,
    }
  end
end

if info.length != frames.length
  puts "Abort! Extract #{info.length} frames from images, but #{frames.length} in #{json_path}."
  exit
end

info = info.zip(frames).map { |ia, f| ia[:frame] = f; ia }

File.open(json_path, 'w') do |file|
  file.write(JSON.pretty_generate({
    '__frames__' => frames,
    :info => info}
  ))
end

Dir[image_blob].each do |image_path|
  File.delete(image_path)
end


