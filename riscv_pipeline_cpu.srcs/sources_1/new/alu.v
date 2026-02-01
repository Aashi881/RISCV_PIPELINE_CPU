module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [2:0] alu_ctrl,
    output reg [31:0] y
);
always @(*) begin
    case (alu_ctrl)
        3'b000: y = a + b;
        3'b001: y = a - b;
        3'b010: y = a & b;
        3'b011: y = a | b;
        default: y = 0;
    endcase
end
endmodule