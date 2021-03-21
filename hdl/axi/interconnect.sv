module AXI_Interconnect #(
// FIXED END
    parameter [31:0] w0_base_addr = 32'h0,
    parameter [31:0] w1_base_addr = 32'h0,
    parameter [31:0] w2_base_addr = 32'h0,
    parameter [31:0] w3_base_addr = 32'h0,
    parameter int w0_num_bits = 4,
    parameter int w1_num_bits = 4,
    parameter int w2_num_bits = 4,
    parameter int w3_num_bits = 4
// FIXED START
)(
    AXI5_Lite_IF.WORKER M_IF,
// FIXED END
    AXI5_Lite_IF.MANAGER W0_IF,
    AXI5_Lite_IF.MANAGER W1_IF,
    AXI5_Lite_IF.MANAGER W2_IF,
    AXI5_Lite_IF.MANAGER W3_IF
// FIXED START
);

    // Clock and reset wiring
// FIXED END
    assign W0_IF.ACLK = M_IF.ACLK;
    assign W0_IF.ARESETn = M_IF.ARESETn;
    assign W1_IF.ACLK = M_IF.ACLK;
    assign W1_IF.ARESETn = M_IF.ARESETn;
    assign W2_IF.ACLK = M_IF.ACLK;
    assign W2_IF.ARESETn = M_IF.ARESETn;
    assign W3_IF.ACLK = M_IF.ACLK;
    assign W3_IF.ARESETn = M_IF.ARESETn;

// FIXED START
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
            if (M_IF.ARREADY && read_state == READ_IDLE) begin
                araddr_latched <= M_IF.ARADDR;
            end
        end
    end

    // Wiring for araddr_sel, and read XBAR
    always_comb begin
        // Default case - we should never hit this
        araddr_sel = 'b0; 
        if (read_state == ARADDR_LATCHED || read_state == AR_DONE) begin
            araddr_sel = araddr_latched;
        end else begin
            araddr_sel = araddr;
        end
// FIXED END
        // Default tie-offs
        // Manager
        M_IF.ARREADY = 'b0;
        M_IF.RDATA = 'b0;
        M_IF.RRESP = 'b0;
        M_IF.RVALID = 'b0;
        M_IF.RID = 'b0;

        // Worker 0
        W0_IF.ARADDR = 'b0;
        W0_IF.ARPROT = 'b0;
        W0_IF.ARVALID = 'b0;
        W0_IF.ARSIZE = 'b0;
        W0_IF.ARID = 'b0;
        W0_IF.RREADY = 'b0;

        // Worker 1
        W1_IF.ARADDR = 'b0;
        W1_IF.ARPROT = 'b0;
        W1_IF.ARVALID = 'b0;
        W1_IF.ARSIZE = 'b0;
        W1_IF.ARID = 'b0;
        W1_IF.RREADY = 'b0;

        // Worker 2
        W2_IF.ARADDR = 'b0;
        W2_IF.ARPROT = 'b0;
        W2_IF.ARVALID = 'b0;
        W2_IF.ARSIZE = 'b0;
        W2_IF.ARID = 'b0;
        W2_IF.RREADY = 'b0;

        // Worker 3
        W3_IF.ARADDR = 'b0;
        W3_IF.ARPROT = 'b0;
        W3_IF.ARVALID = 'b0;
        W3_IF.ARSIZE = 'b0;
        W3_IF.ARID = 'b0;
        W3_IF.RREADY = 'b0;

        if (araddr_sel[31:w0_num_bits] == w0_base_addr[31:w0_num_bits]) begin
            W0_IF.ARADDR = M_IF.ARADDR;
            W0_IF.ARPROT = M_IF.ARPROT;
            W0_IF.ARVALID = M_IF.ARVALID;
            M_IF.ARREADY = W0_IF.ARREADY;
            W0_IF.ARSIZE = M_IF.ARSIZE;
            W0_IF.ARID = M_IF.ARID;
            
            M_IF.RDATA = W0_IF.RDATA;
            M_IF.RRESP = W0_IF.RRESP;
            M_IF.RVALID = W0_IF.RVALID;
            W0_IF.RREADY = M_IF.RREADY;
            M_IF.RID = W0_IF.RID;
        end else if (araddr_sel[31:w1_num_bits] == w1_base_addr [31:w1_num_bits]) begin
            W1_IF.ARADDR = M_IF.ARADDR;
            W1_IF.ARPROT = M_IF.ARPROT;
            W1_IF.ARVALID = M_IF.ARVALID;
            M_IF.ARREADY = W1_IF.ARREADY;
            W1_IF.ARSIZE = M_IF.ARSIZE;
            W1_IF.ARID = M_IF.ARID;
            
            M_IF.RDATA = W1_IF.RDATA;
            M_IF.RRESP = W1_IF.RRESP;
            M_IF.RVALID = W1_IF.RVALID;
            W1_IF.RREADY = M_IF.RREADY;
            M_IF.RID = W1_IF.RID;
        end else if (araddr_sel[31:w2_num_bits] == w2_base_addr [31:w2_num_bits]) begin
            W2_IF.ARADDR = M_IF.ARADDR;
            W2_IF.ARPROT = M_IF.ARPROT;
            W2_IF.ARVALID = M_IF.ARVALID;
            M_IF.ARREADY = W2_IF.ARREADY;
            W2_IF.ARSIZE = M_IF.ARSIZE;
            W2_IF.ARID = M_IF.ARID;
            
            M_IF.RDATA = W2_IF.RDATA;
            M_IF.RRESP = W2_IF.RRESP;
            M_IF.RVALID = W2_IF.RVALID;
            W2_IF.RREADY = M_IF.RREADY;
            M_IF.RID = W2_IF.RID;
        end else if (araddr_sel[31:w3_num_bits] == w3_base_addr [31:w3_num_bits]) begin
            W3_IF.ARADDR = M_IF.ARADDR;
            W3_IF.ARPROT = M_IF.ARPROT;
            W3_IF.ARVALID = M_IF.ARVALID;
            M_IF.ARREADY = W3_IF.ARREADY;
            W3_IF.ARSIZE = M_IF.ARSIZE;
            W3_IF.ARID = M_IF.ARID;
            
            M_IF.RDATA = W3_IF.RDATA;
            M_IF.RRESP = W3_IF.RRESP;
            M_IF.RVALID = W3_IF.RVALID;
            W3_IF.RREADY = M_IF.RREADY;
            M_IF.RID = W3_IF.RID;
        end
// FIXED START
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

// FIXED END
        // Default tie-offs
        // Manager
        M_IF.AWREADY = 'b0;
        M_IF.WREADY = 'b0;
        M_IF.BRESP = 'b0;
        M_IF.BVALID = 'b0;
        M_IF.BID = 'b0;

        // Worker 0
        W0_IF.AWADDR = 'b0;
        W0_IF.AWPROT = 'b0;
        W0_IF.AWVALID = 'b0;
        W0_IF.AWSIZE = 'b0;
        W0_IF.AWID = 'b0;
        W0_IF.WDATA = 'b0;
        W0_IF.WSTRB = 'b0;
        W0_IF.WVALID = 'b0;
        W0_IF.BREADY = 'b0;

        // Worker 1
        W1_IF.AWADDR = 'b0;
        W1_IF.AWPROT = 'b0;
        W1_IF.AWVALID = 'b0;
        W1_IF.AWSIZE = 'b0;
        W1_IF.AWID = 'b0;
        W1_IF.WDATA = 'b0;
        W1_IF.WSTRB = 'b0;
        W1_IF.WVALID = 'b0;
        W1_IF.BREADY = 'b0;

        // Worker 2
        W2_IF.AWADDR = 'b0;
        W2_IF.AWPROT = 'b0;
        W2_IF.AWVALID = 'b0;
        W2_IF.AWSIZE = 'b0;
        W2_IF.AWID = 'b0;
        W2_IF.WDATA = 'b0;
        W2_IF.WSTRB = 'b0;
        W2_IF.WVALID = 'b0;
        W2_IF.BREADY = 'b0;

        // Worker 3
        W3_IF.AWADDR = 'b0;
        W3_IF.AWPROT = 'b0;
        W3_IF.AWVALID = 'b0;
        W3_IF.AWSIZE = 'b0;
        W3_IF.AWID = 'b0;
        W3_IF.WDATA = 'b0;
        W3_IF.WSTRB = 'b0;
        W3_IF.WVALID = 'b0;
        W3_IF.BREADY = 'b0;

        if (awaddr_sel[31:w0_num_bits] == w0_base_addr[31:w0_num_bits]) begin
            W0_IF.AWADDR = M_IF.AWADDR;
            W0_IF.AWPROT = M_IF.AWPROT;
            W0_IF.AWVALID = M_IF.AWVALID;
            M_IF.AWREADY = W0_IF.AWREADY;
            W0_IF.AWSIZE = M_IF.AWSIZE;
            W0_IF.AWID = M_IF.AWID;
            
            W0_IF.WDATA = M_IF.WDATA;
            W0_IF.WSTRB = M_IF.WSTRB;
            W0_IF.WVALID = M_IF.WVALID;
            M_IF.WREADY = W0_IF.WREADY;

            M_IF.BRESP = W0_IF.BRESP;
            M_IF.BVALID = W0_IF.BVALID;
            W0_IF.BREADY = M_IF.BREADY;
            M_IF.BID = W0_IF.BID;
        end else if (awaddr_sel[31:w1_num_bits] == w1_base_addr[31:w1_num_bits]) begin
            W1_IF.AWADDR = M_IF.AWADDR;
            W1_IF.AWPROT = M_IF.AWPROT;
            W1_IF.AWVALID = M_IF.AWVALID;
            M_IF.AWREADY = W1_IF.AWREADY;
            W1_IF.AWSIZE = M_IF.AWSIZE;
            W1_IF.AWID = M_IF.AWID;
            
            W1_IF.WDATA = M_IF.WDATA;
            W1_IF.WSTRB = M_IF.WSTRB;
            W1_IF.WVALID = M_IF.WVALID;
            M_IF.WREADY = W1_IF.WREADY;

            M_IF.BRESP = W1_IF.BRESP;
            M_IF.BVALID = W1_IF.BVALID;
            W1_IF.BREADY = M_IF.BREADY;
            M_IF.BID = W1_IF.BID;
        end else if (awaddr_sel[31:w2_num_bits] == w2_base_addr[31:w2_num_bits]) begin
            W2_IF.AWADDR = M_IF.AWADDR;
            W2_IF.AWPROT = M_IF.AWPROT;
            W2_IF.AWVALID = M_IF.AWVALID;
            M_IF.AWREADY = W2_IF.AWREADY;
            W2_IF.AWSIZE = M_IF.AWSIZE;
            W2_IF.AWID = M_IF.AWID;
            
            W2_IF.WDATA = M_IF.WDATA;
            W2_IF.WSTRB = M_IF.WSTRB;
            W2_IF.WVALID = M_IF.WVALID;
            M_IF.WREADY = W2_IF.WREADY;

            M_IF.BRESP = W2_IF.BRESP;
            M_IF.BVALID = W2_IF.BVALID;
            W2_IF.BREADY = M_IF.BREADY;
            M_IF.BID = W2_IF.BID;
        end else if (awaddr_sel[31:w3_num_bits] == w3_base_addr[31:w3_num_bits]) begin
            W3_IF.AWADDR = M_IF.AWADDR;
            W3_IF.AWPROT = M_IF.AWPROT;
            W3_IF.AWVALID = M_IF.AWVALID;
            M_IF.AWREADY = W3_IF.AWREADY;
            W3_IF.AWSIZE = M_IF.AWSIZE;
            W3_IF.AWID = M_IF.AWID;
            
            W3_IF.WDATA = M_IF.WDATA;
            W3_IF.WSTRB = M_IF.WSTRB;
            W3_IF.WVALID = M_IF.WVALID;
            M_IF.WREADY = W3_IF.WREADY;

            M_IF.BRESP = W3_IF.BRESP;
            M_IF.BVALID = W3_IF.BVALID;
            W3_IF.BREADY = M_IF.BREADY;
            M_IF.BID = W3_IF.BID;
        end 
// FIXED START
    end

endmodule
