#!/usr/bin/env ruby

# Generate Bitmap Font
# Usage: scripts/generate_bitmap_font.rb ~/AndroidStudioProjects/tools/libgdx/dist android/assets/font/overview/*.hiero.erb

require 'erb'
require 'json'

class ERBContext
  attr_accessor :dir
  attr_accessor :base_width
  attr_accessor :real_width

  def characters_from(*globs)
    str = ""
    globs.each do |glob|
      str += Dir[glob].map { |filename| File.read(filename) }.join
    end
    str.split.to_a.uniq.join
  end

  def standard_characters
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"!`?\'.,;:()[]{}<>|/@\^$-%+=#_&~*'
  end

  def scale_to_real_size(size)
    size * real_width / base_width
  end

  def path_to(filename)
    File.join(dir, filename)
  end

  def get_bindings
    binding
  end
end

heiro_path = ARGV[0]
font_glob = ARGV[1]
config_path = File.join(File.dirname(__FILE__), 'config')
resolution_config = JSON.parse(File.read(File.join(config_path,'/resolution.json')), :symbolize_names => true)

Dir[font_glob].each do |setting_erb_path|
  next unless setting_erb_path.end_with?('.hiero.erb')

  setting_path = setting_erb_path.gsub(/\.erb$/, '')
  font_name = setting_path.gsub(/\.hiero$/, '').split('/')[-1]

  context = ERBContext.new
  context.base_width = resolution_config[:baseWidth]
  context.dir = File.dirname(File.absolute_path(setting_path))

  resolution_config[:widths].each do |width|
    context.real_width = width
    height = resolution_config[:baseHeight] * width / resolution_config[:baseWidth]
    File.open(setting_path, 'w') do |f|
      f.write(ERB.new(File.read(setting_erb_path)).result(context.get_bindings))
    end

    pwd = Dir.pwd
    Dir.chdir(heiro_path)

    absolute_setting_path = File.join(pwd, setting_path)
    absolute_resolution_dir = File.join(File.dirname(absolute_setting_path), "#{width}x#{height}")
    Dir.mkdir(absolute_resolution_dir) unless File.exists?(absolute_resolution_dir)
    absolute_output_path = File.join(absolute_resolution_dir, font_name)
    puts `java -cp gdx.jar:gdx-natives.jar:gdx-backend-lwjgl.jar:gdx-backend-lwjgl-natives.jar:extensions/gdx-tools/gdx-tools.jar com.badlogic.gdx.tools.hiero.Hiero -b -i #{absolute_setting_path} -o #{absolute_output_path}`

    Dir.chdir(pwd)

    File.delete(setting_path)
  end
end
