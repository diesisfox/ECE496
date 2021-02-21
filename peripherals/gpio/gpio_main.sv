`ifdef ICARUSVERILOG `include "interfaces.sv" `endif

module ip_gpio_main #(
    parameter PINS = 8,
    parameter ADDR = 'h1000_0000
) (
    Simple_Mem_IF.COWI Bus,
    inout logic [PINS-1:0] pins
);

localparam ADDRBITS = 4;
localparam DIR_OFFSET = 'h0;
localparam READ_OFFSET = 'h4;
localparam WRITE_OFFSET = 'h8;

logic [PINS-1:0] oe = '0;
logic [PINS-1:0] out = '0;
assign pins = oe ? out : 'bZ;

function logic [31:0] maskBytes(input logic [31:0] old, input logic [31:0] in, input logic[3:0] en);
    return {en[3]?in[31:24]:old[31:24], en[2]?in[23:16]:old[23:16], en[1]?in[15:8]:old[15:8], en[0]?in[7:0]:old[7:0]};
endfunction

always_ff @(posedge Bus.clock) begin
    if (!Bus.reset_n) begin
        oe <= '0;
        out <= '0;
        Bus.wr_ready <= '0;
        Bus.rd_ready <= '0;
        Bus.rd_data <= '0;
    end else begin
        //defaults
        oe <= oe;
        out <= out;
        Bus.wr_ready <= '0;
        Bus.rd_ready <= '0;
        Bus.rd_data <= '0;

        // write
        if(Bus.wr_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && Bus.wr_valid)begin
            Bus.wr_ready <= '1;
            unique case (Bus.wr_addr[ADDRBITS-1:0])
                DIR_OFFSET: oe <= maskBytes(oe, Bus.wr_data, Bus.wr_byteEn);
                WRITE_OFFSET: out <= maskBytes(out, Bus.wr_data, Bus.wr_byteEn);
                default:;
            endcase
        end

        // read
        if(Bus.rd_addr[31:ADDRBITS] == ADDR[31:ADDRBITS] && Bus.rd_valid)begin
            Bus.rd_ready <= '1;
            unique case (Bus.rd_addr[ADDRBITS-1:0])
                DIR_OFFSET: Bus.rd_data <= maskBytes('0, oe, Bus.rd_byteEn);
                WRITE_OFFSET: Bus.rd_data <= maskBytes('0, out, Bus.rd_byteEn);
                READ_OFFSET: Bus.rd_data <= maskBytes('0, pins, Bus.rd_byteEn);
                default:;
            endcase
        end
    end
end
    
endmodule
