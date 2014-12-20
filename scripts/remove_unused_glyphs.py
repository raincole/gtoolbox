#!/usr/bin/env python

import argparse
import sys
import io
import glob
import fontforge

parser = argparse.ArgumentParser(description='Remove unused glyphs from a font to reduce size')
parser.add_argument('font', help='original font')
parser.add_argument('-t', '--text', nargs='+', required=True, help='text files including the characters to keep(support glob)')
parser.add_argument('-o', '--output', required=True, help='name of the output file(reduced font)')

args = parser.parse_args()

character_set = set()

for fileglob in args.text:
  for filename in glob.glob(fileglob):
    with io.open(filename, encoding='utf-8', mode='r') as f:
      character_set = character_set.union(set(f.read()))

print('Character Set: ')
for char in character_set:
  sys.stdout.write(char.encode('utf-8'))

print('\nGenerating Font...')

character_points = [ord(c) for c in character_set]

font = fontforge.open(args.font)

font.selection.select(*character_points)
font.copy()

new_font = fontforge.font()
new_font.encoding = font.encoding
new_font.fontname = font.fontname
new_font.selection.select(*character_points)
new_font.paste()

new_font.generate(args.output)

print('Generated %s' % args.output)


