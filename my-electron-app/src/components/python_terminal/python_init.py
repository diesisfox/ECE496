import sys, json, os

print("Python " + sys.version.split()[0])

#def readSave(path):

#current_dirname = os.path.join(input(), '..')

#print("hello" + sys.stdin.readline())

#os.chdir(current_dirname)

#from python_terminal.system_function_wrappers import *
MGK = "&^\"%$"

def add_module(module_type):
    print(MGK + "2" + MGK + "modify.py" + MGK + "add_module" + MGK + module_type)

def remove_module(module_UUID):
    print(MGK + "2" + MGK + "modify.py" + MGK + "remove_module" + MGK +  module_UUID)

def change_parameter(module_UUID, parameter_name, new_value):
    print(MGK + "2" + MGK + "modify.py" + MGK + "change_parameter"  + MGK + module_UUID + MGK + parameter_name + MGK + new_value)

def rearrange_module(module_UUID, target_index):
    print(MGK + "2" + MGK + "modify.py" + MGK + "rearrange_module"  + MGK + module_UUID + MGK + target_index)

def validate():
    print(MGK + "1" + MGK + "modify.py" + MGK + "validate")

def generate():
    print(MGK + "0" + MGK + "generator.py")
