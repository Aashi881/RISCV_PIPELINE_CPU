`timescale 1ns / 1ps

module riscv_tb;

reg clk;
reg rst;

/* ================= DUT ================= */
riscv_top #(
    .PIPELINE_MODE(5)   // change to 3 for 3-stage test
) dut (
    .clk(clk),
    .rst(rst)
);

/* ================= CLOCK ================= */
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;   // 10 ns clock
end

/* ================= RESET ================= */
initial begin
    rst = 1'b1;
    repeat (4) @(posedge clk);   // hold reset
    rst = 1'b0;
end

/* ================= SIM CONTROL ================= */
initial begin
    // wait until reset is released
    @(negedge rst);

    // run long enough to see hazards
    repeat (30) @(posedge clk);

    $display("Simulation finished");
    $stop;
end

endmodule
