interface IP_GPIO_IF ();

    logic [31:0] in;
    logic [31:0] out;
    logic [31:0] oe;

    modport Peripheral(
        input in,
        output out,
        output oe
    );

endinterface : IP_GPIO_IF
