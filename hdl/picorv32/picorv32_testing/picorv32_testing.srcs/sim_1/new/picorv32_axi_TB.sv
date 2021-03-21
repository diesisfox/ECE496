`timescale 1ns / 1ps

module picorv32_axi_TB(

);
    
    localparam PERIOD = 100;
    localparam HALF_PERIOD = 50;

    logic clock, reset_n, trap;
    AXI5_Lite_IF AXI_IF ();
    Simple_Worker_Mem_IF MEM_IF ();
    
    assign AXI_IF.ACLK = clock;
    assign AXI_IF.ARESETn = reset_n;
    
    picorv32_axi #(
        .ENABLE_COUNTERS(0),
        .ENABLE_COUNTERS64(0),
        .ENABLE_REGS_16_31(1),
        .ENABLE_REGS_DUALPORT(1),
        .TWO_STAGE_SHIFT(1),
        .BARREL_SHIFTER(0),
        .TWO_CYCLE_COMPARE(0),
        .TWO_CYCLE_ALU(0),
        .COMPRESSED_ISA(0),
        .CATCH_MISALIGN(1),
        .CATCH_ILLINSN(1),
        .ENABLE_PCPI(0),
        .ENABLE_MUL(0),
        .ENABLE_FAST_MUL(0),
        .ENABLE_DIV(),
        .ENABLE_IRQ(0),
        .ENABLE_IRQ_QREGS(0),
        .ENABLE_IRQ_TIMER(0),
        .ENABLE_TRACE(0),
        .REGS_INIT_ZERO(1),
        .MASKED_IRQ(32'hFFFF_FFFF),
        .LATCHED_IRQ(32'h0000_0000),
        .PROGADDR_RESET(32'h0000_0000),
        .PROGADDR_IRQ(32'h0000_0000),
        .STACKADDR(32'hFFFF_FFFF)
    ) CPU (
        .AXI_IF(AXI_IF.MANAGER),
        .trap(trap)
    );
    
    AXI_Controller_Worker mem_axi_controller (
        .AXI_IF(AXI_IF.WORKER),
        .USER_IF(MEM_IF.CONTROLLER)
    );
    
    Dummy_Memory Mem (
        .mem_if(MEM_IF.WORKER)
    );
    
    always begin
        clock = 1'b0;
        #HALF_PERIOD;
        clock = 1'b1;
        #HALF_PERIOD;
    end
    
    initial begin
        reset_n = 1'b0;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        reset_n = 1'b1;
        $readmemb("/media/storage-windows/ECE496-repo/hdl/picorv32/test_program.txt", Mem.mem);
        #PERIOD;
    end
    
    always @(posedge clock) begin
        if (trap) begin
            $finish;
        end
    end

endmodule