`timescale 1ns/1ps
`define IMEM_SIZE 4096 
module instruction_mem(
    input [63:0] addr,
    output reg [31:0] instr
);
    integer i;
    reg [7:0] mem [0:`IMEM_SIZE-1]; 
    initial begin
        // Load instructions from file into memory
        $readmemh("instructions.txt", mem);
    end
    always @(*) begin
        mem[i] = 8'h00;
            // Big-Endian Implementation: 
            instr[31:24] = mem[addr];     // Byte 1 (MSB)
            instr[23:16] = mem[addr+1];   // Byte 2
            instr[15:8]  = mem[addr+2];   // Byte 3
            instr[7:0]   = mem[addr+3];   // Byte 4 (LSB)
        end
endmodule