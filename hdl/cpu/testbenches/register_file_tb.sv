`timescale 1ns/1ns

module Register_File_TB ();
    // With a 1ns timescale, the clock period will be 40ns = 25MHz
    const int half_period = 20;
    const int period = 40;

    // Mimics the interface declaration of the DUT
    logic clock;
    logic reset_n;

    // Inputs to the DUT
    logic [4:0] rX_sel;
    logic [4:0] rY_sel;
    logic [4:0] rWrite_sel;
    logic write_reg_enable;
    logic [31:0] write_data;

    // Outputs from the DUT
    logic [31:0] rX_data_out;
    logic [31:0] rY_data_out;

    // Testbench control variables
    int reg_num;
    int expected;
    // This value will be multiplied by each register's one-indexed number and
    //     written to it.
    const int write_const = 15;
    const int NUM_REGS = 32;
    // This variable gets initialized to 1 in the initial block. If any part of
    //     the test fails it will be set to 0.
    logic PASS;

    // This testbench executes 3 phases:
    // 1. On each clock, write to each register and read from the previous one
    // 2. Read the value in each register to make sure they persisted
    // 3. Check pass/fail status
    enum logic [1:0] {
        PHASE_WRITE_ALL,
        PHASE_READ_ALL,
        PHASE_DONE
    } phase;

    // Instantiate the DUT
    Register_File dut (
        .clock(clock),
        .reset_n(reset_n),
        .rX_sel(rX_sel),
        .rY_sel(rY_sel),
        .rWrite_sel(rWrite_sel),
        .write_reg_enable(write_reg_enable),
        .write_data(write_data),
        .rX_data_out(rX_data_out),
        .rY_data_out(rY_data_out)
    );

    // Create the clock
    always begin
        clock = 1'b1;
        #half_period;

        clock = 1'b0;
        #half_period;
    end

    // Reset the DUT, print a welcome message, and instantiate the appropriate
    //     variables.
    initial begin
        $display("Register_File    :    Hello! This is the register file testbench");
        PASS = 1'b1;
        reg_num = 0;
        phase = PHASE_WRITE_ALL;
        expected = 0;
        rX_sel = 'b0;
        rY_sel = 'b0;
        rWrite_sel = 'b0;
        write_reg_enable = 'b0;
        write_data = 'b0;
        reset_n = 1'b0;
        #period;
        reset_n = 1'b1;
    end

    always @(posedge clock) begin
        if (phase == PHASE_DONE) begin
            if (PASS == 1'b1) begin
                $display("Register_File    :    Testbench passed!");
            end else begin
                $display("Register_File    :    Testbench failed :(");
            end
            $display("Goodbye!");
            $stop;
        end

        if (phase == PHASE_WRITE_ALL && reg_num < NUM_REGS) begin
            rWrite_sel = reg_num;
            write_reg_enable = 1'b1;
            write_data = (reg_num + 1) * write_const;
            $display("Register_File    :    Writing value %0d to register %0d", write_data, rWrite_sel);
        end

        if (reg_num > 0) begin
            rX_sel = reg_num - 1;
            rY_sel = reg_num - 1;
            // Before this delay we're still right at the clock edge, so we
            //     need a short delay for our write values to actually get
            //     clocked in
            #1;
            // Even though we wrote a value of 15 to r0, we need to set our
            //     expected value to 0 for it - it should always read 0
            expected = (reg_num - 1 == 0) ? 0 : reg_num * write_const;
            if (rX_data_out != expected || rY_data_out != expected) begin
                PASS = 1'b0;
                $display("Register_File    :    FAIL     :    Read from register %0d. rX = %0d rY = %0d expected = %0d", reg_num - 1, rX_data_out, rY_data_out, expected);
            end else begin
                $display("Register_File    :    PASS     :    Read from register %0d. rX = %0d rY = %0d expected = %0d", reg_num - 1, rX_data_out, rY_data_out, expected);
            end
        end

        if (reg_num == NUM_REGS) begin
            if (phase == PHASE_WRITE_ALL) begin
                phase = PHASE_READ_ALL;
                reg_num = 0;
            end else begin
                phase = PHASE_DONE;
            end
        end

        reg_num++;
    end
endmodule
