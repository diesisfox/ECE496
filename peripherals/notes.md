# Meeting Notes 20210304 #

---
### TODOs ###
* Add "unique" tag to interface definitions in ip.json
* Refactor ip.json such that module parameters have "isVerilog" flags
* Refactor peripherals to use the AXI worker controller
* Discussion with Alex:
    - [x] How is project JSON created and modified? Will he do it? Pass us the current state + a command, and we return updated JSON? etc
    - [x] How/when is our generate.py called? What outputs is he expecting (file handle, filename, string)? What inputs will he give us (JSON file names, file handles, strings)?
    - [x] Tell alex that the python backend will be "stateless" and won't be a daemon / require IPC
    - [x] System validation - will he validate systems? Is that a callback we should build?
        - [x] Error mechanisms - if generate.py hits some sort of error, can we have some sort of mechanism for indicating it to the user
            * validate_system.py?
    - [x] Display of parameters to edit -- read "important" flags and use that to pick which params to display in collapsed menu - build expandable menu if possible
    - [ ] UI feedback lol
---
### Notes 20210307 ###

* UI will call project modification python script with verbs: add_module, remove_module, change_parameter, rearrange_modules.
  * ip.json is expected to be in a hardcoded relative path (unless Alex wants to change that)
  * verbs:
    * add_module: `python3 modify.py add_module <current_project_json_str> <module_type>`
    * remove_module: `python3 modify.py remove_module <current_project_json_str> <module_UUID>`
    * change_parameter: `python3 modify.py change_parameter <current_project_json_str> <module_UUID> <parameter_name> <new_value>`
    * rearrange_module: `python3 modify.py rearrange_module <current_project_json_str> <module_UUID> <0-indexed_position>`
  * The python script will spit out the output json as a string on stdout, ending with `EOF`.
* Validation:
  * UI invokes `python3 validate.py <current_project_json_str>`
  * validate.py will output on stdout whether the system is valid or if there are errors, what the errors are (to be displayed to the user)
    * Error indication method:
      * The python backend will print on stdout first a magic token indicating whether it's a pass or a fail
      * If fail, an error message will follow, which should be displayed to the user.
* Generation:
  * Invoked similarly to the validator.
  * the generator has the same error indication method as the validator. Except on pass, it will print out the path to the generated system after the magic token.
* What the user will be doing from the built-in python terminal:
  * User types: `add_module(...args)`
  * When the python shell starts, it should automatically include modules you wrote that defines functions such as `add_module()` etc.
  * This can be done by piping in `from _ import _` to python's stdin when it starts.
  * What happens next:
    * The python running in the python shell could invoke the python itself
    * OR, the python could somehow tell the JS to do the thing
      * the python terminal prints out a string starting with a magic token. upon seeing that token, the JS which is an interposer btw the python and the UI takes that as a command.
* Important tag: prioritize other stuff first, we can circle back to this.

* Roadmap:
  * wrap up generation code within a week
    * UI integration with python backend should be done at the same time
  * a week to integrate after that
  * final week allocated for final report
---
### Peripheral pin-outs ###
* Create SystemVerilog interfaces for each peripheral's external connections
    -> This will simplify wiring within the generated system
    TODO: need to double check Quartus supports assigning interface signals to pins on a device

* The way we'll do Quartus pinouts (qsf file) is to provide the user with the Terasic DE1-SoC file
    -> That qsf file declares all connections between useful pins on the device and top-level signal names
    * Then, we can break-out the peripheral-specific interfaces at the top level into individual signals, with the naming expected by the QSF file
        * Note: Quartus does not error if signals are declared in the QSF but not in the top-level
    * The way we break-out the interfaces is that each \<peripheral\>_interface.sv will have metadata in comments at the top of the file defining 1:1 mappings between signals in the interface and signal names expected by the QSF
    * What about peripherals that use generic pins? Like GPIOs
        -> For now, just do the lazy method of only allowing the user 2 GPIO peripherals - 1 for each GPIO bank on the DE1-SoC
---
### Clock + reset controllers ###
* Clock distribution in a system: just wire the CLK_50MHZ into the AXI bus
* Reset controller: pick one of the pushbuttons on the board (either HPS reset button or normal pushbuttons) and wire it directly into the AXI bus
    -> Both the HPS pushbuttons and normal pushbuttons are debounced and are all LOW when pressed
---

### CPU memory ###
* Create a BRAM peripheral and force-instantiate one in every system
    -> Make the user upload a code file to fill the RAM with
* Reserve 0x8000_0000 as start address of program memory
    -> To match "standards", PC reset to 0x8000_0000
---
### GPIOs ###
* jk below
* Alex's UI should maintain a list of available GPIOs and automatically assign the user's new GPIO-consuming peripheral pins to next available GPIOs. 
---
### Open Questions ###
* Bus logic - how to build the AXI interconnect
* Generating inter-component interfaces
* How to we handle a memory for the CPU?
---

### Generation Code High-Level Algorithm ###
1. Allocate GPIO pins
    1. Iterate over all modules in the user's system once
        1. Foreach module, check if it needs any GPIO pins - if it does, allocate as many as it needs and record the allocation in dictionary local to the generator's scope
2. Instantiate interfaces and break out module-specific interfaces to external
    1. Iterate over all modules in the user's system once
        1. Foreach module, lookup its entry in the IP catalog JSON, and extract the "type" field of the required interfaces
            1. Foreach interface type, instantiate an interface with name $type_$Verilog\ Instance\ Name
            2. Foreach interface type, also wire it to the external world - need to both create ports in the module declaration, AND connect those ports to the interface's signals
                1. Note: Do not need to do external wiring for AXI interfaces
3. Instantiate the actual modules in the user's systme
   1. At this point, interfaces all exist and are wired appropriately
   1. Iterate over all modules in the user's system once
        1. Foreach module, iterate over all the parameters defined in its IP catalog JSON entry once:
            1. Foreach parameter in the IP catalog entry, check if it has a verilogName
            2. If it does, check if it has a user-specified value in the project
            3. If it does, use the user's value, otherwise use the default defined in its catalog entry
        1. Foreach module, connect the interfaces to the ones defined in step #2 of this program
4. Create the AXI interconnect: (Andrew)
    1. Iterate over all the modules in the user's system, and extract three pieces of information:
        1. Whether it needs an AXI worker interface, or and AXI manager
        2. The base address of the worker
        3. The number of address bits of the worker
    2. Create the bus logic!
5. Insert the AXI interconnect into the system and wire it to all the existing AXI interfaces created in step #2

### Generation Code Notes ###
* Yeet "Verilog Instance Name" from parameters?
    
spi at 32'h0400_1000;
unique case(addr[31:0]):
    32'h8XXX_XXXX: //memory;
    {24'h0400_10, 8'b000x_xxxx}: //spi;
endcase