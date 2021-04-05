#!python

'''
Usage: IP_VGA_Img_to_Palettized_Mif.py <input.png> <palette_width>
'''

import sys
from sys import exit
import subprocess


subprocess.run(["ffmpeg",
    "-i", sys.argv[1],
    "-vf", f"palettegen={min(2**int(sys.argv[2])+1, 256)}",
    "-y", f"{sys.argv[1]}.palette.png"])

subprocess.run(["ffmpeg",
    "-i", sys.argv[1],
    "-i", f"{sys.argv[1]}.palette.png",
    "-filter_complex", "paletteuse",
    "-y", f"{sys.argv[1]}.p{2**int(sys.argv[2])}.png"])

subprocess.run(["python", "./IP_VGA_Palettized_Img_to_Mif.py",
    f"{sys.argv[1]}.palette.png",
    f"{sys.argv[1]}.p{2**int(sys.argv[2])}.png",
    sys.argv[2]])
