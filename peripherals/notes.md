# Meeting Notes 20210304
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
### Open Questions ###
* Bus logic - how to build the AXI interconnect
* Generating inter-component interfaces
* How to we handle a memory for the CPU?
