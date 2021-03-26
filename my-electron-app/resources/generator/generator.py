#!python

import sys
import json
import pprint
import re
from enum import Enum
from sys import exit


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
GPIO_PINS_LIST: list = ["GPIO_0["+str(i)+"]" for i in range(36)] + ["GPIO_1["+str(i)+"]" for i in range(36)]
PINMAP_INTNAME_INDEX = 0
PINMAP_EXTNAME_INDEX = 1
PINMAP_DIR_INDEX = 2


class Errors(Enum):
    NO_ERR = 0
    UNKNOWN_ERR = -1
    BAD_ARGS = -2
    BAD_JSON = -3
    BAD_IP_JSON = -4
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
    for m in project_json:  # for each module in the project
        # for each entry in the module's pinmaps array (which always exists even if empty)
        for i in range(len(m['pinmaps'])):
            for pinmap in m['pinmaps'][i]:
                if_inst_name = f"{m['parameters']['Verilog Instance Name']}_if{i}"
                if pinmap[PINMAP_EXTNAME_INDEX] == "GPIO":
                    # add to the unmapped list for later processing if it's an unassigned GPIO
                    gpio_unmapped_list.append((pinmap, if_inst_name))
                elif pinmap[PINMAP_EXTNAME_INDEX].startswith("GPIO_"):
                    # register in the reserved list if it's an explicitly assigned GPIO
                    if pinmap[PINMAP_EXTNAME_INDEX] in gpio_reserved_set:
                        print(f"ERROR[{Errors.DUPLICATE_GPIO_RESERVATION}]: "
                              f"DUPLICATE GPIO PIN RESERVATION SPECIFIED: "
                              f"{pinmap} in {if_inst_name}")
                        exit(Errors.DUPLICATE_GPIO_RESERVATION)
                    if pinmap[PINMAP_EXTNAME_INDEX] not in gpio_free_list:
                        print(f"ERROR[{Errors.NONEXISTENT_GPIO_RESERVATION}]: "
                              f"NON_EXISTENT GPIO PIN RESERVATION SPECIFIED: "
                              f"{pinmap} in {if_inst_name}")
                        exit(Errors.NONEXISTENT_GPIO_RESERVATION)
                    gpio_free_list.remove(pinmap[PINMAP_EXTNAME_INDEX])
                    gpio_reserved_set.add(pinmap[PINMAP_EXTNAME_INDEX])
    # assign unmapped gpio pins
    for pinmap in gpio_unmapped_list:  # (pinmap:list, if_inst_name:str)
        if not gpio_free_list:
            print(f"ERROR[{Errors.OUT_OF_FREE_GPIOS}]: "
                  f"OUT OF FREE GPIOS FOR NEXT ASSIGNMENT: {pinmap[0]} in {pinmap[1]}")
            exit(Errors.OUT_OF_FREE_GPIOS)
        pinmap[0][PINMAP_EXTNAME_INDEX] = gpio_free_list[0]
        gpio_reserved_set.add(gpio_free_list[0])
        gpio_free_list.remove(gpio_free_list[0])
    pass


def write_top_decl_start_and_interfaces(project_json, ip_json) -> str:
    verilog = ""
    ports = []
    if_insts = []
    for m in project_json:  # for each module in the project
        ip = ip_json[m["moduleType"]]
        for i in range(len(ip['interfaces'])):  # for each interface specified in the IP entry
            iface = ip['interfaces'][i]  # get interface entry under IP entry
            # write IF instantiation
            if_inst_name = f"{m['parameters']['Verilog Instance Name']}_if{i}"
            if_inst = f"{iface['type']} {if_inst_name}();"
            # write AXI Controller instantiation for Mem IFs
            if iface['type'] == "Simple_Mem_IF":
                if_axi_inst_name = f"{m['parameters']['Verilog Instance Name']}_AXI_if{i}"
                if_axi_inst = f"AXI5_Lite_IF {if_axi_inst_name}();"
                if_insts.append(if_axi_inst)
            # wire pins to top
            if "pinmap" in iface:
                for pinmap in m['pinmaps'][i]:
                    ports.append(f"{pinmap[PINMAP_DIR_INDEX]} logic {pinmap[PINMAP_EXTNAME_INDEX]}")
                    # if pinmap[PINMAP_DIR_INDEX] == 'output':
                    #     if_inst += f"\nassign {pinmap[PINMAP_EXTNAME_INDEX]} " \
                    #                f"= {if_inst_name}.{pinmap[PINMAP_INTNAME_INDEX]};"
                    # else:
                    #     if_inst += f"\nassign {if_inst_name}.{pinmap[PINMAP_INTNAME_INDEX]} " \
                    #                f"= {pinmap[PINMAP_EXTNAME_INDEX]};"
                    if_inst += f"\ntran({pinmap[PINMAP_EXTNAME_INDEX]}, {if_inst_name}.{pinmap[PINMAP_INTNAME_INDEX]});"
            if_insts.append(if_inst)
            # TODO: James did I do this right? >> Almost :)
    verilog += f"module top(\n\t"
    verilog += ",\n\t".join(ports)
    verilog += "\n);\n\n"
    verilog += "\n\n".join(if_insts)
    verilog += "\n"
    return verilog
    pass


def write_module_instantiations(project_json, ip_json) -> str:
    verilog = "\n"
    m_insts = []
    for m in project_json:
        ip = ip_json[m["moduleType"]]
        m_inst = f"{ip['verilogName']} #(\n\t"
        params = []
        for p, v in m['parameters'].items():
            # TODO: handle different param types -> type casting handled by modify.py
            if 'verilogName' in ip['parameters'][p]:
                if ip['parameters'][p]['paramType'] == "Hexadecimal":
                    params.append(f".{ip['parameters'][p]['verilogName']}(32'h{v})")
                else:
                    params.append(f".{ip['parameters'][p]['verilogName']}({v})")
        m_inst += ",\n\t".join(params)
        m_inst += f"\n) {m['parameters']['Verilog Instance Name']} (\n\t"
        ifs = []
        for i in range(len(ip['interfaces'])):
            ifs.append(f".{ip['interfaces'][i]['port']}({m['parameters']['Verilog Instance Name']}_if{i})")
        m_inst += ",\n\t".join(ifs)
        m_inst += "\n);"
        m_insts.append(m_inst)
    verilog += "\n\n".join(m_insts)
    verilog += '\n'
    return verilog
    pass


def write_axi_interconnect(project_json, ip_json) -> str:
    # axi module is just included in the top level sv file
    verilog = ""
    
    interconnect_params = ""
    interconnect_ifs = ""
    interconnect_clocks = ""
    read_comb = ""
    write_comb = ""

    num_modules = len(project_json)

    # In this block:
    # 1. The interconnect's params
    # 2. The interconnect's interfaces
    # 3. Clock/reset assignments for each worker interface
    # 4. First half of the read comb logic block
    # 5. First half of the write comb logic block
    for module in project_json:
        inst_name = module["parameters"]["Verilog Instance Name"]
        base_addr = module["parameters"]["Base Address"]
        num_bits = ip_json[module["moduleType"]]["addrBits"]

        # Params
        interconnect_params += ("    parameter [31:0] " + inst_name + "_base_addr = 32'h" + base_addr + ",\n")
        interconnect_params += ("    parameter int " + inst_name + "_num_bits = " + str(num_bits) + ",\n")
        
        # Interfaces
        interconnect_ifs += "    AXI5_Lite_IF.MANAGER " + inst_name + "_IF,\n"

        # Clock/resets
        interconnect_clocks += "    assign " + inst_name + "_IF.ACLK = M_IF.ACLK;\n"
        interconnect_clocks += "    assign " + inst_name + "_IF.ARESETn = M_IF.ARESETn;\n"

        # Read logic pt 1
        read_comb += "        // " + inst_name + "\n"
        read_comb += "        " + inst_name + "_IF.ARADDR = 'b0;\n"
        read_comb += "        " + inst_name + "_IF.ARPROT = 'b0;\n"
        read_comb += "        " + inst_name + "_IF.ARVALID = 'b0;\n"
        read_comb += "        " + inst_name + "_IF.ARSIZE = 'b0;\n"
        read_comb += "        " + inst_name + "_IF.ARID = 'b0;\n"
        read_comb += "        " + inst_name + "_IF.RREADY = 'b0;\n"
        read_comb += "\n"

        # Write logic pt 1
        write_comb += "        // " + inst_name + "\n"
        write_comb += "        " + inst_name + "IF.AWADDR = 'b0;\n"
        write_comb += "        " + inst_name + "IF.AWPROT = 'b0;\n"
        write_comb += "        " + inst_name + "IF.AWVALID = 'b0;\n"
        write_comb += "        " + inst_name + "IF.AWSIZE = 'b0;\n"
        write_comb += "        " + inst_name + "IF.AWID = 'b0;\n"
        write_comb += "        " + inst_name + "IF.WDATA = 'b0;\n"
        write_comb += "        " + inst_name + "IF.WSTRB = 'b0;\n"
        write_comb += "        " + inst_name + "IF.WVALID = 'b0;\n"
        write_comb += "        " + inst_name + "IF.BREADY = 'b0;\n"
        write_comb += "\n"
   
    # Remove the extra comma in the last entry of the params and interfaces 
    interconnect_params = interconnect_params[0: -2] + '\n'
    interconnect_ifs = interconnect_ifs[0: -2] + '\n'

    # In this block:
    # 1. Second half of read comb logic block
    # 2. Second half of write comb logic block
    i = 0
    for module in project_json:
        inst_name = module["parameters"]["Verilog Instance Name"]
        base_addr = module["parameters"]["Base Address"]
        num_bits = ip_json[module["moduleType"]]["addrBits"]
        
        if (i == 0):
            read_comb += "        if (araddr_sel[31:" + inst_name + "_num_bits] == " + inst_name + "_base_addr[31:" + inst_name + "_num_bits]) begin\n"
            write_comb += "        if (awaddr_sel[31:" + inst_name + "_num_bits] == " + inst_name + "_base_addr[31:" + inst_name + "_num_bits]) begin\n"
        else:
            read_comb += "        end else if (araddr_sel[31:" + inst_name + "_num_bits] == " + inst_name + "_base_addr[31:" + inst_name + "_num_bits]) begin\n"
            write_comb += "        end else if (awaddr_sel[31:" + inst_name + "_num_bits] == " + inst_name + "_base_addr[31:" + inst_name + "_num_bits]) begin\n"

        # Read logic
        read_comb += "            " + inst_name + "_IF.ARADDR = M_IF.ARADDR;\n"
        read_comb += "            " + inst_name + "_IF.ARPROT = M_IF.ARPROT;\n"
        read_comb += "            " + inst_name + "_IF.ARVALID = M_IF.ARVALID;\n"
        read_comb += "            M_IF.ARREADY = " + inst_name + "IF.ARREADY;\n"
        read_comb += "            " + inst_name + "_IF.ARSIZE = M_IF.ARSIZE;\n"
        read_comb += "            " + inst_name + "_IF.ARID = M_IF.ARID;\n"

        read_comb += "            M_IF.RDATA = " + inst_name + "IF.RDATA;\n"
        read_comb += "            M_IF.RRESP = " + inst_name + "IF.RRESP;\n"
        read_comb += "            M_IF.RVALID = " + inst_name + "IF.RVALID;\n"
        read_comb += "            " + inst_name + "_IF.RREADY = M_IF.RREADY;\n"
        read_comb += "            M_IF.RID = " + inst_name + "IF.RID;\n"

        # Write logic
        write_comb += "            " + inst_name + "_IF.AWADDR = M_IF.AWADDR;\n"
        write_comb += "            " + inst_name + "_IF.AWPROT = M_IF.AWPROT;\n"
        write_comb += "            " + inst_name + "_IF.AWVALID = M_IF.AWVALID;\n"
        write_comb += "            M_IF.AWREADY = " + inst_name + "_IF.AWREADY;\n"
        write_comb += "            " + inst_name + "_IF.AWSIZE = M_IF.AWSIZE;\n"
        write_comb += "            " + inst_name + "_IF.AWID = M_IF.AWID;\n"
        
        write_comb += "            " + inst_name + "_IF.WDATA = M_IF.WDATA;\n"
        write_comb += "            " + inst_name + "_IF.WSTRB = M_IF.WSTRB;\n"
        write_comb += "            " + inst_name + "_IF.WVALID = M_IF.WVALID;\n"
        write_comb += "            M_IF.WREADY = " + inst_name + "_IF.WREADY;\n"

        write_comb += "            M_IF.BRESP = " + inst_name + "_IF.BRESP;\n"
        write_comb += "            M_IF.BVALID = " + inst_name + "_IF.BVALID;\n"
        write_comb += "            " + inst_name + "_IF.BREADY = M_IF.BREADY;\n"
        write_comb += "            M_IF.BID = " + inst_name + "_IF.BID;\n"


        if (i == num_modules - 1):
            read_comb += "\t\tend\n"
            write_comb += "\t\tend\n"

        i += 1

    verilog += "module AXI_Interconnect #(\n"
    verilog += interconnect_params
    verilog += ")(\n"
    verilog += "    AXI5_Lite_IF.WORKER M_IF,\n"
    verilog += interconnect_ifs
    verilog += ");\n\n"

    verilog += "    // Clock and reset wiring\n"
    verilog += interconnect_clocks

    verilog += "\n    logic [31:0] araddr;\n"
    verilog += "    logic [31:0] araddr_latched;\n"
    verilog += "    logic [31:0] araddr_sel;\n\n"
    verilog += "    logic [31:0] awaddr;\n"
    verilog += "    logic [31:0] awaddr_latched;\n"
    verilog += "    logic [31:0] awaddr_sel;\n\n"

    verilog += "    assign araddr = M_IF.ARADDR;\n"
    verilog += "    assign awaddr = M_IF.AWADDR;\n\n"

    verilog += "    enum logic [1:0] {\n"
    verilog += "        READ_IDLE,\n"
    verilog += "        ARADDR_LATCHED,\n"
    verilog += "        AR_DONE,\n"
    verilog += "    } read_state;\n\n"

    verilog += "    // Read state machine\n"
    verilog += "    always_ff @(posedge M_IF.ACLK) begin\n"
    verilog += "        if (M_IF.ARESETn == 1'b0) begin\n"
    verilog += "            read_state <= READ_IDLE;\n"
    verilog += "        end else begin\n"
    verilog += "            case (read_state)\n"
    verilog += "                READ_IDLE : begin\n"
    verilog += "                    if (M_IF.ARREADY && M_IF.ARVALID) begin\n"
    verilog += "                        read_state <= AR_DONE;\n"
    verilog += "                    end else if (M_IF.ARVALID) begin\n"
    verilog += "                        read_state <= ARADDR_LATCHED;\n"
    verilog += "                    end else begin\n"
    verilog += "                        read_state <= READ_IDLE;\n"
    verilog += "                    end\n"
    verilog += "                end\n"
    verilog += "                ARADDR_LATCHED : begin\n"
    verilog += "                    if (M_IF.ARREADY && M_IF.ARVALID) begin\n"
    verilog += "                        read_state <= AR_DONE;\n"
    verilog += "                    end else begin\n"
    verilog += "                        read_state <= ARADDR_LATCHED;\n"
    verilog += "                    end\n"
    verilog += "                end\n"
    verilog += "                AR_DONE : begin\n"
    verilog += "                    if (M_IF.RREADY && M_IF.RVALID) begin\n"
    verilog += "                        read_state <= READ_IDLE;\n"
    verilog += "                    end else begin\n"
    verilog += "                        read_state <= AR_DONE;\n"
    verilog += "                    end\n"
    verilog += "                end\n"
    verilog += "                default : begin\n"
    verilog += "                    read_state <= read_state;\n"
    verilog += "                end\n"
    verilog += "            endcase\n"
    verilog += "        end\n"
    verilog += "    end\n\n"

    verilog += "    // ARADDR latching\n"
    verilog += "    always_ff @(posedge M_IF.ACLK) begin\n"
    verilog += "        if (M_IF.ARESETn == 1'b0) begin\n"
    verilog += "            araddr_latched <= 32'b0;\n"
    verilog += "        end else begin\n"
    verilog += "            if (M_IF.ARREADY && read_state == READ_IDLE) begin\n"
    verilog += "                araddr_latched <= M_IF.ARADDR;\n"
    verilog += "            end\n"
    verilog += "        end\n"
    verilog += "    end\n\n"

    verilog += "    // Wiring for araddr_sel, and read XBAR\n"
    verilog += "    always_comb begin\n"
    verilog += "        // Default case - we expect to never hit this\n"
    verilog += "        araddr_sel = 'b0;\n"
    verilog += "        if (read_state == ARADDR_LATCHED || read_state == AR_DONE) begin\n"
    verilog += "            araddr_sel = araddr_latched;\n"
    verilog += "        end else begin\n"
    verilog += "            araddr_sel = araddr;\n"
    verilog += "        end\n\n"
    verilog += "        // Default tie-offs\n"
    verilog += "        // Manager\n"
    verilog += "        M_IF.ARREADY = 'b0;\n"
    verilog += "        M_IF.RDATA = 'b0;\n"
    verilog += "        M_IF.RRESP = 'b0;\n"
    verilog += "        M_IF.RVALID = 'b0;\n"
    verilog += "        M_IF.RID = 'b0;\n\n"
    verilog += read_comb
    verilog += "    end\n\n"

    verilog += "    enum logic [1:0] {\n"
    verilog += "        WRITE_IDLE,\n"
    verilog += "        AWADDR_LATCHED,\n"
    verilog += "        AW_DONE\n"
    verilog += "    } write_state;\n\n"

    verilog += "    // Write state machine\n"
    verilog += "    always_ff @(posedge M_IF.ACLK) begin\n"
    verilog += "        if (M_IF.ARESETn == 1'b0) begin\n"
    verilog += "            write_state <= WRITE_IDLE;\n"
    verilog += "        end else begin\n"
    verilog += "            case (write_state)\n"
    verilog += "                WRITE_IDLE : begin\n"
    verilog += "                    if (M_IF.AWREADY && M_IF.AWVALID) begin\n"
    verilog += "                        write_state <= AW_DONE;\n"
    verilog += "                    end else if (M_IF.AWVALID) begin\n"
    verilog += "                        write_state <= AWADDR_LATCHED;\n"
    verilog += "                    end else begin\n"
    verilog += "                        write_state <= WRITE_IDLE;\n"
    verilog += "                    end\n"
    verilog += "                end\n"
    verilog += "                AWADDR_LATCHED : begin\n"
    verilog += "                    if (M_IF.AWREADY && M_IF.AWVALID) begin\n"
    verilog += "                        write_state <= AW_DONE;\n"
    verilog += "                    end else begin\n"
    verilog += "                        write_state <= AWADDR_LATCHED;\n"
    verilog += "                    end\n"
    verilog += "                end\n"
    verilog += "                AW_DONE : begin\n"
    verilog += "                    if (M_IF.BREADY && M_IF.BVALID) begin\n"
    verilog += "                        write_state <= WRITE_IDLE;\n"
    verilog += "                    end else begin\n"
    verilog += "                        write_state <= AW_DONE;\n"
    verilog += "                    end\n"
    verilog += "                end\n"
    verilog += "                default : begin\n"
    verilog += "                    write_state <= write_state;\n"
    verilog += "                end\n"
    verilog += "            endcase\n"
    verilog += "        end\n"
    verilog += "    end\n\n"

    verilog += "    // AWADDR latching\n"
    verilog += "    always_ff @(posedge M_IF.ACLK) begin\n"
    verilog += "        if (M_IF.ARESETn == 1'b0) begin\n"
    verilog += "            awaddr_latched <= 32'b0;\n"
    verilog += "        end else begin\n"
    verilog += "            if (M_IF.AWREADY && write_state == WRITE_IDLE) begin\n"
    verilog += "                awaddr_latched <= awaddr;\n"
    verilog += "            end\n"
    verilog += "        end\n"
    verilog += "    end\n\n"

    verilog += "    // Wiring for awaddr_sel and write XBAR\n"
    verilog += "    always_comb begin\n"
    verilog += "        awaddr_sel = 'b0;\n"
    verilog += "        if (write_state == AWADDR_LATCHED || write_state == AW_DONE) begin\n"
    verilog += "            awaddr_sel = awaddr_latched;\n"
    verilog += "        end else begin\n"
    verilog += "            awaddr_sel = awaddr;\n"
    verilog += "        end\n\n"
    verilog += "        // Default tie-offs\n"
    verilog += "        // Manager\n"
    verilog += "        M_IF.AWREADY = 'b0;\n"
    verilog += "        M_IF.WREADY = 'b0;\n"
    verilog += "        M_IF.BRESP = 'b0;\n"
    verilog += "        M_IF.BVALID = 'b0;\n"
    verilog += "        M_IF.BID = 'b0;\n\n"
    verilog += write_comb
    verilog += "    end\n\n"
    verilog += "endmodule"

    return verilog
    pass


def write_controller_and_interconnect_inst (project_json, ip_json) -> str:
    verilog = ""

    for module in project_json:
        inst_name = module["parameters"]["Verilog Instance Name"]
        base_addr = module["parameters"]["Base Address"]
        num_bits = ip_json[module["moduleType"]]["addrBits"]
        verilog += "    AXI_Controller_Worker " + inst_name + "_controller (\n"
        verilog += "        .AXI_IF(" + inst_name + "_AXI_if0.worker),\n"
        verilog += "        .USER_IF(" + inst_name + "_if0.controller)\n"
        verilog += "    );\n\n"

    verilog += "    AXI_Interconnect #(\n"
    for module in project_json:
        inst_name = module["parameters"]["Verilog Instance Name"]
        base_addr = module["parameters"]["Base Address"]
        num_bits = ip_json[module["moduleType"]]["addrBits"]
        verilog += "        ." + inst_name + "_base_addr(32'h" + base_addr + "),\n"
        verilog += "        ." + inst_name + "_num_bits(" + str(num_bits) + "),\n"
    
    verilog = verilog[0: -2] + '\n'
    verilog += "    ) xbar (\n"

    for module in project_json:
        inst_name = module["parameters"]["Verilog Instance Name"]
        base_addr = module["parameters"]["Base Address"]
        num_bits = ip_json[module["moduleType"]]["addrBits"]
        verilog += "        ." + inst_name + "_IF(" + inst_name + "_AXI_if0.manager),\n"

    verilog += "        .M_IF(M_IF.worker)\n"
    verilog += "    );\n"

    return verilog


def write_top_verilog_end() -> str:
    verilog = "\nendmodule //top\n"
    return verilog
    pass


def generate_from_json(project_json, ip_json) -> str:
    verilog = ""
    # step 1: allocate GPIO pins
    allocate_gpio_pins(project_json, ip_json)
    # step 2: Instantiate interfaces modules and write pinouts
    verilog += "/**** write_top_decl_start_and_interfaces output below ****/\n\n"
    verilog += write_top_decl_start_and_interfaces(project_json, ip_json)
    # step 3: instantiate actual modules
    verilog += "\n\n/**** write_module_instantiations output below ****/\n\n"
    verilog += write_module_instantiations(project_json, ip_json)
    # step 5: write axi controller instantiations
    verilog += "\n\n/**** write_controller_and_interconnect_inst output below ****/\n\n"
    verilog += write_controller_and_interconnect_inst(project_json, ip_json)
    # step 6: cap off verilog file
    verilog += "\n\n/**** write_top_verilog_end output below ****/\n\n"
    verilog += write_top_verilog_end()
    # step 4: write axi interconnect logic
    verilog += "\n\n/**** write_axi_interconnect output below ****/\n\n"
    verilog += write_axi_interconnect(project_json, ip_json)
    # step 7: tabs to spaces
    verilog = verilog.replace('\t', ' '*4)
    # done
    return verilog
    pass


def main():
    if len(sys.argv) == 1:  # argv[0] is "$script.py"
        print(f"ERROR[{Errors.BAD_ARGS}]: PLEASE SPECIFY AN INPUT")
        exit(Errors.BAD_ARGS)
    elif len(sys.argv) == 2:
        # get project json
        res = re.search(r"\.json$", sys.argv[1], re.IGNORECASE)
        project_json = None
        if res:
            with open(sys.argv[1], 'r+') as file:
                try:
                    project_json = json.load(file)
                except json.decoder.JSONDecodeError:
                    print(f"ERROR[{Errors.BAD_JSON}]: INVALID JSON INPUT FROM FILE {sys.argv[1]}")
                    exit(Errors.BAD_JSON)
        else:
            try:
                project_json = json.loads(sys.argv[1])
            except json.decoder.JSONDecodeError:
                print(f"ERROR[{Errors.BAD_JSON}]: INVALID JSON INPUT FROM ARGV")
                exit(Errors.BAD_JSON)
        # get ip json
        ip_json = None
        with open(IP_DATABASE_PATH, 'r+') as file:
            try:
                ip_json = json.load(file)
            except json.decoder.JSONDecodeError:
                print(f"ERROR[{Errors.BAD_IP_JSON}]: INVALID JSON INPUT FROM FILE {IP_DATABASE_PATH}")
                exit(Errors.BAD_IP_JSON)
        # generate
        verilog = generate_from_json(project_json, ip_json)
        print(verilog)
        exit(Errors.NO_ERR.value)


if __name__ == '__main__':
    # try:
        main()
    # except:
    #     e = sys.exc_info()[0]
    #     print(f"ERROR[{Errors.UNKNOWN_ERR}]: GENERATION FAILED FOR UNCAUGHT REASON: {str(e)}")
    #     exit(Errors.UNKNOWN_ERR)
