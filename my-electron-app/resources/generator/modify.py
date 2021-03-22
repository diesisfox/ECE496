#!python

import sys
import json
import pprint
import re
import uuid
from enum import Enum


pp = pprint.PrettyPrinter(indent=2)
IP_DATABASE_PATH: str = "../peripherals/ip.json"
GPIO_PINS_LIST: list = ["GPIO0_["+str(i)+"]" for i in range(36)] + ["GPIO1_["+str(i)+"]" for i in range(36)]
PINMAP_INTNAME_INDEX = 0
PINMAP_EXTNAME_INDEX = 1
PINMAP_DIR_INDEX = 2


class Errors(Enum):
    NO_ERR = 0
    UNKNOWN_ERR = -1
    BAD_ARGS = -2
    BAD_JSON = -3
    BAD_MODULE_TYPE = -4
    DUPLICATE_GPIO_RESERVATION = -5
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


def get_next_address(ip_json: dict, project_json: list, addrBits: str) -> str:
    width = hex_str_to_int(addrBits)
    max_addr = 0
    for module in project_json:
        if 'Base Address' not in module['parameters']:
            continue
        start_addr = hex_str_to_int(module['parameters']['Base Address'])
        addr_size = 2 ** hex_str_to_int(ip_json[module['moduleType']]['addrBits'])
        end_addr = start_addr + addr_size
        max_addr = max(max_addr, end_addr)
    if max_addr & ((1 << width) - 1):
        max_addr = (max_addr & ~((1 << width) - 1)) + (1 << width)
    return int_to_hex_str(max_addr)


def add_module(ip_json: dict) -> None:
    if len(sys.argv) != 4:
        print(f"ERROR[{Errors.BAD_ARGS}]: WRONG # OF ARGS FOR VERB add_module")
        exit(Errors.BAD_ARGS.value)
    project_json = load_json(sys.argv[2])
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
        print(f"ERROR[{Errors.BAD_ARGS}]: WRONG # OF ARGS FOR VERB remove_module")
        exit(Errors.BAD_ARGS.value)
    project_json = load_json(sys.argv[2])


def change_parameter(ip_json: dict) -> None:
    if len(sys.argv) != 6:
        print(f"ERROR[{Errors.BAD_ARGS}]: WRONG # OF ARGS FOR VERB change_parameter")
        exit(Errors.BAD_ARGS.value)
    project_json = load_json(sys.argv[2])


def rearrange_module(ip_json: dict) -> None:
    if len(sys.argv) != 5:
        print(f"ERROR[{Errors.BAD_ARGS}]: WRONG # OF ARGS FOR VERB rearrange_module")
        exit(Errors.BAD_ARGS.value)
    project_json = load_json(sys.argv[2])


def load_json(json_str: str) -> list:
    project_json = None
    try:
        project_json = json.loads(json_str)
    except json.decoder.JSONDecodeError:
        print(f"ERROR[{Errors.BAD_JSON}]: JSON DECODE ERROR")
        exit(Errors.BAD_JSON.value)
    if not project_json:
        # print(f"ERROR[{Errors.BAD_JSON}]: JSON EMPTY")
        # exit(Errors.BAD_JSON)
        # print(f"WARNING[{Errors.BAD_JSON}]: JSON EMPTY")
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
        if sys.argv[1] == "add_module":
            add_module(ip_json)
        elif sys.argv[1] == "remove_module":
            remove_module(ip_json)
        elif sys.argv[1] == "change_parameter":
            change_parameter(ip_json)
        elif sys.argv[1] == "rearrange_module":
            rearrange_module(ip_json)
        else:
            print(f"ERROR[{Errors.BAD_ARGS}]: UNKNOWN VERB")
            exit(Errors.BAD_ARGS.value)
            pass
        exit(Errors.NO_ERR.value)


if __name__ == '__main__':
    try:
        main()
    except:
        e = sys.exc_info()[0]
        print(f"ERROR[{Errors.UNKNOWN_ERR}]: GENERATION FAILED FOR UNCAUGHT REASON: {str(e)}")
        exit(Errors.UNKNOWN_ERR.value)
