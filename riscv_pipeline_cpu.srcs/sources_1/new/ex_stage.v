module ex_stage(
    input  wire [31:0] a,          // from reg file
    input  wire [31:0] b,          // from reg file

    // forwarding inputs
    input  wire [31:0] mem_fwd,    // from MEM stage
    input  wire [31:0] wb_fwd,     // from WB stage
    input  wire [1:0]  forwardA,
    input  wire [1:0]  forwardB,

    // control
    input  wire        is_load,    // instruction is LOAD
    input  wire [4:0]  rd_in,      // destination reg

    // outputs
    output wire [31:0] alu_out,
    output wire        mem_read,   // to ID stage
    output wire [4:0]  rd_ex       // to ID stage
);

    /* ================= FORWARDED OPERANDS ================= */
    reg [31:0] alu_a, alu_b;

    always @(*) begin
        case (forwardA)
            2'b00: alu_a = a;        // no forwarding
            2'b01: alu_a = wb_fwd;   // WB ? EX
            2'b10: alu_a = mem_fwd;  // MEM ? EX
            default: alu_a = a;
        endcase

        case (forwardB)
            2'b00: alu_b = b;
            2'b01: alu_b = wb_fwd;
            2'b10: alu_b = mem_fwd;
            default: alu_b = b;
        endcase
    end

    /* ================= ALU ================= */
    alu A1 (
        .a(alu_a),
        .b(alu_b),
        .alu_ctrl(3'b000),   // ADD for now
        .y(alu_out)
    );

    /* ================= HAZARD INFO ================= */
    assign mem_read = is_load;   // used for load-use hazard
    assign rd_ex    = rd_in;

endmodule
