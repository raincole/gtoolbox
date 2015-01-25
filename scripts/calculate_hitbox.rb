#!/usr/bin/env ruby

# Usage: scripts/calculate_hitbox.rb android/assets/img/sprite/character/matty/960x1536/idle-1.png android/assets/img/sprite/character/matty/+hitbox+idle_1.json 4 5
# which calculate hitbox of 'idle-1.png', which is 4x5 spritesheet
# and output to '+hitbox+idle-1.json'

require 'json'
require 'rmagick'
include Magick

input_path = ARGV[0]
output_path = ARGV[1]
rows = ARGV[2].to_i
cols = ARGV[3].to_i

puts "Reading image #{input_path}..."

image = ImageList.new(input_path)[0]
frame_width = image.columns / cols
frame_height = image.rows / rows

hitboxes = []
(rows * cols).times do |index|
  left = bottom = 1e9
  right = top = 0
  base_x = index % cols * frame_width
  base_y = (index / cols) * frame_height

  image.get_pixels(base_x, base_y, frame_width, frame_height).each_with_index do |pixel, i|
    x = i % frame_width
    y = frame_height - 1 - i / frame_width
    if pixel.opacity == 0
      left = [x, left].min
      right = [x, right].max
      bottom = [y, bottom].min
      top = [y, top].max
    end

    hitboxes[index] = {
      :x => left,
      :y => bottom,
      :width => right - left + 1,
      :height => top - bottom + 1,
    }
  end
end

puts "Writing #{output_path}..."

File.open(output_path, 'w') do |file|
  file.write(JSON.pretty_generate({
    :hitboxes => hitboxes}
  ))
end



