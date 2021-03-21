module Dummy_Memory (
    Simple_Worker_Mem_IF.WORKER mem_if
);

    logic [31:0] mem [63:0];

    // wr_ready generation
    always_ff @(posedge mem_if.clock) begin
        if (mem_if.reset_n == 1'b0) begin
            mem_if.wr_ready <= 1'b1;
        end else begin
            if (mem_if.wr_valid && mem_if.wr_ready) begin
                mem_if.wr_ready <= 1'b0;
            end
            if (!mem_if.wr_ready && !mem_if.wr_valid) begin
                mem_if.wr_ready <= 1'b1;
            end
        end
    end
    
    // Writing incoming data into mem
    always_ff @(posedge mem_if.clock) begin
        if (mem_if.reset_n == 1'b0) begin
            mem <= '{64{'0}};
        end else begin
            if (mem_if.wr_valid && mem_if.wr_ready) begin
                mem[mem_if.wr_addr[7:2]] <= mem_if.wr_data;
            end
        end
    end
    
    // rd_ready generation
    always_ff @(posedge mem_if.clock) begin
        if (mem_if.reset_n == 1'b0) begin
            mem_if.rd_ready <= 1'b1;
        end else begin
            if (mem_if.rd_valid && mem_if.rd_ready) begin
                mem_if.rd_ready <= 1'b0;
            end
            if (!mem_if.rd_valid && !mem_if.rd_ready) begin
                mem_if.rd_ready <= 1'b1;    
            end
            
        end
    end
    
    always_comb begin
        mem_if.rd_data = mem[mem_if.rd_addr[7:2]];
    end
    

endmodule