module mem_stage(
    input  wire        clk,

    input  wire [31:0] alu_in,      // address or ALU result
    input  wire        mem_read,    // LOAD instruction

    output wire [31:0] mem_out,     // data to WB
    output wire [31:0] mem_fwd      // MEM ? EX forwarding
);

    reg [31:0] data_mem [0:255];

    /* ================= DATA MEMORY INIT ================= */
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            data_mem[i] = i;   // dummy data for testing
    end

    /* ================= MEMORY READ ================= */
    wire [31:0] load_data;
    assign load_data = data_mem[(alu_in >> 2) & 8'hFF];

    /* ================= OUTPUT SELECT ================= */
    assign mem_out = (mem_read) ? load_data : alu_in;

    /* ================= FORWARDING SOURCE ================= */
    assign mem_fwd = mem_out;   // forwarded to EX stage

endmodule
