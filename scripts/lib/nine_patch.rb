require 'rmagick'
include Magick

def scaled(int, scale)
  (int.to_f * scale).round
end

def clamped(value, min, max)
  [[value, min].max, max].min
end

def apply_patch(original_image_path, scaled_image_path)
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

  scaled_image = ImageList.new(scaled_image_path)[0]
  scale = scaled_image.columns.to_f / original_image.columns

  width = scaled_image.columns + 2
  height = scaled_image.rows + 2
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

  puts "======================================================="
  puts "scaled patch: (#{scaled_patch_left}, #{scaled_patch_right}) x (#{scaled_patch_top}, #{scaled_patch_bottom})"
  puts "scaled padding: (#{scaled_padding_left}, #{scaled_padding_right}) x (#{scaled_padding_top}, #{scaled_padding_bottom})"

  patched_image.composite!(scaled_image, 1, 1, AddCompositeOp)

  patched_image
end