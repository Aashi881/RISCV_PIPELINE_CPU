module reg_file(
    input clk,
    input rst,
    input we,
    input [4:0] rs1, rs2, rd,
    input [31:0] wd,
    output [31:0] rd1, rd2
);

reg [31:0] regm [0:31];
integer i;

/* ---------- READ ---------- */
assign rd1 = (rs1 == 0) ? 32'b0 : regm[rs1];
assign rd2 = (rs2 == 0) ? 32'b0 : regm[rs2];

/* ---------- WRITE / RESET ---------- */
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < 32; i = i + 1)
            regm[i] <= 32'b0;
    end
    else if (we && rd != 0) begin
        regm[rd] <= wd;
    end
end

endmodule
