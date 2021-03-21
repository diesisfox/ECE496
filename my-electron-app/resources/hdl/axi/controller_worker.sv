module AXI_Controller_Worker (
    Simple_Worker_Mem_IF.CONTROLLER USER_IF,
    AXI5_Lite_IF.WORKER AXI_IF
);

    // Buffers for incoming data
    logic [31:0] awaddr_latch;
    logic [ 0:0] awid_latch;
    logic [31:0] wdata_latch;
    logic [ 3:0] wstrb_latch;

    logic [31:0] araddr_latch;
    logic [ 0:0] arid_latch;
    logic [31:0] user_rddata_latch;

    // Status signals for synchronizing multiple channels
    logic write_address_latched;
    logic write_data_latched;
    logic write_user_handshake_done;
    logic write_done;

    logic read_address_latched;
    logic read_user_handshake_done;
    logic read_done;

    // Wire the clock and reset into the worker
    assign USER_IF.clock = AXI_IF.ACLK;
    assign USER_IF.reset_n = AXI_IF.ARESETn;
    
    // Reg used for bringing up READY signals after reset
    logic reset_latch;
    always @(posedge AXI_IF.ACLK) begin
        reset_latch <= AXI_IF.ARESETn;
    end

    ///////////////////////////////////////////////////////////////////////////
    ////                                                                   ////
    ////                    Write Channel Logic                            ////
    ////                                                                   ////
    ///////////////////////////////////////////////////////////////////////////

    // AWREADY generation
    // AWREADY is asserted HIGH by default to enable single-cycle transfers
    // It will go LOW when AWVALID is HIGH - i.e., when a write addr transfer
    //     is accepted.
    // Once LOW, it will remain so until:
    //     a.) A transfer is accepted on the write data channel
    //     AND
    //     b.) A transfer is accepted on the write response channel
    // i.e., until the end of the write transaction
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            AXI_IF.AWREADY <= 1'b0;            
        end else begin
            if (AXI_IF.AWREADY && AXI_IF.AWVALID && !write_address_latched) begin
                AXI_IF.AWREADY <= 1'b0;
            end
            if (!AXI_IF.AWREADY && write_done) begin
                AXI_IF.AWREADY <= 1'b1;
            end
        end
    end

    // AWADDR latching
    // This block is responsible for capturing AWADDR, i.e. latching it in
    // It will capture the address on AWADDR when AWREADY and AWVALID are
    //     both HIGH
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            awaddr_latch <= 'b0;
            awid_latch <= 'b0;
        end else begin
            if (AXI_IF.AWREADY && AXI_IF.AWVALID && !write_address_latched) begin
                awaddr_latch <= AXI_IF.AWADDR;
                awid_latch <= AXI_IF.AWID;
            end
        end
    end

    // WREADY generation
    // WREADY is asserted HIGH by default to enable single-cycle transfers
    // It will go LOW when WVALID is HIGH - i.e., when a write data transfer
    //     is accepted.
    // Once LOW it will remain so until:
    //     a.) A transfer is accepted on the write address channel
    //     AND
    //     b.) A transfer is accepted (by the manager) on the write response
    //             channel
    // i.e., until the end of the write transaction
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            AXI_IF.WREADY <= 1'b0;
        end else begin
            if (AXI_IF.WREADY && AXI_IF.WVALID && !write_data_latched) begin
                AXI_IF.WREADY <= 1'b0;
            end
            if (!AXI_IF.AWREADY && write_done) begin
                AXI_IF.WREADY <= 1'b1;
            end
        end
    end

    // WDATA and WSTRB latching
    // This block is responsible for capturing WDATA, i.e. latching it in
    // It will capture the address on WDATA when WREADY and WVALID are
    //     both HIGH
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            wdata_latch <= 'b0;
            wstrb_latch <= 'b0;
        end else begin
            if (AXI_IF.WREADY && AXI_IF.WVALID && !write_data_latched) begin
                wdata_latch <= AXI_IF.WDATA;
                wstrb_latch <= AXI_IF.WSTRB;
            end
        end
    end

    // BVALID generation
    // BVALID is LOW by default, because the worker is the source of the
    //     response
    // It will go HIGH when three conditions are met:
    //     a.) WDATA is latched in
    //     b.) AWADDR is latched in
    //     c.) A response has been generated
    // To keep this module (and peripherals) simple, we will use a
    //     hardcoded "OKAY" response - workers will not be able to indicate
    //     an error
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            AXI_IF.BVALID <= 1'b0;
        end else begin
            if (write_user_handshake_done && !AXI_IF.BVALID) begin
                AXI_IF.BVALID <= 1'b1;
            end
            if (AXI_IF.BVALID && AXI_IF.BREADY) begin
                AXI_IF.BVALID <= 1'b0;
            end
        end
    end

    // USER_IF.wr_valid generation
    // USER_IF.wr_valid is LOW by default, because the controller initiates the
    //     handshake with the worker
    // It will go HIGH when two conditions are met:
    //     a.) WDATA is latched in
    //     b.) AWADDR is latched in
    // It will remain HIGH until the worker acknowledges the write by asserting
    //     USER_IF.wr_ready
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            USER_IF.wr_valid <= 1'b0;
        end else begin
            if (write_data_latched && write_address_latched && !USER_IF.wr_valid) begin
                USER_IF.wr_valid <= 1'b1;
            end
            if (USER_IF.wr_valid && USER_IF.wr_ready) begin
                USER_IF.wr_valid <= 1'b0;
            end
        end
    end

    // Write channel control signals
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            write_address_latched <= 1'b0;
            write_data_latched <= 1'b0;
            write_user_handshake_done <= 1'b0;
            write_done <= 1'b0;
        end else begin
            if (AXI_IF.AWREADY && AXI_IF.AWVALID && !write_address_latched) begin
                write_address_latched <= 1'b1;
            end
            if (AXI_IF.WREADY && AXI_IF.WVALID && !write_data_latched) begin
                write_data_latched <= 1'b1;
            end
            if (USER_IF.wr_valid && USER_IF.wr_ready) begin
                write_address_latched <= 1'b0;
                write_data_latched <= 1'b0;
                write_user_handshake_done <= 1'b1;
            end
            if (write_user_handshake_done && AXI_IF.BVALID && AXI_IF.BREADY) begin
                write_user_handshake_done <= 1'b0;
                write_done <= 1'b1;
            end
            // This block will assert write_done for 1 cycle when the AXI reset was LOW last cycle
            //     and high this one. What this does is signal to the READY signals to go HIGH
            //     once we come out of reset.
            if (!reset_latch) begin
                write_done <= 1'b1;
            end
            // write_done is a 1 cycle pulse to signal to the write address
            //     and data channels to get ready again
            if (write_done == 1'b1) begin
                write_done <= 1'b0;
            end
        end        
    end

    assign AXI_IF.BID = awid_latch;
    assign AXI_IF.BRESP = 3'b000;
    assign USER_IF.wr_addr = awaddr_latch;
    assign USER_IF.wr_data = wdata_latch;


    ///////////////////////////////////////////////////////////////////////////
    ////                                                                   ////
    ////                    Read Channel Logic                             ////
    ////                                                                   ////
    ///////////////////////////////////////////////////////////////////////////

    // ARREADY generation
    // ARREADY is asserted HIGH by default to enable single-cycle transfers
    // It will go LOW when ARVALID is HIGH - i.e., when a read addr transfer
    //     is accepted
    // Once LOW, it will remain so until:
    //     a.) A transfer is accepted on the read data/response channel
    // i.e., until the end of the read transaction
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            AXI_IF.ARREADY <= 1'b0;
        end else begin
            if (AXI_IF.ARREADY && AXI_IF.ARVALID && !read_address_latched) begin
                AXI_IF.ARREADY <= 1'b0;
            end
            if (!AXI_IF.ARREADY && read_done) begin
                AXI_IF.ARREADY <= 1'b1;
            end
        end
    end

    // ARADDR latching
    // This block is responsible for capturing ARADDR, i.e. latching it in
    // It will capture the address on ARADDR when ARREADY and ARVALID are
    //     both HIGH
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            araddr_latch <= 'b0;
            arid_latch <= 'b0;
        end else begin
            if (AXI_IF.ARREADY && AXI_IF.ARVALID && !read_address_latched) begin
                araddr_latch <= AXI_IF.ARADDR;
                arid_latch <= AXI_IF.ARID;
            end
        end
    end

    // USER_IF.rd_valid generation
    // USER_IF.rd_valid is asserted HIGH when the read address is latched in
    // It is LOW by default
    // Once HIGH, it will remain so until the handshake with user logic is
    //     complete - i.e., once user logic asserts USER_IF.rd_ready
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            USER_IF.rd_valid <= 1'b0;
        end else begin
            if (!USER_IF.rd_valid && read_address_latched) begin
                USER_IF.rd_valid <= 1'b1;
            end
            if (USER_IF.rd_valid && USER_IF.rd_ready) begin
                USER_IF.rd_valid <= 1'b0;
            end
        end
    end

    // USER_IF.rd_data latching
    // This block is responsible for capturing the user's rd_data, i.e.
    //     latching it in when both rd_valid and rd_ready are HIGH 
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            user_rddata_latch <= 'b0;
        end else begin
            if (USER_IF.rd_valid && USER_IF.rd_ready) begin
                user_rddata_latch <= USER_IF.rd_data;
            end
        end
    end

    // RVALID generation
    // RVALID is LOW by default, because the worker is the source of the
    //     response
    // It will go HIGH when the worker asserts rd_ready, and will remain
    //     so until RREADY goes HIGH
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            AXI_IF.RVALID <= 1'b0;
        end else begin
            if (!AXI_IF.RVALID && read_user_handshake_done) begin
                AXI_IF.RVALID <= 1'b1;
            end
            if (AXI_IF.RREADY && AXI_IF.RVALID) begin
                AXI_IF.RVALID <= 1'b0;
            end
        end
    end    

    // Read channel control signals
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            read_address_latched <= 1'b0;
            read_user_handshake_done <= 1'b0;
            read_done <= 1'b0;
        end else begin
            if (AXI_IF.ARREADY && AXI_IF.ARVALID && !read_address_latched) begin
                read_address_latched <= 1'b1;
            end
            if (USER_IF.rd_valid && USER_IF.rd_ready && read_address_latched) begin
                read_address_latched <= 1'b0;
                read_user_handshake_done <= 1'b1;
            end
            if (read_user_handshake_done && AXI_IF.RVALID && AXI_IF.RREADY) begin
                read_user_handshake_done <= 1'b0;
                read_done <= 1'b1;
            end
            // This block will assert read_done for 1 cycle when the AXI reset was LOW last cycle
            //     and high this one. What this does is signal to the READY signals to go HIGH
            //     when we come out of reset
            if (!reset_latch) begin
                read_done <= 1'b1;
            end
            // read_done is a 1 cycle pulse to signal to the read address
            //     channel to get ready again
            if (read_done) begin
                read_done <= 1'b0;
            end
        end
    end

    assign USER_IF.rd_addr = araddr_latch;
    // To keep this module (and peripherals) simple, we will use a
    //     hardcoded "OKAY" response - workers will not be able to indicate
    //     an error for now
    // TODO: allow workers to generate a response to reads
    assign AXI_IF.RRESP = 3'b000;
    assign AXI_IF.RID = arid_latch;
    assign AXI_IF.RDATA = user_rddata_latch;
endmodule
