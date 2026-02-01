module if_stage (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,   // NEW: hazard stall
    input  wire        flush,   // NEW: branch flush
    output reg  [31:0] pc,
    output wire [31:0] instr
);

    reg [31:0] instr_mem [0:255];
    integer i;

    /* ================= INSTRUCTION MEMORY INIT ================= */
    initial begin
        for (i = 0; i < 256; i = i + 1)
            instr_mem[i] = 32'h00000013; // NOP

        $readmemh(
            "D:/Vivado_Projects/riscv_pipeline_cpu/riscv_pipeline_cpu.sim/sim_1/behav/xsim/program.hex",
            instr_mem
        );

        // DEBUG
        $display("INSTR_MEM[0] = %h", instr_mem[0]);
        $display("INSTR_MEM[1] = %h", instr_mem[1]);
        $display("INSTR_MEM[2] = %h", instr_mem[2]);
    end

    /* ================= PC UPDATE LOGIC ================= */
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'd0;
        else if (stall)
            pc <= pc;          // HOLD PC (STALL)
        else
            pc <= pc + 4;      // NORMAL FLOW
    end

    /* ================= INSTRUCTION FETCH ================= */
    assign instr = (flush) 
                    ? 32'h00000013              // INSERT NOP ON FLUSH
                    : instr_mem[(pc >> 2) & 8'hFF];

endmodule
