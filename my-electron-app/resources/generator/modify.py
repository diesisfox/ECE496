#!python

import sys
import json
import pprint
import re
import uuid
from enum import Enum
from sys import exit


pp = pprint.PrettyPrinter(indent=2)
IP_DATABASE_PATH: str = "../peripherals/ip.json"
GPIO_PINS_LIST: list = ["GPIO0_["+str(i)+"]" for i in range(36)] + ["GPIO1_["+str(i)+"]" for i in range(36)]
PINMAP_INTNAME_INDEX = 0
PINMAP_EXTNAME_INDEX = 1
PINMAP_DIR_INDEX = 2

PROJECT_JSON_POS = 1
COMMAND_POS = 2


class Errors(Enum):
    NO_ERR = 0
    UNKNOWN_ERR = -1
    BAD_ARGS = -2
    BAD_JSON = -3
    BAD_MODULE_TYPE = -4
    BAD_PROJ = -5
    NONEXISTENT_GPIO_RESERVATION = -6
    OUT_OF_FREE_GPIOS = -7


def wrangle_gpio_pinmap(gpio_module: dict) -> None:
    new_gpio_width = int(gpio_module['parameters']['Width'])
    pinmap: list = gpio_module['pinmaps'][1]
    old_pinmap_width = len(pinmap)
    if new_gpio_width > old_pinmap_width:
        for i in range(old_pinmap_width, new_gpio_width):
            pinmap.append([f"pins[{i}]", "GPIO", "inout"])
    elif new_gpio_width < old_pinmap_width:
        for i in range(old_pinmap_width - new_gpio_width):
            pinmap.pop()
    pass


def hex_str_to_int(hex_str: str) -> int:
    return int(hex_str, 16)


def int_to_hex_str(num: int) -> str:
    return '{0:09_X}'.format(num)


def get_next_address(ip_json: dict, project_json: list, addr_bits: int) -> str:
    max_addr = 0
    for module in project_json:
        if 'Base Address' not in module['parameters']:
            continue
        start_addr = hex_str_to_int(module['parameters']['Base Address'])
        addr_size = 2 ** ip_json[module['moduleType']]['addrBits']
        end_addr = start_addr + addr_size
        max_addr = max(max_addr, end_addr)
    if max_addr & ((1 << addr_bits) - 1):
        max_addr = (max_addr & ~((1 << addr_bits) - 1)) + (1 << addr_bits)
    return int_to_hex_str(max_addr)


def get_module_index_by_uuid(project_json: list, module_uuid: str) -> int:
    index = -1
    for i in range(len(project_json)):
        if project_json[i]['UUID'] == module_uuid:
            if index != -1:
                print(f"ERROR[{Errors.BAD_PROJ}]: >=2 ENTRIES WITH THE SAME UUID")
                exit(Errors.BAD_PROJ.value)
            index = i
    if index == -1:
        print(f"ERROR[{Errors.BAD_PROJ}]: NO ENTRIES WITH SPECIFIED UUID")
        exit(Errors.BAD_PROJ.value)
    return index


def add_module(ip_json: dict) -> None:
    if len(sys.argv) != 4:
        print(f"ERROR[{Errors.BAD_ARGS}]: WRONG # OF ARGS FOR VERB add_module")
        exit(Errors.BAD_ARGS.value)
    project_json = load_json(sys.argv[PROJECT_JSON_POS])
    module_type = sys.argv[3]
    if module_type not in ip_json:
        print(f"ERROR[{Errors.BAD_MODULE_TYPE}]: NONEXISTENT MODULE TYPE: {module_type}")
        exit(Errors.BAD_MODULE_TYPE.value)
    ip: dict = ip_json[module_type]
    # module skeleton
    m = {
        "moduleType": ip['moduleType'],
        "UUID": uuid.uuid4().hex.upper(),
        "parameters": {},
        "pinmaps": []
    }
    # populate parameters
    for k, v in ip['parameters'].items():
        if k == "Verilog Instance Name":
            m['parameters'][k] = f"{ip['verilogName']}_{m['UUID']}"
        elif k == "Base Address":
            m['parameters'][k] = get_next_address(ip_json, project_json, ip['addrBits'])
            pass
        elif k == "System Bus Frequency (Hz)":
            m['parameters'][k] = str(100_000_000)
            # TODO: figure this out
            pass
        elif 'default' in v:
            m['parameters'][k] = v['default']
        else:
            m['parameters'][k] = ""
    # populate pinmaps
    for iface in ip['interfaces']:
        m['pinmaps'].append(iface['pinmap'])
    if module_type == "GPIO":
        wrangle_gpio_pinmap(m)
    # append m to project
    project_json.append(m)
    # output
    print(json.dumps(project_json))


def remove_module(ip_json: dict) -> None:
    if len(sys.argv) != 4:
        print(f"ERROR[{Errors.BAD_PROJ}]: WRONG # OF ARGS FOR VERB remove_module")
        exit(Errors.BAD_ARGS.value)
    project_json = load_json(sys.argv[PROJECT_JSON_POS])
    module_uuid = sys.argv[3]
    if not project_json:
        print(f"ERROR[{Errors.BAD_JSON}]: CAN'T REMOVE FROM AN EMPTY PROJECT")
        exit(Errors.BAD_JSON)
    index = get_module_index_by_uuid(project_json, module_uuid)
    project_json.pop(index)
    # output
    print(json.dumps(project_json))


def change_parameter(ip_json: dict) -> None:
    if len(sys.argv) != 6:
        print(f"ERROR[{Errors.BAD_ARGS}]: WRONG # OF ARGS FOR VERB change_parameter")
        exit(Errors.BAD_ARGS.value)
    project_json = load_json(sys.argv[PROJECT_JSON_POS])
    module_uuid = sys.argv[3]
    param_name = sys.argv[4]
    new_value = sys.argv[5]
    if not project_json:
        print(f"ERROR[{Errors.BAD_JSON}]: NOTHING TO CHANGE IN AN EMPTY PROJECT")
        exit(Errors.BAD_JSON)
    module: dict = project_json[get_module_index_by_uuid(project_json, module_uuid)]
    parameters: dict = module['parameters']
    ip: dict = ip_json[module['moduleType']]
    if param_name not in parameters:
        print(f"ERROR[{Errors.BAD_ARGS}]: MODULE {module['moduleType']} DOES NOT HAVE PARAMETER {param_name}")
        exit(Errors.BAD_ARGS.value)
    # validate parameter
    if param_name == "Base Address":
        addr_int = hex_str_to_int(new_value)
        if addr_int < 0x0000_0000 or addr_int > 0xffff_ffff:
            print(f"ERROR[{Errors.BAD_ARGS}]: NEW BASE ADDRESS OUT OF BOUNDS")
            exit(Errors.BAD_ARGS.value)
    if param_name == "Verilog Instance Name":
        res = re.search(r"^[a-zA-Z_][a-zA-Z_$0-9]*$", new_value)
        if (not res) or (res.group() != new_value):
            print(f"ERROR[{Errors.BAD_ARGS}]: NEW INSTANCE NAME NOT A VALID VARIABLE NAME")
            exit(Errors.BAD_ARGS.value)
    if 'max' in ip['parameters'][param_name]:  # soft clamp, assume Int
        new_value = str(min(int(ip['parameters'][param_name]['max']), int(new_value)))
    if 'min' in ip['parameters'][param_name]:  # soft clamp, assume Int
        new_value = str(max(int(ip['parameters'][param_name]['min']), int(new_value)))
    # TODO: more cases?
    # set parameter
    parameters[param_name] = new_value
    # GPIO wrangling
    if module['moduleType'] == "GPIO" and param_name == "Width":
        wrangle_gpio_pinmap(module)
    # output
    print(json.dumps(project_json))


def rearrange_module(ip_json: dict) -> None:
    if len(sys.argv) != 5:
        print(f"ERROR[{Errors.BAD_ARGS}]: WRONG # OF ARGS FOR VERB rearrange_module")
        exit(Errors.BAD_ARGS.value)
    project_json = load_json(sys.argv[PROJECT_JSON_POS])
    module_uuid = sys.argv[3]
    new_pos = int(sys.argv[4])
    if not project_json:
        print(f"ERROR[{Errors.BAD_JSON}]: CAN'T REARRANGE IN AN EMPTY PROJECT")
        exit(Errors.BAD_JSON)
    if new_pos < 0 or new_pos >= len(project_json):
        print(f"ERROR[{Errors.BAD_ARGS}]: NEW INDEX FOR REARRANGE OUT OF BOUNDS")
        exit(Errors.BAD_ARGS.value)
    index = get_module_index_by_uuid(project_json, module_uuid)
    module = project_json.pop(index)
    project_json = project_json[0:new_pos] + [module] + project_json[new_pos:]
    # output
    print(json.dumps(project_json))


def load_json(json_str: str) -> list:
    res = re.search(r"\.json$", json_str, re.IGNORECASE)
    project_json = None
    # load from file
    if res:
        with open(json_str, 'r+') as file:
            try:
                project_json = json.load(file)
            except json.decoder.JSONDecodeError:
                print(f"ERROR[{Errors.BAD_JSON}]: INVALID JSON INPUT FROM FILE {json_str}")
                exit(Errors.BAD_JSON)
    # load from json
    else:
        try:
            project_json = json.loads(json_str)
        except json.decoder.JSONDecodeError:
            print(f"ERROR[{Errors.BAD_JSON}]: INVALID JSON INPUT FROM ARGV")
            exit(Errors.BAD_JSON)
    # initialize empty input
    if not project_json:
        project_json = []
    return project_json


def load_ip_json() -> dict:
    ip_json = None
    with open(IP_DATABASE_PATH, 'r+') as file:
        try:
            ip_json = json.load(file)
        except json.decoder.JSONDecodeError:
            print(f"ERROR[{Errors.BAD_JSON}]: INVALID JSON INPUT FROM FILE {IP_DATABASE_PATH}")
            exit(Errors.BAD_JSON.value)
    return ip_json


def main():
    if len(sys.argv) < 2:  # argv[0] is "$script.py"
        print(f"ERROR[{Errors.BAD_ARGS}]: NO VERB SPECIFIED")
        exit(Errors.BAD_ARGS.value)
    else:
        ip_json = load_ip_json()
        if sys.argv[COMMAND_POS] == "add_module":
            add_module(ip_json)
        elif sys.argv[COMMAND_POS] == "remove_module":
            remove_module(ip_json)
        elif sys.argv[COMMAND_POS] == "change_parameter":
            change_parameter(ip_json)
        elif sys.argv[COMMAND_POS] == "rearrange_module":
            rearrange_module(ip_json)
        else:
            print(f"ERROR[{Errors.BAD_ARGS}]: UNKNOWN VERB: {sys.argv[COMMAND_POS]}")
            exit(Errors.BAD_ARGS.value)
            pass
        exit(Errors.NO_ERR.value)


if __name__ == '__main__':
    # try:
        main()
    # except:
    #     e = sys.exc_info()[0]
    #     print(f"ERROR[{Errors.UNKNOWN_ERR}]: GENERATION FAILED FOR UNCAUGHT REASON: {str(e)}")
    #     exit(Errors.UNKNOWN_ERR.value)
