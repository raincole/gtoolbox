#!/usr/bin/env ruby

# Extract nine-patch border from original image and apply to scaled images
# Usage: scripts/apply_scaled_nine_patch.rb android/assets/img/ui/overlay/unpacked speech_bubble_up
# which reads '960x1536/speech_bubble_up.9.png file, apply its nine-patch to
# ???x???/speech_bubble_up.png files, and output ???x???/speech_bubble_up.9.png

require 'rmagick'
include Magick

def scaled(int, scale)
  (int.to_f * scale / 12).to_i
end

def clamped(value, min, max)
  [[value, min].max, max].min
end

BASE_WIDTH = 960
BASE_HEIGHT = 1536
scales = [2, 4, 6, 8, 10]

base_dir = ARGV[0]
file_name = ARGV[1]

original_image_path = File.join(base_dir, "#{BASE_WIDTH}x#{BASE_HEIGHT}", file_name + '.9.png')
original_image = ImageList.new(original_image_path)[0]
patch_top = patch_bottom = patch_left = patch_right = nil
padding_top = padding_bottom = padding_left = padding_right = nil
original_image.each_pixel do |pixel, c, r|
  if c == 0 && pixel.opacity == 0
    patch_top = r unless patch_top
    patch_bottom = r
  end
  if c == original_image.columns - 1 && pixel.opacity == 0
    padding_top = r unless padding_top
    padding_bottom = r
  end
  if r == 0 && pixel.opacity == 0
    patch_left = c unless patch_left
    patch_right = c
  end
  if r == original_image.rows - 1 && pixel.opacity == 0
    padding_left = c unless padding_left
    padding_right = c
  end
end

puts "original file: #{original_image_path}"
puts "original patch: (#{patch_left}, #{patch_right}) x (#{patch_top}, #{patch_bottom})"
puts "original padding: (#{padding_left}, #{padding_right}) x (#{padding_top}, #{padding_bottom})"

scales.each do |scale|
  resolution = "#{BASE_WIDTH*scale/12}x#{BASE_HEIGHT*scale/12}"
  width = scaled(original_image.columns - 2, scale) + 2
  height = scaled(original_image.rows - 2, scale) + 2
  patched_image = Image.new(width, height) { self.background_color = 'transparent' }
  
  scaled_patch_top = clamped(scaled(patch_top, scale), 1, height - 2)
  scaled_patch_bottom = clamped(scaled(patch_bottom, scale), 1, height - 2)
  scaled_patch_left = clamped(scaled(patch_left, scale), 1, width - 2)
  scaled_patch_right = clamped(scaled(patch_right, scale), 1, width - 2)
  scaled_padding_top = clamped(scaled(padding_top, scale), 1, height - 2)
  scaled_padding_bottom = clamped(scaled(padding_bottom, scale), 1, height - 2)
  scaled_padding_left = clamped(scaled(padding_left, scale), 1, width - 2)
  scaled_padding_right = clamped(scaled(padding_right, scale), 1, width - 2)

  (scaled_patch_top..scaled_patch_bottom).each { |r| patched_image.pixel_color(0, r, 'black') }
  (scaled_patch_left..scaled_patch_right).each { |c| patched_image.pixel_color(c, 0, 'black') }
  (scaled_padding_top..scaled_padding_bottom).each { |r| patched_image.pixel_color(width - 1, r, 'black') }
  (scaled_padding_left..scaled_padding_right).each { |c| patched_image.pixel_color(c, height - 1, 'black') }

  scaled_image_path = File.join(base_dir, resolution, file_name + '.png')
  scaled_image = ImageList.new(scaled_image_path)[0]
  patched_image.composite!(scaled_image, 1, 1, AddCompositeOp)

  patched_image_path = File.join(base_dir, resolution, file_name + '.9.png')
  patched_image.write(patched_image_path)

  puts "======================================================="
  puts "scaled file: #{patched_image_path}"
  puts "scaled patch: (#{scaled_patch_left}, #{scaled_patch_right}) x (#{scaled_patch_top}, #{scaled_patch_bottom})"
  puts "scaled padding: (#{scaled_padding_left}, #{scaled_padding_right}) x (#{scaled_padding_top}, #{scaled_padding_bottom})"
end


