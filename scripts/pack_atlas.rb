#!/usr/bin/env ruby

# Pack images into texture atlas
# Usage: scripts/pack_atlas.rb ~/AndroidStudioProjects/tools/libgdx/dist android/assets/img/overlay/unpacked packed

require 'json'

tool_dir = ARGV[0]
input_dir = File.expand_path(ARGV[1])
output_dir = File.join(input_dir.split('/')[0...-1].join('/'), ARGV[2])
config_path = File.join(File.dirname(__FILE__), 'config')
resolution_config = JSON.parse(File.read(File.join(config_path,'/resolution.json')), :symbolize_names => true)

packer_config = <<CONFIG
{
  paddingX: 0,
  paddingY: 0,
  edgePadding: false
}
CONFIG

Dir.chdir(tool_dir)

resolution_config[:widths].each do |width|
  height = resolution_config[:baseHeight] * width / resolution_config[:baseWidth]
  scale_suffix = "#{width}x#{height}"
  scaled_input_dir = File.join(input_dir, scale_suffix)
  scaled_output_dir = File.join(output_dir, scale_suffix)
  Dir.mkdir(output_dir) unless File.exists?(output_dir)
  pack_config_filepath = File.join(scaled_input_dir, 'pack.json')
  File.open(pack_config_filepath, 'w') { |f| f.write(packer_config) }

  puts `java -cp gdx.jar:extensions/gdx-tools/gdx-tools.jar com.badlogic.gdx.tools.texturepacker.TexturePacker #{scaled_input_dir} #{scaled_output_dir}`

  File.delete(pack_config_filepath)
end
