/**** write_top_decl_start_and_interfaces output below ****/

module top(
    input KEY[0],
    output LEDR[0],
    input wire [9:0] SW,
    input logic CLOCK_50,
    output wire [7:0]VGA_R,
    output wire [7:0]VGA_G,
    output wire [7:0]VGA_B,
    output wire VGA_CLK,
    output wire VGA_SYNC_N,
    output wire VGA_BLANK_N,
    output wire VGA_HS,
    output wire VGA_VS
);

AXI5_Lite_IF M_IF ();

AXI5_Lite_IF mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_AXI_if0();

Simple_Worker_Mem_IF mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_if0();

AXI5_Lite_IF IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_AXI_if0();

Simple_Worker_Mem_IF IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if0();

IP_VGA_IF IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if1();

AXI5_Lite_IF IP_GPIO_Main_lol_AXI_if0();
Simple_Worker_Mem_IF IP_GPIO_Main_lol_if0();
IP_GPIO_IF IP_GPIO_Main_lol_if1();



assign IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if1.CLOCK_50 = CLOCK_50;
assign VGA_R = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if1.VGA_R;
assign VGA_G = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if1.VGA_G;
assign VGA_B = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if1.VGA_B;
assign VGA_CLK = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if1.VGA_CLK;
assign VGA_SYNC_N = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if1.VGA_SYNC_N;
assign VGA_BLANK_N = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if1.VGA_BLANK_N;
assign VGA_HS = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if1.VGA_HS;
assign VGA_VS = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if1.VGA_VS;

assign IP_GPIO_Main_lol_if1.in = SW;


/**** write_module_instantiations output below ****/


picorv32_axi #(
    .PROGADDR_RESET(32'h0000_0000),
    .STACKADDR(32'h0000_8000),
    .ENABLE_FAST_MUL(1),
    .ENABLE_DIV(1)
) picorv32_axi_7CB48A78B25546A8AC109ED58AE32A4A (
    .clk(CLOCK_50),
    .resetn(KEY[0]),
    .trap(LEDR[0]),
    .AXI_IF(M_IF)
);

mem_m10k #(
    .ADDR(32'h0000_0000),
    .N_ADDR_BITS(16),
	 .MIF_FILENAME("resources/mandel.mif")
) mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7 (
    .mem_if(mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_if0)
);

// initial begin
// $readmemh("mandel.vh", mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7.mem);
// end

IP_VGA_Main #(
    .ADDR(32'h8000_0000),
    .DEPTH(8),
    .W_DIV_1280(1),
    .H_DIV_960(1),
    .VRAM_MIF("resources/peripherals/vga/Artboard 2.png.p256.png.mif"),
    .PALETTE_MIF("resources/peripherals/vga/Artboard 2.png.palette.png.mif")
) IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F (
    .Bus(IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if0),
    .VGA_IF(IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if1)
);

IP_GPIO_Main #(
    .ADDR(32'h8001_0000),
    .PINS(10)
) IP_GPIO_Main_lol (
    .Bus(IP_GPIO_Main_lol_if0),
    .GPIO_IF(IP_GPIO_Main_lol_if1)
);


/**** write_controller_and_interconnect_inst output below ****/

    AXI_Controller_Worker mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_controller (
        .AXI_IF(mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_AXI_if0),
        .USER_IF(mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_if0)
    );

    AXI_Controller_Worker IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_controller (
        .AXI_IF(IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_AXI_if0),
        .USER_IF(IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_if0)
    );

    
    AXI_Controller_Worker IP_GPIO_Main_lol_controller (
        .AXI_IF(IP_GPIO_Main_lol_AXI_if0),
        .USER_IF(IP_GPIO_Main_lol_if0)
    );

    AXI_Interconnect #(
        .mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_base_addr(32'h0000_0000),
        .mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_num_bits(16),
        .IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_base_addr(32'h8000_0000),
        .IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_num_bits(5),
        
        .IP_GPIO_Main_lol_base_addr(32'h8001_0000),
        .IP_GPIO_Main_lol_num_bits(4)
    ) xbar (
        .mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF(mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_AXI_if0),
        .IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF(IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_AXI_if0),
        
        .IP_GPIO_Main_lol_IF(IP_GPIO_Main_lol_AXI_if0),
        .M_IF(M_IF)
    );


/**** write_top_verilog_end output below ****/


endmodule //top


/**** write_axi_interconnect output below ****/

module AXI_Interconnect #(
    parameter [31:0] mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_base_addr = 32'h0000_0000,
    parameter int mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_num_bits = 16,
    parameter [31:0] IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_base_addr = 32'h8000_0000,
    parameter int IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_num_bits = 5,
    
    parameter [31:0] IP_GPIO_Main_lol_base_addr = 32'h8001_0000,
    parameter int IP_GPIO_Main_lol_num_bits = 4
)(
    AXI5_Lite_IF.WORKER M_IF,
    AXI5_Lite_IF.MANAGER mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF,
    AXI5_Lite_IF.MANAGER IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF,
    
    AXI5_Lite_IF.MANAGER IP_GPIO_Main_lol_IF
);

    // Clock and reset wiring
    assign mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ACLK = M_IF.ACLK;
    assign mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARESETn = M_IF.ARESETn;
    assign IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ACLK = M_IF.ACLK;
    assign IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARESETn = M_IF.ARESETn;
    
    assign IP_GPIO_Main_lol_IF.ACLK = M_IF.ACLK;
    assign IP_GPIO_Main_lol_IF.ARESETn = M_IF.ARESETn;

    logic [31:0] araddr;
    logic [31:0] araddr_latched;
    logic [31:0] araddr_sel;

    logic [31:0] awaddr;
    logic [31:0] awaddr_latched;
    logic [31:0] awaddr_sel;

    assign araddr = M_IF.ARADDR;
    assign awaddr = M_IF.AWADDR;

    enum logic [1:0] {
        READ_IDLE,
        ARADDR_LATCHED,
        AR_DONE
    } read_state;

    // Read state machine
    always_ff @(posedge M_IF.ACLK) begin
        if (M_IF.ARESETn == 1'b0) begin
            read_state <= READ_IDLE;
        end else begin
            case (read_state)
                READ_IDLE : begin
                    if (M_IF.ARREADY && M_IF.ARVALID) begin
                        read_state <= AR_DONE;
                    end else if (M_IF.ARVALID) begin
                        read_state <= ARADDR_LATCHED;
                    end else begin
                        read_state <= READ_IDLE;
                    end
                end
                ARADDR_LATCHED : begin
                    if (M_IF.ARREADY && M_IF.ARVALID) begin
                        read_state <= AR_DONE;
                    end else begin
                        read_state <= ARADDR_LATCHED;
                    end
                end
                AR_DONE : begin
                    if (M_IF.RREADY && M_IF.RVALID) begin
                        read_state <= READ_IDLE;
                    end else begin
                        read_state <= AR_DONE;
                    end
                end
                default : begin
                    read_state <= read_state;
                end
            endcase
        end
    end

    // ARADDR latching
    always_ff @(posedge M_IF.ACLK) begin
        if (M_IF.ARESETn == 1'b0) begin
            araddr_latched <= 32'b0;
        end else begin
            if (M_IF.ARVALID && read_state == READ_IDLE) begin
                araddr_latched <= M_IF.ARADDR;
            end
        end
    end

    // Wiring for araddr_sel, and read XBAR
    always_comb begin
        // Default case - we expect to never hit this
        araddr_sel = 'b0;
        if (read_state == ARADDR_LATCHED || read_state == AR_DONE) begin
            araddr_sel = araddr_latched;
        end else begin
            araddr_sel = araddr;
        end

        // Default tie-offs
        // Manager
        M_IF.ARREADY = 'b0;
        M_IF.RDATA = 'b0;
        M_IF.RRESP = 'b0;
        M_IF.RVALID = 'b0;
        M_IF.RID = 'b0;

        // mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARADDR = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARPROT = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARVALID = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARSIZE = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARID = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.RREADY = 'b0;

        // IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARADDR = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARPROT = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARVALID = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARSIZE = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARID = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.RREADY = 'b0;

        
        IP_GPIO_Main_lol_IF.ARADDR = 'b0;
        IP_GPIO_Main_lol_IF.ARPROT = 'b0;
        IP_GPIO_Main_lol_IF.ARVALID = 'b0;
        IP_GPIO_Main_lol_IF.ARSIZE = 'b0;
        IP_GPIO_Main_lol_IF.ARID = 'b0;
        IP_GPIO_Main_lol_IF.RREADY = 'b0;

        if (araddr_sel[31:mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_num_bits] == mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_base_addr[31:mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_num_bits]) begin
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARADDR = M_IF.ARADDR;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARPROT = M_IF.ARPROT;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARVALID = M_IF.ARVALID;
            M_IF.ARREADY = mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARREADY;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARSIZE = M_IF.ARSIZE;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.ARID = M_IF.ARID;
            M_IF.RDATA = mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.RDATA;
            M_IF.RRESP = mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.RRESP;
            M_IF.RVALID = mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.RVALID;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.RREADY = M_IF.RREADY;
            M_IF.RID = mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.RID;
        end else if (araddr_sel[31:IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_num_bits] == IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_base_addr[31:IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_num_bits]) begin
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARADDR = M_IF.ARADDR;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARPROT = M_IF.ARPROT;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARVALID = M_IF.ARVALID;
            M_IF.ARREADY = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARREADY;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARSIZE = M_IF.ARSIZE;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.ARID = M_IF.ARID;
            M_IF.RDATA = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.RDATA;
            M_IF.RRESP = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.RRESP;
            M_IF.RVALID = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.RVALID;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.RREADY = M_IF.RREADY;
            M_IF.RID = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.RID;
        end else if (araddr_sel[31:IP_GPIO_Main_lol_num_bits] == IP_GPIO_Main_lol_base_addr[31:IP_GPIO_Main_lol_num_bits]) begin
            
            IP_GPIO_Main_lol_IF.ARADDR = M_IF.ARADDR;
            IP_GPIO_Main_lol_IF.ARPROT = M_IF.ARPROT;
            IP_GPIO_Main_lol_IF.ARVALID = M_IF.ARVALID;
            M_IF.ARREADY = IP_GPIO_Main_lol_IF.ARREADY;
            IP_GPIO_Main_lol_IF.ARSIZE = M_IF.ARSIZE;
            IP_GPIO_Main_lol_IF.ARID = M_IF.ARID;
            M_IF.RDATA = IP_GPIO_Main_lol_IF.RDATA;
            M_IF.RRESP = IP_GPIO_Main_lol_IF.RRESP;
            M_IF.RVALID = IP_GPIO_Main_lol_IF.RVALID;
            IP_GPIO_Main_lol_IF.RREADY = M_IF.RREADY;
            M_IF.RID = IP_GPIO_Main_lol_IF.RID;
        end
    end

    enum logic [1:0] {
        WRITE_IDLE,
        AWADDR_LATCHED,
        AW_DONE
    } write_state;

    // Write state machine
    always_ff @(posedge M_IF.ACLK) begin
        if (M_IF.ARESETn == 1'b0) begin
            write_state <= WRITE_IDLE;
        end else begin
            case (write_state)
                WRITE_IDLE : begin
                    if (M_IF.AWREADY && M_IF.AWVALID) begin
                        write_state <= AW_DONE;
                    end else if (M_IF.AWVALID) begin
                        write_state <= AWADDR_LATCHED;
                    end else begin
                        write_state <= WRITE_IDLE;
                    end
                end
                AWADDR_LATCHED : begin
                    if (M_IF.AWREADY && M_IF.AWVALID) begin
                        write_state <= AW_DONE;
                    end else begin
                        write_state <= AWADDR_LATCHED;
                    end
                end
                AW_DONE : begin
                    if (M_IF.BREADY && M_IF.BVALID) begin
                        write_state <= WRITE_IDLE;
                    end else begin
                        write_state <= AW_DONE;
                    end
                end
                default : begin
                    write_state <= write_state;
                end
            endcase
        end
    end

    // AWADDR latching
    always_ff @(posedge M_IF.ACLK) begin
        if (M_IF.ARESETn == 1'b0) begin
            awaddr_latched <= 32'b0;
        end else begin
            if (M_IF.AWVALID && write_state == WRITE_IDLE) begin
                awaddr_latched <= awaddr;
            end
        end
    end

    // Wiring for awaddr_sel and write XBAR
    always_comb begin
        awaddr_sel = 'b0;
        if (write_state == AWADDR_LATCHED || write_state == AW_DONE) begin
            awaddr_sel = awaddr_latched;
        end else begin
            awaddr_sel = awaddr;
        end

        // Default tie-offs
        // Manager
        M_IF.AWREADY = 'b0;
        M_IF.WREADY = 'b0;
        M_IF.BRESP = 'b0;
        M_IF.BVALID = 'b0;
        M_IF.BID = 'b0;

        // mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.AWADDR = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.AWPROT = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.AWVALID = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.AWSIZE = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.AWID = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.WDATA = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.WSTRB = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.WVALID = 'b0;
        mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.BREADY = 'b0;

        // IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.AWADDR = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.AWPROT = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.AWVALID = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.AWSIZE = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.AWID = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.WDATA = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.WSTRB = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.WVALID = 'b0;
        IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.BREADY = 'b0;

        
        IP_GPIO_Main_lol_IF.AWADDR = 'b0;
        IP_GPIO_Main_lol_IF.AWPROT = 'b0;
        IP_GPIO_Main_lol_IF.AWVALID = 'b0;
        IP_GPIO_Main_lol_IF.AWSIZE = 'b0;
        IP_GPIO_Main_lol_IF.AWID = 'b0;
        IP_GPIO_Main_lol_IF.WDATA = 'b0;
        IP_GPIO_Main_lol_IF.WSTRB = 'b0;
        IP_GPIO_Main_lol_IF.WVALID = 'b0;
        IP_GPIO_Main_lol_IF.BREADY = 'b0;

        if (awaddr_sel[31:mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_num_bits] == mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_base_addr[31:mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_num_bits]) begin
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.AWADDR = M_IF.AWADDR;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.AWPROT = M_IF.AWPROT;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.AWVALID = M_IF.AWVALID;
            M_IF.AWREADY = mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.AWREADY;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.AWSIZE = M_IF.AWSIZE;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.AWID = M_IF.AWID;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.WDATA = M_IF.WDATA;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.WSTRB = M_IF.WSTRB;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.WVALID = M_IF.WVALID;
            M_IF.WREADY = mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.WREADY;
            M_IF.BRESP = mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.BRESP;
            M_IF.BVALID = mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.BVALID;
            mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.BREADY = M_IF.BREADY;
            M_IF.BID = mem_m10k_931897D0B4814B10A0108CB4D8FD8FD7_IF.BID;
        end else if (awaddr_sel[31:IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_num_bits] == IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_base_addr[31:IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_num_bits]) begin
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.AWADDR = M_IF.AWADDR;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.AWPROT = M_IF.AWPROT;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.AWVALID = M_IF.AWVALID;
            M_IF.AWREADY = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.AWREADY;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.AWSIZE = M_IF.AWSIZE;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.AWID = M_IF.AWID;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.WDATA = M_IF.WDATA;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.WSTRB = M_IF.WSTRB;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.WVALID = M_IF.WVALID;
            M_IF.WREADY = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.WREADY;
            M_IF.BRESP = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.BRESP;
            M_IF.BVALID = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.BVALID;
            IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.BREADY = M_IF.BREADY;
            M_IF.BID = IP_VGA_Main_6367E892C4E74E548BDF4DBD747EC45F_IF.BID;
        end else if (awaddr_sel[31:IP_GPIO_Main_lol_num_bits] == IP_GPIO_Main_lol_base_addr[31:IP_GPIO_Main_lol_num_bits]) begin
            
            IP_GPIO_Main_lol_IF.AWADDR = M_IF.AWADDR;
            IP_GPIO_Main_lol_IF.AWPROT = M_IF.AWPROT;
            IP_GPIO_Main_lol_IF.AWVALID = M_IF.AWVALID;
            M_IF.AWREADY = IP_GPIO_Main_lol_IF.AWREADY;
            IP_GPIO_Main_lol_IF.AWSIZE = M_IF.AWSIZE;
            IP_GPIO_Main_lol_IF.AWID = M_IF.AWID;
            IP_GPIO_Main_lol_IF.WDATA = M_IF.WDATA;
            IP_GPIO_Main_lol_IF.WSTRB = M_IF.WSTRB;
            IP_GPIO_Main_lol_IF.WVALID = M_IF.WVALID;
            M_IF.WREADY = IP_GPIO_Main_lol_IF.WREADY;
            M_IF.BRESP = IP_GPIO_Main_lol_IF.BRESP;
            M_IF.BVALID = IP_GPIO_Main_lol_IF.BVALID;
            IP_GPIO_Main_lol_IF.BREADY = M_IF.BREADY;
            M_IF.BID = IP_GPIO_Main_lol_IF.BID;
        end
    end

endmodule
