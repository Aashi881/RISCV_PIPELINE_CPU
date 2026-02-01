module riscv_top #(
    parameter PIPELINE_MODE = 3  // 3 or 5
)(
    input clk,
    input rst
);

/* ================= COMMON WIRES ================= */
wire [31:0] pc, instr;
wire [31:0] rdata1, rdata2;
wire [31:0] alu_out_ex;
wire [31:0] mem_out;
wire [31:0] wb_data;

wire [31:0] mem_fwd;
wire [31:0] wb_fwd;

wire [4:0] rs1, rs2, rd;
wire [4:0] rd_ex;

/* ================= HAZARD SIGNALS ================= */
wire stall;
wire flush;
wire mem_read;
wire [1:0] forwardA, forwardB;

/* ================= IF STAGE ================= */
if_stage IF (
    .clk   (clk),
    .rst   (rst),
    .stall (stall),
    .flush (flush),
    .pc    (pc),
    .instr (instr)
);

generate

/* ================================================= */
/* ===================== 3 STAGE =================== */
/* ================================================= */
if (PIPELINE_MODE == 3) begin

    /* ---------- DECODE ---------- */
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd  = instr[11:7];

    /* ---------- REGISTER FILE ---------- */
    reg_file RF (
        .clk (clk),
        .rst (rst),
        .we  (1'b1),
        .rs1 (rs1),
        .rs2 (rs2),
        .rd  (rd),
        .wd  (wb_data),
        .rd1 (rdata1),
        .rd2 (rdata2)
    );

    /* ---------- EXECUTE ---------- */
    ex_stage EX (
        .a        (rdata1),
        .b        (rdata2),
        .mem_fwd  (32'b0),
        .wb_fwd   (32'b0),
        .forwardA (2'b00),
        .forwardB (2'b00),
        .is_load  (1'b0),
        .rd_in    (rd),
        .alu_out  (alu_out_ex),
        .mem_read (),
        .rd_ex    ()
    );

    /* ---------- WRITE BACK ---------- */
    wb_stage WB (
        .in_data (alu_out_ex),
        .wb_data (wb_data),
        .wb_fwd  ()
    );

    /* ---------- NO HAZARDS ---------- */
    assign stall = 1'b0;
    assign flush = 1'b0;

end

/* ================================================= */
/* ===================== 5 STAGE =================== */
/* ================================================= */
else begin

    /* ---------- ID STAGE (Hazard Detect) ---------- */
    id_stage ID (
        .instr       (instr),
        .ex_mem_read (mem_read),
        .ex_rd       (rd_ex),
        .rs1         (rs1),
        .rs2         (rs2),
        .rd          (rd),
        .stall       (stall)
    );

    /* ---------- REGISTER FILE ---------- */
    reg_file RF (
        .clk (clk),
        .rst (rst),
        .we  (1'b1),
        .rs1 (rs1),
        .rs2 (rs2),
        .rd  (rd),
        .wd  (wb_data),
        .rd1 (rdata1),
        .rd2 (rdata2)
    );

    /* ---------- FORWARDING LOGIC ---------- */
    assign forwardA =
        (rd_ex != 0 && rd_ex == rs1) ? 2'b10 : 2'b00;

    assign forwardB =
        (rd_ex != 0 && rd_ex == rs2) ? 2'b10 : 2'b00;

    /* ---------- EX STAGE ---------- */
    ex_stage EX (
        .a        (rdata1),
        .b        (rdata2),
        .mem_fwd  (mem_fwd),
        .wb_fwd   (wb_fwd),
        .forwardA (forwardA),
        .forwardB (forwardB),
        .is_load  (instr[6:0] == 7'b0000011), // REAL load decode
        .rd_in    (rd),
        .alu_out  (alu_out_ex),
        .mem_read (mem_read),
        .rd_ex    (rd_ex)
    );

    /* ---------- MEM STAGE ---------- */
    mem_stage MEM (
        .clk      (clk),
        .alu_in   (alu_out_ex),
        .mem_read (mem_read),
        .mem_out  (mem_out),
        .mem_fwd  (mem_fwd)
    );

    /* ---------- WB STAGE ---------- */
    wb_stage WB (
        .in_data (mem_out),
        .wb_data (wb_data),
        .wb_fwd  (wb_fwd)
    );

    /* ---------- NO BRANCH FLUSH YET ---------- */
    assign flush = 1'b0;

end

endgenerate

endmodule
