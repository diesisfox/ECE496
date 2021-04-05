/**** write_top_decl_start_and_interfaces output below ****/

module top(
    inout logic GPIO_0[0],
    inout logic GPIO_0[1],
    inout logic GPIO_0[2],
    inout logic GPIO_0[3],
    inout logic GPIO_0[4],
    inout logic GPIO_0[5],
    inout logic GPIO_0[6],
    inout logic GPIO_0[7],
    output logic FPGA_I2C_SCLK,
    inout logic FPGA_I2C_SDAT
);

AXI5_Lite_IF IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_AXI_if0();

Simple_Mem_IF IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if0();

IP_GPIO_IF IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if1();
tran(GPIO_0[0], IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if1.pins[0]);
tran(GPIO_0[1], IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if1.pins[1]);
tran(GPIO_0[2], IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if1.pins[2]);
tran(GPIO_0[3], IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if1.pins[3]);
tran(GPIO_0[4], IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if1.pins[4]);
tran(GPIO_0[5], IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if1.pins[5]);
tran(GPIO_0[6], IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if1.pins[6]);
tran(GPIO_0[7], IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if1.pins[7]);

AXI5_Lite_IF IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_AXI_if0();

Simple_Mem_IF IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_if0();

IP_I2C_M_IF IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_if1();
tran(FPGA_I2C_SCLK, IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_if1.SCL);
tran(FPGA_I2C_SDAT, IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_if1.SDA);


/**** write_module_instantiations output below ****/


IP_GPIO_Main #(
    .ADDR(32'h0000_0000),
    .PINS(8)
) IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49 (
    .Bus(IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if0),
    .Pins(IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if1)
);

IP_I2C_M_Main #(
    .ADDR(32'h0000_0020),
    .BUS_CLK_HZ()
) IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C (
    .Bus(IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_if0),
    .I2C_IF(IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_if1)
);


/**** write_controller_and_interconnect_inst output below ****/

    AXI_Controller_Worker IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_controller (
        .AXI_IF(IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_AXI_if0.worker),
        .USER_IF(IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_if0.controller)
    );

    AXI_Controller_Worker IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_controller (
        .AXI_IF(IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_AXI_if0.worker),
        .USER_IF(IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_if0.controller)
    );

    AXI_Interconnect #(
        .IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_base_addr(32'h0000_0000),
        .IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_num_bits(4),
        .IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_base_addr(32'h0000_0020),
        .IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_num_bits(5)
    ) xbar (
        .IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF(IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_AXI_if0.manager),
        .IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF(IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_AXI_if0.manager),
        .M_IF(M_IF.worker)
    );


/**** write_top_verilog_end output below ****/


endmodule //top


/**** write_axi_interconnect output below ****/

module AXI_Interconnect #(
    parameter [31:0] IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_base_addr = 32'h0000_0000,
    parameter int IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_num_bits = 4,
    parameter [31:0] IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_base_addr = 32'h0000_0020,
    parameter int IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_num_bits = 5
)(
    AXI5_Lite_IF.WORKER M_IF,
    AXI5_Lite_IF.MANAGER IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF,
    AXI5_Lite_IF.MANAGER IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF
);

    // Clock and reset wiring
    assign IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ACLK = M_IF.ACLK;
    assign IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ARESETn = M_IF.ARESETn;
    assign IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ACLK = M_IF.ACLK;
    assign IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ARESETn = M_IF.ARESETn;

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
        AR_DONE,
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
            if (M_IF.ARREADY && read_state == READ_IDLE) begin
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

        // IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ARADDR = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ARPROT = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ARVALID = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ARSIZE = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ARID = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.RREADY = 'b0;

        // IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ARADDR = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ARPROT = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ARVALID = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ARSIZE = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ARID = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.RREADY = 'b0;

        if (araddr_sel[31:IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_num_bits] == IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_base_addr[31:IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_num_bits]) begin
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ARADDR = M_IF.ARADDR;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ARPROT = M_IF.ARPROT;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ARVALID = M_IF.ARVALID;
            M_IF.ARREADY = IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.ARREADY;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ARSIZE = M_IF.ARSIZE;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.ARID = M_IF.ARID;
            M_IF.RDATA = IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.RDATA;
            M_IF.RRESP = IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.RRESP;
            M_IF.RVALID = IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.RVALID;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.RREADY = M_IF.RREADY;
            M_IF.RID = IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.RID;
        end else if (araddr_sel[31:IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_num_bits] == IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_base_addr[31:IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_num_bits]) begin
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ARADDR = M_IF.ARADDR;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ARPROT = M_IF.ARPROT;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ARVALID = M_IF.ARVALID;
            M_IF.ARREADY = IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.ARREADY;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ARSIZE = M_IF.ARSIZE;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.ARID = M_IF.ARID;
            M_IF.RDATA = IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.RDATA;
            M_IF.RRESP = IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.RRESP;
            M_IF.RVALID = IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.RVALID;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.RREADY = M_IF.RREADY;
            M_IF.RID = IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.RID;
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
            if (M_IF.AWREADY && write_state == WRITE_IDLE) begin
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

        // IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.AWADDR = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.AWPROT = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.AWVALID = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.AWSIZE = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.AWID = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.WDATA = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.WSTRB = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.WVALID = 'b0;
        IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49IF.BREADY = 'b0;

        // IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.AWADDR = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.AWPROT = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.AWVALID = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.AWSIZE = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.AWID = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.WDATA = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.WSTRB = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.WVALID = 'b0;
        IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344CIF.BREADY = 'b0;

        if (awaddr_sel[31:IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_num_bits] == IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_base_addr[31:IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_num_bits]) begin
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.AWADDR = M_IF.AWADDR;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.AWPROT = M_IF.AWPROT;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.AWVALID = M_IF.AWVALID;
            M_IF.AWREADY = IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.AWREADY;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.AWSIZE = M_IF.AWSIZE;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.AWID = M_IF.AWID;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.WDATA = M_IF.WDATA;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.WSTRB = M_IF.WSTRB;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.WVALID = M_IF.WVALID;
            M_IF.WREADY = IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.WREADY;
            M_IF.BRESP = IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.BRESP;
            M_IF.BVALID = IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.BVALID;
            IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.BREADY = M_IF.BREADY;
            M_IF.BID = IP_GPIO_Main_CCA6F5FB625842DBAE623FA654CD1C49_IF.BID;
        end else if (awaddr_sel[31:IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_num_bits] == IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_base_addr[31:IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_num_bits]) begin
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.AWADDR = M_IF.AWADDR;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.AWPROT = M_IF.AWPROT;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.AWVALID = M_IF.AWVALID;
            M_IF.AWREADY = IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.AWREADY;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.AWSIZE = M_IF.AWSIZE;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.AWID = M_IF.AWID;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.WDATA = M_IF.WDATA;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.WSTRB = M_IF.WSTRB;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.WVALID = M_IF.WVALID;
            M_IF.WREADY = IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.WREADY;
            M_IF.BRESP = IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.BRESP;
            M_IF.BVALID = IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.BVALID;
            IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.BREADY = M_IF.BREADY;
            M_IF.BID = IP_I2C_M_Main_49C7109A1D5E477AAE029B95F346344C_IF.BID;
        end
    end

endmodule
