from verilog_generation.test import *

MGK = "&^\"%$"

def test_command():
    return MGK + "test_command_line.py" + MGK + "test2" + MGK + "test3"

def add_module(module_type):
    global MGK
    return MGK + "add_module.py" + MGK + module_type

def remove_module(module_UUID):
    global MGK
    return MGK + "remove_module.py" + MGK + module_UUID

def change_parameter(module_UUID, parameter_name, new_value):
    global MGK
    return MGK + "change_parameter.py" + MGK + module_UUID + MGK + parameter_name + MGK + new_value

def rearrange_module(module_UUID, target_index):
    global MGK
    return MGK + "rearrange_module.py" + MGK + module_UUID + MGK + target_index

def generate():
    global MGK
    return MGK + "generator.py"