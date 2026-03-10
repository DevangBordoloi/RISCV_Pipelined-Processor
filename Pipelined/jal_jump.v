`timescale 1ns / 1ps
module jump_control (
    input [6:0] opcode,
    output Jump,
    output JALRSrc   // high only for JALR: target = rs1+imm (not PC+imm)
);
    // RISC-V JAL opcode  = 7'b1101111
    // RISC-V JALR opcode = 7'b1100111
    assign Jump    = (opcode == 7'b1101111) || (opcode == 7'b1100111);
    assign JALRSrc = (opcode == 7'b1100111);
    
endmodule