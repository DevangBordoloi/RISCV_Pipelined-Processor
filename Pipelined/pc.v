`timescale 1ns / 1ps
module program_counter(
    input clk,
    input reset,
    input StallF,
    input [63:0] pc_in,
    output reg [63:0] pc_out
);
    always @(posedge clk) begin
        if (reset)
            pc_out <= 64'b0;
        else if (!StallF)
            pc_out <= pc_in;
    end
endmodule