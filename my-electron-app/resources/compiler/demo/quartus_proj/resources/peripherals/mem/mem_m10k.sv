module mem_m10k #(
    parameter int N_ADDR_BITS = 8,
    parameter [31:0] ADDR = 32'h0000_0000,
    parameter MIF_FILENAME = ""
) (
    Simple_Worker_Mem_IF.WORKER mem_if
);

    // helper functions
    function logic [31:0] maskBytes(logic [31:0] old, logic [31:0] in, logic[3:0] en);
        return {en[3]?in[31:24]:old[31:24], en[2]?in[23:16]:old[23:16], en[1]?in[15:8]:old[15:8], en[0]?in[7:0]:old[7:0]};
    endfunction


    localparam BYTE_WIDTH = 8;
    localparam BYTES = 4;
	localparam int WORDS = 2**(N_ADDR_BITS - 2);
	
	reg [31:0] r_data;
	assign mem_if.rd_data = r_data;

    // This _should_ synthesize correctly to M10Ks with the pragma attached
	(* ramstyle = "M10K, no_rw_check" *) logic [31:0] mem [0:WORDS-1];
    initial begin
        $readmemh("mandel.vh", mem);
    end
    // logic [31:0] mem [0:WORDS-1];

    // wr_ready generation
    always_ff @(posedge mem_if.clock) begin
        if (mem_if.reset_n == 1'b0) begin
            mem_if.wr_ready <= 1'b1;
        end else begin
            if (mem_if.wr_ready && mem_if.wr_valid) begin
                mem_if.wr_ready <= 1'b0;
            end
            if (!mem_if.wr_ready && !mem_if.wr_valid) begin
                mem_if.wr_ready <= 1'b1;
            end
        end
    end

    // rd_ready generation
    // This uses the opposite behaviour to wr_ready generation because we use a
    //     read-pipelined RAM
    // Therefore, we get the following behaviour:
    // Clock edge 0: rd_valid goes HIGH
    // Clock edge 1: rd_ready goes HIGH, data becomes available on bus
    // Clock edge 2: rd_ready goes LOW (rd_valid should also go LOW)
    always_ff @(posedge mem_if.clock) begin
        if (mem_if.reset_n == 1'b0) begin
            mem_if.rd_ready <= 1'b0;
        end else begin
            if (mem_if.rd_valid && !mem_if.rd_ready) begin
                mem_if.rd_ready <= 1'b1;
            end
            if (mem_if.rd_ready && mem_if.rd_valid) begin
                mem_if.rd_ready <= 1'b0;
            end
        end
    end

	always_ff@(posedge mem_if.clock) begin
		if (mem_if.wr_valid && mem_if.wr_ready) begin
            // Our index into mem does not use the lowest 2 bits of the address because
            //     we assume accesses will always be word-aligned (i.e. aligned to 4 bytes)
            // This behaviour is true of the PicoRV32 CPU shipped with this project
            mem[mem_if.wr_addr[N_ADDR_BITS-1 : 2]] <= maskBytes(mem[mem_if.wr_addr[N_ADDR_BITS-1 : 2]], mem_if.wr_data, mem_if.wr_byteEn);
	end
		r_data <= mem[mem_if.rd_addr[N_ADDR_BITS - 1 : 2]];
	end

endmodule : mem_m10k 

// Quartus Prime SystemVerilog Template
//
// Simple Dual-Port RAM with different read/write addresses and single read/write clock
// and with a control for writing single bytes into the memory word; byte enable

module byte_enabled_simple_dual_port_ram
	#(parameter int
		ADDR_WIDTH = 6,
		BYTE_WIDTH = 8,
		BYTES = 4,
			WIDTH = BYTES * BYTE_WIDTH
)
( 
	input [ADDR_WIDTH-1:0] waddr,
	input [ADDR_WIDTH-1:0] raddr,
	input [BYTES-1:0] be,
	input [BYTE_WIDTH-1:0] wdata, 
	input we, clk,
	output reg [WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a multi-dimensional packed array to model individual bytes within the word
	logic [BYTES-1:0][BYTE_WIDTH-1:0] ram[0:WORDS-1];

	always_ff@(posedge clk)
	begin
		if(we) begin
		// edit this code if using other than four bytes per word
			if(be[0]) ram[waddr][0] <= wdata;
			if(be[1]) ram[waddr][1] <= wdata;
			if(be[2]) ram[waddr][2] <= wdata;
			if(be[3]) ram[waddr][3] <= wdata;
	end
		q <= ram[raddr];
	end
endmodule : byte_enabled_simple_dual_port_ram

