module IP_VGA_AsyncRam_Altera #(
    parameter WIDTH = 8,
    parameter DEPTH = 307200,
    parameter MIF = ""
) (
    address_a,
    address_b,
    clock_a,
    clock_b,
    data_a,
    data_b,
    wren_a,
    wren_b,
    q_a,
    q_b
);

localparam ADDRBITS = $clog2(DEPTH);

input   [ADDRBITS-1:0]  address_a;
input   [ADDRBITS-1:0]  address_b;
input                   clock_a;
input                   clock_b;
input   [WIDTH-1:0]     data_a;
input   [WIDTH-1:0]     data_b;
input                   wren_a;
input                   wren_b;
output  [WIDTH-1:0]     q_a;
output  [WIDTH-1:0]     q_b;
tri1	                clock_a;
tri0	                wren_a;
tri0	                wren_b;

wire [WIDTH-1:0] sub_wire0;
wire [WIDTH-1:0] sub_wire1;
wire [WIDTH-1:0] q_a = sub_wire0[WIDTH-1:0];
wire [WIDTH-1:0] q_b = sub_wire1[WIDTH-1:0];

altsyncram	altsyncram_component (
            .address_a (address_a),
            .address_b (address_b),
            .clock0 (clock_a),
            .clock1 (clock_b),
            .data_a (data_a),
            .data_b (data_b),
            .wren_a (wren_a),
            .wren_b (wren_b),
            .q_a (sub_wire0),
            .q_b (sub_wire1),
            .aclr0 (1'b0),
            .aclr1 (1'b0),
            .addressstall_a (1'b0),
            .addressstall_b (1'b0),
            .byteena_a (1'b1),
            .byteena_b (1'b1),
            .clocken0 (1'b1),
            .clocken1 (1'b1),
            .clocken2 (1'b1),
            .clocken3 (1'b1),
            .eccstatus (),
            .rden_a (1'b1),
            .rden_b (1'b1));
defparam
    altsyncram_component.address_reg_b = "CLOCK1",
    altsyncram_component.clock_enable_input_a = "BYPASS",
    altsyncram_component.clock_enable_input_b = "BYPASS",
    altsyncram_component.clock_enable_output_a = "BYPASS",
    altsyncram_component.clock_enable_output_b = "BYPASS",
    altsyncram_component.indata_reg_b = "CLOCK1",
    altsyncram_component.init_file = MIF,
    altsyncram_component.intended_device_family = "Cyclone V",
    altsyncram_component.lpm_type = "altsyncram",
    altsyncram_component.numwords_a = DEPTH,
    altsyncram_component.numwords_b = DEPTH,
    altsyncram_component.operation_mode = "BIDIR_DUAL_PORT",
    altsyncram_component.outdata_aclr_a = "NONE",
    altsyncram_component.outdata_aclr_b = "NONE",
    altsyncram_component.outdata_reg_a = "UNREGISTERED",
    altsyncram_component.outdata_reg_b = "UNREGISTERED",
    altsyncram_component.power_up_uninitialized = "FALSE",
    altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
    altsyncram_component.read_during_write_mode_port_b = "NEW_DATA_NO_NBE_READ",
    altsyncram_component.widthad_a = ADDRBITS,
    altsyncram_component.widthad_b = ADDRBITS,
    altsyncram_component.width_a = WIDTH,
    altsyncram_component.width_b = WIDTH,
    altsyncram_component.width_byteena_a = 1,
    altsyncram_component.width_byteena_b = 1,
    altsyncram_component.wrcontrol_wraddress_reg_b = "CLOCK1";
endmodule //IP_VGA_AsyncRam_Altera