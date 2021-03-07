interface spi_m_if (
    output logic CS,
    output logic SCK,
    output logic DOUT,
    input logic DIN,
);

    modport inside(
        input CS,
        input SCK,
        input DOUT,
        output DIN,
    );

endinterface : spi_m_if

/**
top level instantiation:

spi_m_if

**/