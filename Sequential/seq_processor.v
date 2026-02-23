`timescale 1ns / 1ps
`include "control_unit_wrapper.v"
`include "data_wrapper.v"

module seq_processor_top (input clk,reset);
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, pc_src;
    wire [3:0] ALUControl;
    wire [31:0] instruction;
    wire zero_flag;
   //data unit
    data_module DU (
        .clk(clk),
        .reset(reset),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .pc_src(pc_src),
        .instruction(instruction),
        .zero_flag(zero_flag)
    );
    //control unit
    control_unit_top CU (
        .opcode(instruction[6:0]),
        .instr11(instruction[14:12]), 
        .instr12(instruction[30]),    
        .zero_flag(zero_flag),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .pc_src(pc_src),              
        .ALUControl(ALUControl)
    );
endmodule