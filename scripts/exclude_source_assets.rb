#!/usr/bin/env ruby

require 'fileutils'
require 'json'

recover = ARGV[0] == '-r'

if recover
  dict = JSON.parse(File.read('tmp/dict.json'))

  dict.each.with_index do |path, i|
    FileUtils.mv("tmp/#{i}", path)
  end

  File.delete('tmp/dict.json')
else
  dict = []
  FileUtils.mkdir('tmp') unless File.exists?('tmp')

  Dir['*/**/*.psd', '*/**/*.ai', '*/**/*.ttf', '*/**/unpacked/**/*.*'].uniq.each.with_index do |path, i|
    FileUtils.mv(path, "tmp/#{i}")
    dict[i] = path
  end

  File.open('tmp/dict.json', 'w') do |file|
    file.write(dict.to_json)
  end
end
