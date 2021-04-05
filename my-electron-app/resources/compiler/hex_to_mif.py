#!python

'''
Usage: IP_VGA_Palettized_Img_to_Mif.py <palette.png> <image.png> <palette_width>
'''

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


curr_addr_write = 0
output_filename = sys.argv[1].split('.')[0] + ".mif"
out = ""
with open(sys.argv[1], "r") as in_vh:
    for line in in_vh:
        if (line[0] == '@'):
            new_addr = int(line.strip('@'), 16)
            while (curr_addr_write < new_addr):
                out = out + (str(format(curr_addr_write, 'x')) + ": 0;\n")
                curr_addr_write += 1
        else:
            words = line.strip('\n').split(' ')
            for word in words:
                out = out + (str(format(curr_addr_write, 'x')) + ": " + word + ";\n")
                curr_addr_write += 1
    
    out = out + "END;"
    out = "\nCONTENT\nBEGIN\n" + out
    out = "DATA_RADIX = HEX;\n" + out
    out = "ADDRESS_RADIX = HEX;\n" + out
    out = "WIDTH = 32;\n" + out
    out = "DEPTH = " + str(curr_addr_write) + ";\n" + out

with open(output_filename, "w") as out_fh:
    out_fh.write(out)
