MGK = "&^\"%$"

def add_module(module_type):
    global MGK
    return MGK + "2" + MGK + "modify.py" + MGK + "add_module" + MGK + module_type

def remove_module(module_UUID):
    global MGK
    return MGK + "2" + MGK + "modify.py" + MGK + "remove_module" + MGK +  module_UUID

def change_parameter(module_UUID, parameter_name, new_value):
    global MGK
    return MGK + "2" + MGK + "modify.py" + MGK + "change_parameter"  + MGK + module_UUID + MGK + parameter_name + MGK + new_value

def rearrange_module(module_UUID, target_index):
    global MGK
    return MGK + "2" + MGK + "modify.py" + MGK + "rearrange_module"  + MGK + module_UUID + MGK + target_index

def validate():
    return MGK + "1" + MGK + "validate.py"

def generate():
    global MGK
    return MGK + "0" + MGK + "generator.py"