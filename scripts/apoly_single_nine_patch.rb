#!/usr/bin/env ruby

# Extract nine-patch border from original image and apply to scaled images
# Usage: scripts/apply_scaled_nine_patch.rb android/assets/img/ui/overlay/unpacked/food-grid.9.png android/assets/img/ui/overlay/unpacked/food-item.png

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lib/nine_patch.rb'

original_image_path = ARGV[0]
scaled_image_path = ARGV[1]

def non_patched_file_path(file_path)
  file_path.gsub('.9.png', '.png')
end

def delete_non_patched_file(patched_file_path)
  non_patched = non_patched_file_path(patched_file_path)
  File.delete(non_patched) if File.exist?(non_patched)
end

patched_image = apply_patch(original_image_path, scaled_image_path)

patched_image_path = File.join(File.dirname(scaled_image_path), File.basename(scaled_image_path, '.png') + '.9.png')
patched_image.write(patched_image_path)

puts "scaled file: #{patched_image_path}"

delete_non_patched_file(original_image_path)
delete_non_patched_file(patched_image_path)

