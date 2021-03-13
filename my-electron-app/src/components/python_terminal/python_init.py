import sys, json, os

print("Python " + sys.version.split()[0])

#def readSave(path):

current_dirname = os.path.join(input(), '..')

#print("hello" + sys.stdin.readline())

os.chdir(current_dirname)

from verilog_generation.test import *
#print(test())

