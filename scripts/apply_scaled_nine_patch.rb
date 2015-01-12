#!/usr/bin/env ruby

# Extract nine-patch border from original image and apply to scaled images
# Usage: scripts/apply_scaled_nine_patch.rb android/assets/img/ui/overlay/unpacked speech_bubble_up
# which reads '960x1536/speech_bubble_up.9.png file, apply its nine-patch to
# ???x???/speech_bubble_up.png files, and output ???x???/speech_bubble_up.9.png

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lib/nine_patch.rb'
require 'json'

base_dir = ARGV[0]
file_name = ARGV[1]
config_path = File.join(File.dirname(__FILE__), 'config')
resolution_config = JSON.parse(File.read(File.join(config_path,'/resolution.json')), :symbolize_names => true)

def non_patched_file_path(file_path)
  file_path.gsub('.9.png', '.png')
end

def delete_non_patched_file(patched_file_path)
  non_patched = non_patched_file_path(patched_file_path)
  File.delete(non_patched) if File.exist?(non_patched)
end


original_image_path = File.join(base_dir, "#{resolution_config[:baseWidth]}x#{resolution_config[:baseHeight]}", file_name + '.9.png')

resolution_config[:widths].each do |width|
  height = resolution_config[:baseHeight] * width / resolution_config[:baseWidth]
  resolution = "#{width}x#{height}"
  scaled_image_path = File.join(base_dir, resolution, file_name + '.png')
  patched_image = apply_patch(original_image_path, scaled_image_path)

  patched_image_path = File.join(base_dir, resolution, file_name + '.9.png')
  patched_image.write(patched_image_path)

  puts "scaled file: #{patched_image_path}"

  delete_non_patched_file(patched_image_path)
end

delete_non_patched_file(original_image_path)


