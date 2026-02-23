`timescale 1ns/1ps

module reg_file_tb;

    reg clk;
    reg reset;
    reg reg_write_en;

    reg [4:0] read_reg1;
    reg [4:0] read_reg2;
    reg [4:0] write_reg;
    reg [63:0] write_data;

    wire [63:0] read_data1;
    wire [63:0] read_data2;

    // DUT
    reg_file uut(
        .clk(clk),
        .reset(reset),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .reg_write_en(reg_write_en),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock: 10ns period
    initial begin
        clk=0;
        forever #5 clk=~clk;
    end

    initial begin
        // Init
        reset=1;
        reg_write_en=0;
        read_reg1=0;
        read_reg2=0;
        write_reg=0;
        write_data=0;

        // Release reset
        #12 reset=0;

        // Write x1 = 10
        @(posedge clk);
        reg_write_en=1;
        write_reg=5'd1;
        write_data=64'h000000000000000A;

        // Write x2 = -5
        @(posedge clk);
        write_reg=5'd2;
        write_data=64'hFFFFFFFFFFFFFFFB;

        // Attempt write to x0 (ignored)
        @(posedge clk);
        write_reg=5'd0;
        write_data=64'hDEADBEEFDEADBEEF;

        // Stop writes
        @(posedge clk);
        reg_write_en=0;

        // Read back
        read_reg1=5'd1;
        read_reg2=5'd2;
        #2;

        $display("x1=%h (expected 000000000000000A)",read_data1);
        $display("x2=%h (expected FFFFFFFFFFFFFFFB)",read_data2);

        // Let a few cycles pass (cycle_count increments)
        repeat(3) @(posedge clk);

        $display("Simulation done. Check register_file.txt");
        $finish;
    end

endmodule