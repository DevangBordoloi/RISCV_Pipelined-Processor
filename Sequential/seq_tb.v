`timescale 1ns/1ps
`include "seq_processor.v"
module seq_tb;
    reg clk;
    reg reset;
    seq_processor_top uut (
        .clk(clk),
        .reset(reset)
    );
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    // Reset
    initial begin
        reset = 1;
        #11 reset = 0;
    end
    initial begin
        $dumpfile("seq_tb.vcd");
        $dumpvars(0, seq_tb);
        // Wait dynamically until the instruction becomes unknown (x)
        wait (!reset && (uut.instruction === 32'hxxxxxxxx || uut.instruction === 32'h00000000));
        // Allow one more clock cycle for the final write-back stage to finish and safely print to register_file.txt
        @(posedge clk);
        #1;
        $finish;
    end

endmodule