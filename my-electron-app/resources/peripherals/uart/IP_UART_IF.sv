interface IP_UART_IF ();

    logic TX;
    logic RX;

    modport Peripheral(
        output TX,
        input RX
    );

endinterface : IP_UART_IF
