interface IP_I2C_M_IF ();

    logic SCL;
    logic SDA;

    // task CWrite(input logic [31:0] addr, input logic [31:0] data, input int cycleTime);
    //     wr_addr = addr;
    //     wr_data = data;
    //     wr_byteEn = 4'hf;
    //     wr_valid = '1;
    //     do #cycleTime;
    //     while(wr_ready == '0);
    //     wr_valid = '0;
    // endtask

    // task CRead(input logic [31:0] addr, output logic [31:0] data, input int cycleTime);
    //     rd_addr = addr;
    //     rd_byteEn = 4'hf;
    //     rd_valid = '1;
    //     do #cycleTime;
    //     while(rd_ready == '0);
    //     data = rd_data;
    //     rd_valid = '0;
    // endtask

    modport Peripheral (
        output SCL,
        input SDA
    );

endinterface
