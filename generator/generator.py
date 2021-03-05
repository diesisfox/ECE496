#!python

import sys
import json
import pprint


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
ip_database_file: str = "../peripherals/ip.json"


def parse_ip_database() -> list:
    with open(ip_database_file, 'r+') as file:
        project = json.load(file)
    return project


def create_module_instantiation(module_obj) -> str:
    '''
    This procedure expects a Python dictionary conversion of a JSON object representing an IP block, with the following fields:
    :param module_obj: Python dictionary conversion of a JSON object representing an IP block in the user's system, containing the following fields:
        addr_bits: int - the number of address bits required for the address space of the module
        interface: list of interface objects
        moduleType: string containing the name of
        parameters: list of parameter objects
        source: string containing the location of the IP block's source
        verilogName: the name of the module in (System)Verilog
    :type module_obj: dict
    :returns: A string containing the Verilog instantiation of the module
    :rtype: str
    '''

    ip_json = {} #entire ip.json list

    instanceInfo = {} #project.json list item
    # moduleInfo =  find_by_moduletype(instanceInfo.moduleType, ip_json)#ip.json
    moduleInfo = {}

    ret = f"""
        {moduleInfo["verilogName"]} #(
    """

    retListTemp = []

    for [paramName, param] in moduleInfo["parameters"]:
        if("verilogName" in param):
            value = ""
            if(paramName in instanceInfo["parameters"]):
                value = instanceInfo["parameters"][paramName]
            else:
                value = param["default"]

            retListTemp.append(f"   .{param['verilogName']}({value})")

    ret += ',\n\t'.join(retListTemp)
    ret += f"\n) {instanceInfo['parameters']['Verilog Instance Name']} (\n"
    retListTemp = []

    module_specific_interface_instance_name = "TBD"

    for [ifaceName, iface] in moduleInfo["interfaces"]:
        retListTemp.append(f"   .{iface['port']}({module_specific_interface_instance_name})")

    ret += ',\n\t'.join(retListTemp)
    ret += f"\n);"


    # moduleType #(
    #       .param1(<value>),
    #       .param2(<value>),
    #       ...
    # ) instanceName (
    #       .signal1(connection),
    #       .signal2(connection),
    #
    # );

    pass


def write_system(filename):
    # For each module:
    # 1. Create the Verilog instantiation
    # 2. Instantiate module-specific interfaces
    with open(filename, 'w+') as file:
        pass


def load_user_project(user_project_file):
    with open(user_project_file, 'r+') as file:
        project = json.load(file)
    pp.pprint(project)


def main():
    # fpganet = n532.get_fpganet()
    # 
    if len(sys.argv) == 1:
        pass
    elif len(sys.argv) == 2:
        load_user_project(sys.argv[1])
        pass
    # elif len(sys.argv) == 3:
    #     pass
    # elif len(sys.argv) == 4:
    #     if sys.argv[1] == 'ia':
    #         do_inference(fpganet, sys.argv[2], sys.argv[3])
    #     else:
    #         exit_invalid_args()
    # else:
    #     exit_invalid_args()
    # 
    # # print(sys.argv)
    pp.pprint(parse_ip_database())


if __name__ == '__main__':
    main()
