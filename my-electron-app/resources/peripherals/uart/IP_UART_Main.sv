/**
* write 1 to START starts manager txn. txn done when START becomes 0
* writing 0 to START while START is 1 kills the current txn
* manager spi clock freq = clk/(2*(CLKDIV+1))
* manually control CS via register
* after one txn, DATA is exchanged with DIN data, which can be read by user for manager rx
**/ 
module IP_UART_Main #(
    parameter bit [31:0] ADDR = 'h1000_0000
) (
    Simple_Worker_Mem_IF.WORKER Bus,
    IP_UART_IF.Peripheral UART_IF
);

localparam ADDRBITS = 5;
localparam START_OFFSET = 'h00; // {...[31:1], START}
localparam CLKDIV_OFFSET = 'h04; // {CLKDIV[31:0]}
localparam CS_OFFSET = 'h08; // {...[31:1], CS}
localparam SPIMODE_OFFSET = 'h0c; // {...[31:2], SPIMODE[1:0] ({CPOL,CPHA})}
localparam DATA_OFFSET = 'h10; // {...[31:8], DATA[7:0]}

// Interface module with AXI
// Simple_Worker_Mem_IF Bus ();
// AXI_controller_worker AXI_controller (
//     .USER_IF(Bus),
//     .AXI_IF(AXI_IF)
// );

// Break out/in module interface signals
logic CS, SCK, DOUT, DIN;
assign SPI_IF.CS = CS;
assign SPI_IF.SCK = SCK;
assign SPI_IF.DOUT = DOUT;
assign DIN = SPI_IF.DIN;

// state registers
logic [31:0] counter = '0;
logic [2:0] bitCounter = '0;
logic started = '0;
logic [31:0] clkdiv = 'hf;
logic cpol = '0;
logic cpha = '0;
logic [1:0] spimode = '0;
logic [7:0] data = '0;

// io registers
logic cs = '1;
assign CS = cs;
logic sck = '0;
assign SCK = cpol ? ~sck : sck;
logic dout = '0;
assign DOUT = dout;

// helper functions
function logic [31:0] maskBytes(logic [31:0] old, logic [31:0] in, logic[3:0] en);
    return {en[3]?in[31:24]:old[31:24], en[2]?in[23:16]:old[23:16], en[1]?in[15:8]:old[15:8], en[0]?in[7:0]:old[7:0]};
endfunction

// main logic
always_ff @(posedge Bus.clock) begin
    if (!Bus.reset_n) begin
        cs <= '1;
        sck <= '0;
        dout <= '0;
        counter <= '0;
        bitCounter <= '0;
        started <= '0;
        clkdiv <= 'hf;
        spimode <= '0;
        data <= '0;
        Bus.wr_ready <= '0;
        Bus.rd_ready <= '0;
        Bus.rd_data <= '0;
    end else begin
        // defaults (silent stasis)
        cs <= cs;
        sck <= 0;
        dout <= 0;
        counter <= counter;
        bitCounter <= bitCounter;
        started <= started;
        clkdiv <= clkdiv;
        spimode <= spimode;
        data <= data;
        Bus.wr_ready <= '0;
        Bus.rd_ready <= '0;
        Bus.rd_data <= '0;

        // clock division
        if(started)begin
            if(counter == clkdiv)begin
                counter <= '0;
                sck <= ~sck;
            end else begin
                counter <= counter + 1;
                sck <= sck;
            end
        end else begin
            sck <= '0;
            counter <= '0;
        end

        // SPI transaction logic
        if(started)begin // in any spimode, out first, in second in one spi clock cycle
            dout <= dout;
            if(counter == clkdiv)begin // next clock will have edge
                if(cpha)begin // sample on negedge, change on posedge
                    if(sck)begin // negedge
                        data[7] <= DIN;
                    end else begin //posedge
                        dout <= data[0];
                        data <= data >> 1;
                        bitCounter <= bitCounter + 'd1;
                        if(bitCounter == 'd7)begin
                            data <= data;
                            sck <= '0;
                            started <= '0;
                        end
                    end
                end else begin // sample on posedge, change on negedge
                    if(sck)begin // negedge
                        dout <= data[0];
                        data <= data >> 1;
                        bitCounter <= bitCounter + 'd1;
                        if(bitCounter == 'd7)begin
                            data <= data;
                            sck <= '0;
                            started <= '0;
                        end
                    end else begin //posedge
                        data[7] <= DIN;
                    end
                end
            end
        end

        // write register
        if(Bus.wr_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && Bus.wr_valid)begin
            Bus.wr_ready <= '1;
            if(!started)begin
                unique case (Bus.wr_addr[ADDRBITS-1:0])
                    START_OFFSET: begin
                        started <= maskBytes({31'd0,started}, Bus.wr_data, Bus.wr_byteEn);
                        // init logic
                        if(maskBytes({31'd0,started}, Bus.wr_data, Bus.wr_byteEn)&32'h1 == 32'h1) begin
                            dout <= data[0];
                            data <= data >> 1;
                            if(cpha) sck <= '1;
                        end
                    end
                    CLKDIV_OFFSET: clkdiv <= maskBytes(clkdiv, Bus.wr_data, Bus.wr_byteEn);
                    CS_OFFSET: cs <= maskBytes({31'd0,cs}, Bus.wr_data, Bus.wr_byteEn);
                    SPIMODE_OFFSET: {cpol,cpha} <= maskBytes({30'd0,cpol,cpha}, Bus.wr_data, Bus.wr_byteEn);
                    DATA_OFFSET: data <= maskBytes({24'd0,data}, Bus.wr_data, Bus.wr_byteEn);
                    default:;
                endcase
            end else begin
                unique case (Bus.wr_addr[ADDRBITS-1:0])
                    START_OFFSET: begin
                        started <= maskBytes({31'd0,started}, Bus.wr_data, Bus.wr_byteEn);
                        // abort logic
                        if(maskBytes({31'd0,started}, Bus.wr_data, Bus.wr_byteEn)&32'h1 == 32'h0) begin
                            dout <= '0;
                            sck <= '0;
                            counter <= '0;
                        end
                    end
                    CS_OFFSET: cs <= maskBytes({31'd0,cs}, Bus.wr_data, Bus.wr_byteEn);
                    default:;
                endcase
            end
        end

        // read register
        if(Bus.rd_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && Bus.rd_valid)begin
            Bus.rd_ready <= '1;
            unique case (Bus.rd_addr[ADDRBITS-1:0])
                START_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,started}, Bus.rd_byteEn);
                CLKDIV_OFFSET: Bus.rd_data <= maskBytes('0, clkdiv, Bus.rd_byteEn);
                CS_OFFSET: Bus.rd_data <= maskBytes('0, {31'd0,cs}, Bus.rd_byteEn);
                SPIMODE_OFFSET: Bus.rd_data <= maskBytes('0, {30'd0,cpol,cpha}, Bus.rd_byteEn);
                DATA_OFFSET: Bus.rd_data <= maskBytes('0, {24'd0,data}, Bus.rd_byteEn);
                default: Bus.rd_data <= '0;
            endcase
        end
    end
end

    
endmodule : spi_m_main
