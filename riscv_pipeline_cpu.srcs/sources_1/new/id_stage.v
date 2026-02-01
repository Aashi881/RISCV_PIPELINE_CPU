module id_stage(
    input  wire [31:0] instr,

    // from previous stage (EX)
    input  wire        ex_mem_read,   // previous instruction is LOAD
    input  wire [4:0]  ex_rd,          // destination register of previous instr

    // outputs
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [4:0]  rd,
    output wire        stall           // hazard stall signal
);

    /* ================= REGISTER DECODE ================= */
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd  = instr[11:7];

    /* ================= OPCODE DECODE ================= */
    wire [6:0] opcode;
    assign opcode = instr[6:0];

    // RISC-V LOAD opcode = 0000011
    wire is_load;
    assign is_load = (opcode == 7'b0000011);

    /* ================= LOAD-USE HAZARD DETECTION ================= */
    assign stall =
        ex_mem_read &&                   // previous instr is load
        (ex_rd != 0) &&                   // valid destination
        ((ex_rd == rs1) || (ex_rd == rs2));

endmodule
