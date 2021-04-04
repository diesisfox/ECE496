#!/usr/bin/python3

import sys

def flip(in_filename, out_filename):
    with open(in_filename, "r") as in_file:
        with open(out_filename, "w") as out_file:
            for line in in_file:
                if (line[0] != '@'):
                    splits = line.strip('\n').split(' ')
                    out_line = ""
                    for split in splits:
                        out_line = out_line + "".join(reversed([split[i:i+2] for i in range(0, len(split), 2)]))
                        out_line = out_line + " "
                    out_line = out_line[:-1] + "\n"
                    out_file.write(out_line)
                else:
                    addr = int(line[1:], 16)
                    if addr%4 != 0:
                        raise "Address Alignment Uh Oh!"
                    out_file.write('@{0:08X}\n'.format(int(addr/4)))
    return

def main():
    # print("len(argv) = ", len(sys.argv))
    if (len(sys.argv) != 3):
        print("Usage: ./endian_flip.py <input_file> <output file>.")
    else:
        flip(sys.argv[1], sys.argv[2])
    
    return

if __name__ == '__main__':
    main()
