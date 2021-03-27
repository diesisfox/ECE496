interface IP_SPI_M_IF ();

    logic CS,
    logic SCK,
    logic DOUT,
    logic DIN,

    modport Peripheral(
        input CS,
        input SCK,
        input DOUT,
        output DIN,
    );

endinterface : IP_SPI_M_IF
