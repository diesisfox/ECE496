#!python

'''
Usage: IP_VGA_Palettized_Img_to_Mif.py <palette.png> <image.png> <palette_width>
'''

from PIL import Image
import sys
from sys import exit


def write_mif_hex(data, width, filename):
    out = f"DEPTH = {len(data)};\n"\
        f"WIDTH = {width};\n"\
        f"ADDRESS_RADIX = HEX;\n"\
        f"DATA_RADIX = HEX;\n"\
        f"\n"\
        f"CONTENT\n"\
        f"BEGIN\n"
    for i in range(len(data)):
        out += f"{hex(i)[2:]}: {hex(data[i])[2:]};\n"
    out += f"END;\n"
    with open(filename, "w") as f:
        f.write(out)


def write_txt_hex(data, width, filename):
    out = ""
    for i in range(len(data)):
        out += f"{hex(data[i])[2:]}\n"
    with open(filename, "w") as f:
        f.write(out)


with Image.open(sys.argv[1]) as palette:
    palette = palette.convert(mode='RGBA')
    colors = set(palette.getdata())
    colors.remove((0, 255, 0, 0))
    with Image.open(sys.argv[2]) as img:
        img = img.convert(mode='RGBA')
        data = list(img.getdata())
        img_colors = set(data)
        if img_colors != colors:
            print("image colors don't match palette colors:")
            print(set(img_colors))
            print(set(colors))
            exit(-1)
        img_colors = list(img_colors)
        p_indexes = [img_colors.index(c) for c in data]
        write_mif_hex(p_indexes, sys.argv[3], sys.argv[2]+".mif")
        write_txt_hex(p_indexes, sys.argv[3], sys.argv[2]+".hex")
        img_colors = [c[2]<<16 | c[1]<<8 | c[0] for c in img_colors]
        write_mif_hex(img_colors, 24, sys.argv[1]+".mif")
        write_txt_hex(img_colors, 24, sys.argv[1]+".hex")