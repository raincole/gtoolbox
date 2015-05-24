#!/usr/bin/env ruby

updated_only = ARGV[0] == '-u'

if updated_only
  pngs = `git status`.split.select { |path| path =~ /\.png$/ }
else
  pngs = Dir['*/**/*.png'].select { |path| !path.include?('intermediates') }
end
pngs.each do |p|
  puts "Processing #{p}..."
  `pngquant -f --ext .png #{p}`
end
