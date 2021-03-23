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
    inout logic GPIO_0[8],
    inout logic GPIO_0[9],
    inout logic GPIO_0[10],
    inout logic GPIO_0[11],
    inout logic GPIO_0[12],
    output logic FPGA_I2C_SCLK,
    inout logic FPGA_I2C_SDAT
);

AXI5_Lite_IF ip_gpio_main_128943FD78AB_AXI_if0();

Simple_Mem_IF ip_gpio_main_128943FD78AB_if0();

IP_GPIO_IF ip_gpio_main_128943FD78AB_if1();
tran(GPIO_0[0], ip_gpio_main_128943FD78AB_if1.pins[0]);
tran(GPIO_0[1], ip_gpio_main_128943FD78AB_if1.pins[1]);
tran(GPIO_0[2], ip_gpio_main_128943FD78AB_if1.pins[2]);
tran(GPIO_0[3], ip_gpio_main_128943FD78AB_if1.pins[3]);
tran(GPIO_0[4], ip_gpio_main_128943FD78AB_if1.pins[4]);
tran(GPIO_0[5], ip_gpio_main_128943FD78AB_if1.pins[5]);
tran(GPIO_0[6], ip_gpio_main_128943FD78AB_if1.pins[6]);
tran(GPIO_0[7], ip_gpio_main_128943FD78AB_if1.pins[7]);
tran(GPIO_0[8], ip_gpio_main_128943FD78AB_if1.pins[8]);
tran(GPIO_0[9], ip_gpio_main_128943FD78AB_if1.pins[9]);
tran(GPIO_0[10], ip_gpio_main_128943FD78AB_if1.pins[10]);
tran(GPIO_0[11], ip_gpio_main_128943FD78AB_if1.pins[11]);
tran(GPIO_0[12], ip_gpio_main_128943FD78AB_if1.pins[12]);

AXI5_Lite_IF ip_i2c_m_main_BBBB43FD78AB_AXI_if0();

Simple_Mem_IF ip_i2c_m_main_BBBB43FD78AB_if0();

IP_I2C_M_IF ip_i2c_m_main_BBBB43FD78AB_if1();
tran(FPGA_I2C_SCLK, ip_i2c_m_main_BBBB43FD78AB_if1.SCL);
tran(FPGA_I2C_SDAT, ip_i2c_m_main_BBBB43FD78AB_if1.SDA);


/**** write_module_instantiations output below ****/


IP_GPIO_Main #(
    .ADDR(32'h8000_0000),
    .PINS(12)
) ip_gpio_main_128943FD78AB (
    .Bus(ip_gpio_main_128943FD78AB_if0),
    .Pins(ip_gpio_main_128943FD78AB_if1)
);

ip_i2c_m_main #(
    .ADDR(32'h8001_0000),
    .BUS_CLK_HZ(100000000)
) ip_i2c_m_main_BBBB43FD78AB (
    .Bus(ip_i2c_m_main_BBBB43FD78AB_if0),
    .I2C_IF(ip_i2c_m_main_BBBB43FD78AB_if1)
);


/**** write_controller_and_interconnect_inst output below ****/

    AXI_Controller_Worker ip_gpio_main_128943FD78AB_controller (
        .AXI_IF(ip_gpio_main_128943FD78AB_AXI_if0.worker),
        .USER_IF(ip_gpio_main_128943FD78AB_if0.controller)
    );

    AXI_Controller_Worker ip_i2c_m_main_BBBB43FD78AB_controller (
        .AXI_IF(ip_i2c_m_main_BBBB43FD78AB_AXI_if0.worker),
        .USER_IF(ip_i2c_m_main_BBBB43FD78AB_if0.controller)
    );

    AXI_Interconnect #(
        .ip_gpio_main_128943FD78AB_base_addr(32'h8000_0000),
        .ip_gpio_main_128943FD78AB_num_bits(4),
        .ip_i2c_m_main_BBBB43FD78AB_base_addr(32'h8001_0000),
        .ip_i2c_m_main_BBBB43FD78AB_num_bits(5)
    ) xbar (
        .ip_gpio_main_128943FD78AB_IF(ip_gpio_main_128943FD78AB_AXI_if0.manager),
        .ip_i2c_m_main_BBBB43FD78AB_IF(ip_i2c_m_main_BBBB43FD78AB_AXI_if0.manager),
        .M_IF(M_IF.worker)
    );


/**** write_top_verilog_end output below ****/


endmodule //top


/**** write_axi_interconnect output below ****/

module AXI_Interconnect #(
    parameter [31:0] ip_gpio_main_128943FD78AB_base_addr = 32'h8000_0000,
    parameter int ip_gpio_main_128943FD78AB_num_bits = 4,
    parameter [31:0] ip_i2c_m_main_BBBB43FD78AB_base_addr = 32'h8001_0000,
    parameter int ip_i2c_m_main_BBBB43FD78AB_num_bits = 5
)(
    AXI5_Lite_IF.WORKER M_IF,
    AXI5_Lite_IF.MANAGER ip_gpio_main_128943FD78AB_IF,
    AXI5_Lite_IF.MANAGER ip_i2c_m_main_BBBB43FD78AB_IF
);

    // Clock and reset wiring
    assign ip_gpio_main_128943FD78AB_IF.ACLK = M_IF.ACLK;
    assign ip_gpio_main_128943FD78AB_IF.ARESETn = M_IF.ARESETn;
    assign ip_i2c_m_main_BBBB43FD78AB_IF.ACLK = M_IF.ACLK;
    assign ip_i2c_m_main_BBBB43FD78AB_IF.ARESETn = M_IF.ARESETn;

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

        // ip_gpio_main_128943FD78AB
        ip_gpio_main_128943FD78AB_IF.ARADDR = 'b0;
        ip_gpio_main_128943FD78AB_IF.ARPROT = 'b0;
        ip_gpio_main_128943FD78AB_IF.ARVALID = 'b0;
        ip_gpio_main_128943FD78AB_IF.ARSIZE = 'b0;
        ip_gpio_main_128943FD78AB_IF.ARID = 'b0;
        ip_gpio_main_128943FD78AB_IF.RREADY = 'b0;

        // ip_i2c_m_main_BBBB43FD78AB
        ip_i2c_m_main_BBBB43FD78AB_IF.ARADDR = 'b0;
        ip_i2c_m_main_BBBB43FD78AB_IF.ARPROT = 'b0;
        ip_i2c_m_main_BBBB43FD78AB_IF.ARVALID = 'b0;
        ip_i2c_m_main_BBBB43FD78AB_IF.ARSIZE = 'b0;
        ip_i2c_m_main_BBBB43FD78AB_IF.ARID = 'b0;
        ip_i2c_m_main_BBBB43FD78AB_IF.RREADY = 'b0;

        if (araddr_sel[31:ip_gpio_main_128943FD78AB_num_bits] == ip_gpio_main_128943FD78AB_base_addr[31:ip_gpio_main_128943FD78AB_num_bits]) begin
            ip_gpio_main_128943FD78AB_IF.ARADDR = M_IF.ARADDR;
            ip_gpio_main_128943FD78AB_IF.ARPROT = M_IF.ARPROT;
            ip_gpio_main_128943FD78AB_IF.ARVALID = M_IF.ARVALID;
            M_IF.ARREADY = ip_gpio_main_128943FD78ABIF.ARREADY;
            ip_gpio_main_128943FD78AB_IF.ARSIZE = M_IF.ARSIZE;
            ip_gpio_main_128943FD78AB_IF.ARID = M_IF.ARID;
            M_IF.RDATA = ip_gpio_main_128943FD78ABIF.RDATA;
            M_IF.RRESP = ip_gpio_main_128943FD78ABIF.RRESP;
            M_IF.RVALID = ip_gpio_main_128943FD78ABIF.RVALID;
            ip_gpio_main_128943FD78AB_IF.RREADY = M_IF.RREADY;
            M_IF.RID = ip_gpio_main_128943FD78ABIF.RID;
        end else if (araddr_sel[31:ip_i2c_m_main_BBBB43FD78AB_num_bits] == ip_i2c_m_main_BBBB43FD78AB_base_addr[31:ip_i2c_m_main_BBBB43FD78AB_num_bits]) begin
            ip_i2c_m_main_BBBB43FD78AB_IF.ARADDR = M_IF.ARADDR;
            ip_i2c_m_main_BBBB43FD78AB_IF.ARPROT = M_IF.ARPROT;
            ip_i2c_m_main_BBBB43FD78AB_IF.ARVALID = M_IF.ARVALID;
            M_IF.ARREADY = ip_i2c_m_main_BBBB43FD78ABIF.ARREADY;
            ip_i2c_m_main_BBBB43FD78AB_IF.ARSIZE = M_IF.ARSIZE;
            ip_i2c_m_main_BBBB43FD78AB_IF.ARID = M_IF.ARID;
            M_IF.RDATA = ip_i2c_m_main_BBBB43FD78ABIF.RDATA;
            M_IF.RRESP = ip_i2c_m_main_BBBB43FD78ABIF.RRESP;
            M_IF.RVALID = ip_i2c_m_main_BBBB43FD78ABIF.RVALID;
            ip_i2c_m_main_BBBB43FD78AB_IF.RREADY = M_IF.RREADY;
            M_IF.RID = ip_i2c_m_main_BBBB43FD78ABIF.RID;
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

        // ip_gpio_main_128943FD78AB
        ip_gpio_main_128943FD78ABIF.AWADDR = 'b0;
        ip_gpio_main_128943FD78ABIF.AWPROT = 'b0;
        ip_gpio_main_128943FD78ABIF.AWVALID = 'b0;
        ip_gpio_main_128943FD78ABIF.AWSIZE = 'b0;
        ip_gpio_main_128943FD78ABIF.AWID = 'b0;
        ip_gpio_main_128943FD78ABIF.WDATA = 'b0;
        ip_gpio_main_128943FD78ABIF.WSTRB = 'b0;
        ip_gpio_main_128943FD78ABIF.WVALID = 'b0;
        ip_gpio_main_128943FD78ABIF.BREADY = 'b0;

        // ip_i2c_m_main_BBBB43FD78AB
        ip_i2c_m_main_BBBB43FD78ABIF.AWADDR = 'b0;
        ip_i2c_m_main_BBBB43FD78ABIF.AWPROT = 'b0;
        ip_i2c_m_main_BBBB43FD78ABIF.AWVALID = 'b0;
        ip_i2c_m_main_BBBB43FD78ABIF.AWSIZE = 'b0;
        ip_i2c_m_main_BBBB43FD78ABIF.AWID = 'b0;
        ip_i2c_m_main_BBBB43FD78ABIF.WDATA = 'b0;
        ip_i2c_m_main_BBBB43FD78ABIF.WSTRB = 'b0;
        ip_i2c_m_main_BBBB43FD78ABIF.WVALID = 'b0;
        ip_i2c_m_main_BBBB43FD78ABIF.BREADY = 'b0;

        if (awaddr_sel[31:ip_gpio_main_128943FD78AB_num_bits] == ip_gpio_main_128943FD78AB_base_addr[31:ip_gpio_main_128943FD78AB_num_bits]) begin
            ip_gpio_main_128943FD78AB_IF.AWADDR = M_IF.AWADDR;
            ip_gpio_main_128943FD78AB_IF.AWPROT = M_IF.AWPROT;
            ip_gpio_main_128943FD78AB_IF.AWVALID = M_IF.AWVALID;
            M_IF.AWREADY = ip_gpio_main_128943FD78AB_IF.AWREADY;
            ip_gpio_main_128943FD78AB_IF.AWSIZE = M_IF.AWSIZE;
            ip_gpio_main_128943FD78AB_IF.AWID = M_IF.AWID;
            ip_gpio_main_128943FD78AB_IF.WDATA = M_IF.WDATA;
            ip_gpio_main_128943FD78AB_IF.WSTRB = M_IF.WSTRB;
            ip_gpio_main_128943FD78AB_IF.WVALID = M_IF.WVALID;
            M_IF.WREADY = ip_gpio_main_128943FD78AB_IF.WREADY;
            M_IF.BRESP = ip_gpio_main_128943FD78AB_IF.BRESP;
            M_IF.BVALID = ip_gpio_main_128943FD78AB_IF.BVALID;
            ip_gpio_main_128943FD78AB_IF.BREADY = M_IF.BREADY;
            M_IF.BID = ip_gpio_main_128943FD78AB_IF.BID;
        end else if (awaddr_sel[31:ip_i2c_m_main_BBBB43FD78AB_num_bits] == ip_i2c_m_main_BBBB43FD78AB_base_addr[31:ip_i2c_m_main_BBBB43FD78AB_num_bits]) begin
            ip_i2c_m_main_BBBB43FD78AB_IF.AWADDR = M_IF.AWADDR;
            ip_i2c_m_main_BBBB43FD78AB_IF.AWPROT = M_IF.AWPROT;
            ip_i2c_m_main_BBBB43FD78AB_IF.AWVALID = M_IF.AWVALID;
            M_IF.AWREADY = ip_i2c_m_main_BBBB43FD78AB_IF.AWREADY;
            ip_i2c_m_main_BBBB43FD78AB_IF.AWSIZE = M_IF.AWSIZE;
            ip_i2c_m_main_BBBB43FD78AB_IF.AWID = M_IF.AWID;
            ip_i2c_m_main_BBBB43FD78AB_IF.WDATA = M_IF.WDATA;
            ip_i2c_m_main_BBBB43FD78AB_IF.WSTRB = M_IF.WSTRB;
            ip_i2c_m_main_BBBB43FD78AB_IF.WVALID = M_IF.WVALID;
            M_IF.WREADY = ip_i2c_m_main_BBBB43FD78AB_IF.WREADY;
            M_IF.BRESP = ip_i2c_m_main_BBBB43FD78AB_IF.BRESP;
            M_IF.BVALID = ip_i2c_m_main_BBBB43FD78AB_IF.BVALID;
            ip_i2c_m_main_BBBB43FD78AB_IF.BREADY = M_IF.BREADY;
            M_IF.BID = ip_i2c_m_main_BBBB43FD78AB_IF.BID;
        end
    end

endmodule
