#!python

import sys
import json
import pprint
import re
from enum import Enum


helptxt = """
usage:
1)  client.py [i]
    interactively set up client process, run interactively.
    not planned until UI integration

2)  client.py i <ur_conf>.conf
    load saved configuration state to skip setup steps, run interactively.
    not planned until UI integration
"""


pp = pprint.PrettyPrinter(indent=2)
IP_DATABASE_PATH: str = "../peripherals/ip.json"
GPIO_PINS_LIST: list = ["GPIO0_["+str(i)+"]" for i in range(36)] + ["GPIO1_["+str(i)+"]" for i in range(36)]
PINMAP_INTNAME_INDEX = 0
PINMAP_EXTNAME_INDEX = 1
PINMAP_DIR_INDEX = 2


class Errors(Enum):
    NO_ERR = 0
    INVALID_JSON_INPUT_FROM_ARGV = -1
    INVALID_JSON_INPUT_FROM_FILE = -2
    INVALID_IP_INPUT_FROM_FILE = -3
    GENERATION_FAILED = -4
    DUPLICATE_GPIO_RESERVATION = -5
    NONEXISTENT_GPIO_RESERVATION = -6
    OUT_OF_FREE_GPIOS = -7


# At the start, for each peripheral, do the following:
# 1. Instantiate its AXI interface
# 2. Instantiate its external interface(s)
# 3. Create a dict mapping between the instance name nad the created interfaces


def parse_ip_database() -> list:
    with open(IP_DATABASE_PATH, 'r+') as file:
        project = json.load(file)
    return project


def allocate_gpio_pins(project_json, ip_json) -> None:
    """
    Goes through the project, finds unassigned "GPIO" pinmaps, assigns them to
    unclaimed GPIO pins in ascending order of pins and order of appearance of
    modules.

    :param project_json:
    :param ip_json:
    :return: Edits project_json in place
    """
    gpio_free_list = list(GPIO_PINS_LIST)
    gpio_reserved_set = set()  # set for just a little bit of O(1)
    gpio_unmapped_list = []
    # reserve explicitly mapped gpio pins
    for m in project_json:
        ip = ip_json[m["moduleType"]]
        for iface in [iface for iface in ip["interfaces"] if "pinmap" in iface]:
            for pinmap in iface["pinmap"]:
                if pinmap[PINMAP_EXTNAME_INDEX] == "GPIO":
                    gpio_unmapped_list.append((pinmap, f"{pinmap} in {m['UUID']}.{iface['type']}"))
                elif pinmap[PINMAP_EXTNAME_INDEX].startswith("GPIO_"):
                    if pinmap[PINMAP_EXTNAME_INDEX] in gpio_reserved_set:
                        print(f"ERROR[{Errors.DUPLICATE_GPIO_RESERVATION}]: "
                              f"DUPLICATE GPIO PIN RESERVATION SPECIFIED: "
                              f"{pinmap} in {m['UUID']}.{iface['type']}")
                        exit(Errors.DUPLICATE_GPIO_RESERVATION)
                    if pinmap[PINMAP_EXTNAME_INDEX] not in gpio_free_list:
                        print(f"ERROR[{Errors.NONEXISTENT_GPIO_RESERVATION}]: "
                              f"NON_EXISTENT GPIO PIN RESERVATION SPECIFIED: "
                              f"{pinmap} in {m['UUID']}.{iface['type']}")
                        exit(Errors.NONEXISTENT_GPIO_RESERVATION)
                    gpio_free_list.remove(pinmap[PINMAP_EXTNAME_INDEX])
                    gpio_reserved_set.add(pinmap[PINMAP_EXTNAME_INDEX])
    # assign unmapped gpio pins
    for pinmap in gpio_unmapped_list:  # (map:list, errmsg:str)
        if not gpio_free_list:
            print(f"ERROR[{Errors.OUT_OF_FREE_GPIOS}]: "
                  f"OUT OF FREE GPIOS FOR NEXT ASSIGNMENT: {pinmap[1]}")
            exit(Errors.OUT_OF_FREE_GPIOS)
        pinmap[0][PINMAP_EXTNAME_INDEX] = gpio_free_list[0]
        gpio_reserved_set.add(gpio_free_list[0])
        gpio_free_list.remove(gpio_free_list[0])
    pass


def write_top_decl_start_and_interfaces(project_json, ip_json) -> str:
    verilog = ""
    ports = []
    if_insts = []
    for m in project_json:
        ip = ip_json[m["moduleType"]]
        for i in range(len(ip['interfaces'])):
            iface = ip['interfaces'][i]
            if_inst_name = f"{m['parameters']['Verilog Instance Name']}_if{i}"
            if_inst = f"{iface['type']} {if_inst_name}();"
            if "pinmap" in iface:
                for pinmap in iface['pinmap']:
                    ports.append(f"{pinmap[PINMAP_DIR_INDEX]} logic {pinmap[PINMAP_EXTNAME_INDEX]}")
                    if pinmap[PINMAP_DIR_INDEX] == 'output':
                        if_inst += f"\nassign {pinmap[PINMAP_EXTNAME_INDEX]} " \
                                   f"= {if_inst_name}.{pinmap[PINMAP_INTNAME_INDEX]};"
                    else:
                        if_inst += f"\nassign {if_inst_name}.{pinmap[PINMAP_INTNAME_INDEX]} " \
                                   f"= {pinmap[PINMAP_EXTNAME_INDEX]}"
            if_insts.append(if_inst)
    verilog += f"module top(\n\t"
    verilog += ",\n\t".join(ports)
    verilog += ");\n\n"
    verilog += "\n\n".join(if_insts)
    verilog += "\n"
    return verilog
    pass


def write_modules_instantiations(project_json, ip_json) -> str:
    verilog = "\n"
    m_insts = []
    for m in project_json:
        ip = ip_json[m["moduleType"]]
        m_inst = f"{ip['verilogName']} #(\n\t"
        params = []
        for p, v in m['parameters']:
            # TODO: handle different param types -> type casting handled by modify.py
            params.append(f".{ip['parameters'][p]['verilogName']}({v})")
        m_inst += ",\n\t".join(params)
        m_inst += f"\n) {m['Verilog Instance Name']} (\n\t"
        ifs = []
        for i in range(len(ip['interfaces'])):
            ifs.append(f".{ip['interfaces'][i]['port']}({m['parameters']['Verilog Instance Name']}_if{i})")
        m_inst += ",\n\t".join(ifs)
        m_inst += "\n);"
    verilog += "\n\n".join(m_insts)
    verilog += '\n'
    return verilog
    pass


def write_axi_interconnect(project_json, ip_json) -> str:
    # axi module is just included in the top level sv file
    verilog = ""
    return verilog
    pass


def write_interconnect_instantiation(project_json, ip_json) -> str:
    verilog = ""
    return verilog
    pass


def write_top_verilog_end() -> str:
    verilog = "\nendmodule //top\n"
    return verilog
    pass


def generate_from_json(project_json, ip_json) -> str:
    verilog = ""
    # step 1: allocate GPIO pins
    allocate_gpio_pins(project_json, ip_json)
    # step 2: Instantiate interfaces modules and write pinouts
    verilog += write_top_decl_start_and_interfaces(project_json, ip_json)
    # ret += generate_top_level_pinouts()
    pass


def main():
    if len(sys.argv) == 1:  # argv[0] is "$script.py"
        print(f"ERROR[-1]: PLEASE SPECIFY AN INPUT")
        exit(-1)
    elif len(sys.argv) == 2:
        # get project json
        res = re.search(r"\.json$", sys.argv[1], re.IGNORECASE)
        project_json = None
        if res:
            with open(sys.argv[1], 'r+') as file:
                try:
                    project_json = json.load(file)
                except json.decoder.JSONDecodeError:
                    print(f"ERROR[{Errors.INVALID_JSON_INPUT_FROM_FILE}]: INVALID JSON INPUT FROM FILE {sys.argv[1]}")
                    exit(Errors.INVALID_JSON_INPUT_FROM_FILE)
        else:
            try:
                project_json = json.loads(sys.argv[1])
            except json.decoder.JSONDecodeError:
                print(f"ERROR[{Errors.INVALID_JSON_INPUT_FROM_ARGV}]: INVALID JSON INPUT FROM ARGV")
                exit(Errors.INVALID_JSON_INPUT_FROM_ARGV)
        # get ip json
        ip_json = None
        with open(IP_DATABASE_PATH, 'r+') as file:
            try:
                ip_json = json.load(file)
            except json.decoder.JSONDecodeError:
                print(f"ERROR[{Errors.INVALID_IP_INPUT_FROM_FILE}]: INVALID JSON INPUT FROM FILE {IP_DATABASE_PATH}")
                exit(Errors.ERR_INVALID_JSON_IP_FROM_FILE)
        # generate
        try:
            verilog = generate_from_json(project_json, ip_json)
            print(verilog)
            exit(Errors.NO_ERR)
        except:
            e = sys.exc_info()[0]
            print(f"ERROR[{Errors.GENERATION_FAILED}]: GENERATION FAILED FOR UNCAUGHT REASON: {str(e)}")
            exit(Errors.GENERATION_FAILED)


if __name__ == '__main__':
    main()
