#!/usr/bin/env ruby

pngs = Dir['*/**/*.png'].select { |path| !path.include?('intermediates') }
pngs.each do |p|
  puts "Processing #{p}..."
  `pngquant -f --ext .png #{p}`
end
