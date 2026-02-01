module wb_stage(
    input  wire [31:0] in_data,
    output wire [31:0] wb_data,
    output wire [31:0] wb_fwd      // WB ? EX forwarding
);

    assign wb_data = in_data;
    assign wb_fwd  = in_data;

endmodule
