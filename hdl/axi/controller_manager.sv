module AXI_Controller_Manager (
    Simple_Manager_Mem_IF.CONTROLLER USER_IF,
    AXI5_Lite_IF.MANAGER AXI_IF
);
    
    // Control signals for write datapath
    logic user_wr_data_addr_latched;
    logic axi_aw_done;
    logic axi_w_done;
    logic axi_data_transferred;
    logic write_done;
    
    // Control signals for read datapath
    logic user_rd_addr_latched;
    logic axi_rresp_done;
    
    // Buffers for incoming/outgoing data
    logic [31:0] user_waddr_latch;
    logic [31:0] user_wdata_latch;

    logic [31:0] user_rdaddr_latch;
    logic [31:0] axi_rdata_latch;

    // Reg used for bringing up user-facing ready signals after reset
    logic reset_latch;
    always @(posedge AXI_IF.ACLK) begin
        reset_latch <= AXI_IF.ARESETn;
    end

    ///////////////////////////////////////////////////////////////////////////
    ////                                                                   ////
    ////                    Write Channel Logic                            ////
    ////                                                                   ////
    ///////////////////////////////////////////////////////////////////////////
    
    // Write transaction:
    // 1. Keep wr_ready HIGH
    // 2. When wr_valid goes HIGH:
    //        a. Latch in write address
    //        b. Latch in write data
    //        c. Set wr_ready to LOW
    // 3. Handshake data out over AXI:
    //        a. Handshake write address over AW channel
    //        b. Handshake write data over W channel
    //        c. Set BREADY to HIGH
    // 4. Wait for AXI worker to assert BVALID, then:
    //        a. Set BREADY to LOW
    //        b. Set wr_ready on user bus back to HIGH
    // Note: wr_ready on user bus, and all ready/valid signals on AXI bus,
    //     should be LOW when in RESET!

    // User IF wr_ready generation
    // wr_ready is asserted HIGH by default to enable single-cycle transfers
    //     from the user logic to this module.
    // It will go LOW when wr_valid is HIGH - i.e., when a write transaction
    //     from the user is accepted
    // Once LOW, it will remain so until the write transaction is completed
    //     on the AXI bus - its completion is signalled with the "write_done"
    //     signal.
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            USER_IF.wr_ready <= 1'b0;
        end else begin
            if (USER_IF.wr_valid && USER_IF.wr_ready) begin
                USER_IF.wr_ready <= 1'b0;
            end
            if (!USER_IF.wr_ready && write_done) begin
                USER_IF.wr_ready <= 1'b1;
            end
        end
    end
    
    // User write data and address latching
    // This block is responsible for capturing the user's wr addr
    //     and wr data, i.e. latching them in.
    // It will capture the address and data on the user IF when
    //     wr_valid and wr_ready are both HIGH.
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            user_waddr_latch <= 'b0;
            user_wdata_latch <= 'b0;
        end else begin
            if (USER_IF.wr_valid && USER_IF.wr_ready) begin
                user_waddr_latch <= USER_IF.wr_addr;
                user_wdata_latch <= USER_IF.wr_data;
            end
        end
    end
    
    // AXI interface AWVALID generation
    // AWVALID
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            AXI_IF.AWVALID <= 1'b0;
        end else begin
            if (user_wr_data_addr_latched && !AXI_IF.AWVALID) begin
                AXI_IF.AWVALID <= 1'b1;
            end
            if (AXI_IF.AWVALID && AXI_IF.AW_READY) begin
                AXI_IF.AWVALID <= 1'b0;
            end
        end
    end
    
    // AXI interface WVALID generation
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            AXI_IF.WVALID <= 1'b0;
        end else begin
            if (user_wr_data_addr_latched && !AXI_IF.WVALID) begin
                AXI_IF.WVALID <= 1'b1;
            end
            if (AXI_IF.WVALID && AXI_IF.W_READY) begin
                AXI_IF.WVALID <= 1'b0;
            end
        end
    end
    
    // AXI interface BREADY generation
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            AXI_IF.BREADY <= 1'b0
        end else begin
            if (axi_data_transferred && !AXI_IF.BREADY) begin
                AXI_IF.BREADY <= 1'b1;
            end
            if (AXI_IF.BVALID && AXI_IF.BREADY) begin
                AXI_IF.BREADY <= 1'b0;
            end
        end
    end
    
    // Write channel control signal generation
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            user_wr_data_addr_latched <= 1'b0;
            axi_aw_done <= 1'b0;
            axi_w_done <= 1'b0;
            write_done <= 1'b0;
        end else begin
            if (USER_IF.wr_ready && USER_IF.wr_valid) begin
                user_wr_data_addr_latched <= 1'b1;
            end
            if (AXI_IF.AW_READY && AXI_IF.AWVALID) begin
                axi_aw_done <= 1'b1;
            end
            if (AXI_IF.W_READY && AXI_IF.WVALID) begin
                axi_w_done <= 1'b1;
            end
            if (AXI_IF.BREADY && AXI_IF.BVALID) begin
                user_wr_data_addr_latched <= 1'b0;
                axi_aw_done <= 1'b0;
                axi_w_done <= 1'b0;
                write_done <= 1'b1;
            end
            if (!reset_latch) begin
                write_done <= 1'b1;
            end
            // write_done is a 1 cycle pulse to signal to the user IF's
            //     write channel to get ready again
            if (write_done == 1'b1) begin
                write_done <= 1'b0;
            end
        end
    end
    
    // Combinational logic for write channels
    always_comb begin
        // Control signals
        axi_data_transferred = axi_aw_done & axi_w_done;
    
        // Tie off AXI write address channel signals
        AXI_IF.AWID = 1'b0;
        AXI_IF.AWSIZE = 3'b010;
        AXI_IF.AWPROT = 3'b000;
        
        // Tie off AXI write data channel signals
        AXI_IF.WSTRB = 4'b1111;
        
        // Connect user data latches to the AXI bus
        AXI_IF.AWADDR = user_waddr_latch;
        AXI_IF.WDATA = user_wdata_latch;
    end


    ///////////////////////////////////////////////////////////////////////////
    ////                                                                   ////
    ////                    Read Channel Logic                             ////
    ////                                                                   ////
    ///////////////////////////////////////////////////////////////////////////
    
    // Read transaction procedure:
    // 1. Wait for user logic to assert rd_valid
    // 2. Once user logic asserts rd_valid, latch in rd_addr
    // 3. Handshake read addr channel on AXI
    // 4. Handshake read response channel on AXI
    // 5. Present rd data to user logic and assert rd_ready until it
    //        deasserts rd_valid
    
    // rd_ready generation
    // rd_ready is LOW by default - it only goes HIGH at the end of a read
    //     transaction, after the following has occurred:
    //     1. rd_valid asserted by user and address transferred
    //     2. rd data fetched over AXI bus
    //     3. rd_valid is deasserted by user logic, and rd data transferred to
    //            user
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            USER_IF.rd_ready <= 1'b0;
        end else begin
            if (axi_rresp_done && !USER_IF.rd_ready) begin
                rd_ready <= 1'b1;
            end
            if (USER_IF.rd_ready && !USER_IF.rd_valid) begin
                rd_ready <= 1'b0;
            end
        end
    end

    // User rd addr latching
    // The read address is latched in when the user asserts rd_valid
    // To keep the interface simple, it means that the rd addr will get latched
    //     in every cycle during a read transaction, while user logic holds
    //     rd_valid HIGH
    // This should be fine, as long as user logic does not change the addr
    //     and expect to get different data
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            user_rdaddr_latch <= 'b0;
        end else begin
            if (USER_IF.rd_valid) begin
                user_rdaddr_latch <= USER_IF.rd_addr;
            end
        end
    end

    // ARVALID generation
    // ARVALID is held LOW by default, and goes HIGH one cycle after
    //     the user asserts rd_valid
    // It will remain HIGH until ARREADY is asserted, indicating a successful
    //     transfer to the AXI worker
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            AXI_IF.ARVALID <= 1'b0;
        end else begin
            if (user_rd_addr_latched && !AXI_IF.ARVALID) begin
                AXI_IF.ARVALID <= 1'b1;
            end
            if (AXI_IF.ARVALID && AXI_IF.ARREADY) begin
                AXI_IF.ARVALID <= 1'b0;
            end
        end
    end

    // RREADY generation
    // RREADY is held LOW by default, and goes HIGH at the same time as ARVALID
    // By asserting RREADY at the same time as initiating the AR handshake,
    //     we can speed up transfers by one cycle
    // It will remain HIGH until RVALID is asserted and the read data latched in
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            AXI_IF.RREADY <= 1'b0;
        end else begin
            if (user_rd_addr_latched && !AXI_IF.RREADY) begin
                AXI_IF.RREADY <= 1'b1;
            end
            if (AXI_IF.RREADY && AXI_IF.RVALID) begin
                AXI_IF.RREADY <= 1'b0;
            end
        end
    end

    // AXI read data latching
    // This block is responsible for capturing read data on the AXI bus,
    //     i.e. latching it in when RREADY and RVALID are both HIGH
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            axi_rdata_latch <= 'b0;
        end else begin
            if (AXI_IF.RREADY && AXI_IF.RVALID) begin
                axi_rdata_latch <= AXI_IF.RDATA;
            end
        end
    end

    // Control signal generation
    always_ff @(posedge AXI_IF.ACLK) begin
        if (AXI_IF.ARESETn == 1'b0) begin
            user_rd_addr_latched <= 1'b0;
            axi_rresp_done <= 1'b0;
        end else begin
            if (USER_IF.rd_valid) begin
                user_rd_addr_latched <= 1'b1;
            end
            if (AXI_IF.RREADY && AXI_IF.RVALID) begin
                user_rd_addr_latched <= 1'b0;
                axi_rresp_done <= 1'b1;
            end
            if (axi_rresp_done == 1'b1) begin
                axi_rresp_done <= 1'b0;
            end
        end
    end

    // Combinational logic for read channels
    always_comb begin        
        // Tie off AXI read address channel signals
        ARPROT = 3'b000;
        ARSIZE = 3'b010;
        ARID = 1'b0;

        // Connect rd addr and data latches
        AXI_IF.ARADDR = user_rdaddr_latch;
        USER_IF.rd_data = axi_rdata_latch;
    end
