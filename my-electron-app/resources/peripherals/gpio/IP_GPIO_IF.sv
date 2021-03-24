interface IP_GPIO_IF ();

    logic [31:0] pins;

    modport Peripheral(
        inout pins;
    );

endinterface : IP_GPIO_IF
