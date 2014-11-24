#!/usr/bin/env ruby

# Pack images into texture atlas
# Usage: tools/pack_atlas.rb ~/AndroidStudioProjects/tools/libgdx/ android/assets/img/ui/overlay/unpacked ui

scales = [2, 4, 6, 8, 10, 12]
tool_dir = ARGV[0]
input_dir = File.expand_path(ARGV[1])
output_dir = File.join(input_dir.split('/')[0...-1].join('/'), ARGV[2])

packer_config = <<CONFIG
{
  paddingX: 0,
  paddingY: 0,
  edgePadding: false
}
CONFIG

Dir.chdir(tool_dir)

scales.each do |scale|
  scale_suffix = "#{960*scale/12}x#{1536*scale/12}"
  scaled_input_dir = File.join(input_dir, scale_suffix)
  scaled_output_dir = File.join(output_dir, scale_suffix)
  Dir.mkdir(output_dir) unless File.exists?(output_dir)
  pack_config_filepath = File.join(scaled_input_dir, 'pack.json')
  File.open(pack_config_filepath, 'w') { |f| f.write(packer_config) }

  puts `java -cp gdx.jar:extensions/gdx-tools/gdx-tools.jar com.badlogic.gdx.tools.texturepacker.TexturePacker #{scaled_input_dir} #{scaled_output_dir}`

  File.delete(pack_config_filepath)
end
