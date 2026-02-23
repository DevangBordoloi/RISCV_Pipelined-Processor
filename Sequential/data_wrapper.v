`timescale 1ns / 1ps
`include "pc.v"
`include "reg_file.v"
`include "ig.v"
`include "instruction_mem.v"
`include "data_mem.v"
`include "alu.v"
//Data Unit
   module data_module(
    input clk,
    input reset,
    input pc_src, 
    input ALUSrc, 
    input MemtoReg, 
    input RegWrite, 
    input MemWrite,
    input MemRead,
    input [3:0] ALUControl,
    output [31:0] instruction,
    output zero_flag
);
    wire [63:0] current_pc;
    wire [63:0] next_pc;
    wire [63:0] pc_plus_4;
    wire [63:0] branch_target;
    wire [63:0] imm_gen_1;
    wire [63:0] write_data; 
    wire [63:0] read_data1;
    wire [63:0] read_data2;
    wire [63:0] read_data_mem;
    wire [63:0] alu_result; 
    wire [63:0] imm_data;            
  
    // 1. Program Counter
    program_counter pc_inst (
        .clk(clk),
        .reset(reset),
        .pc_in(next_pc),
        .pc_out(current_pc)
    );
    //Shift Left Logic for Branch Target
    sll_64 sll_inst (
        .din(imm_data),
        .val(6'b000001),     // Shift left by 1
        .dout(imm_gen_1)
    );
    assign pc_plus_4 = current_pc + 64'd4;
    assign branch_target = current_pc + imm_gen_1;
    //Mux to select next PC
    mux2_64 mux1_inst (
        .sel(pc_src),
        .i0(pc_plus_4),
        .i1(branch_target),
        .out(next_pc)
    );
    //2.Instruction Memory
    instruction_mem imem_inst (
        .addr(current_pc), 
        .instr(instruction)
    );
    //3.Immediate Generator
    ig imm_inst(
        .instr(instruction),
        .imm_data(imm_data)
    );
    //4.Register File
    reg_file regfile_inst(
        .clk(clk),
        .reset(reset),
        .read_reg1(instruction[19:15]), // rs1
        .read_reg2(instruction[24:20]), // rs2
        .write_reg(instruction[11:07]),
        .write_data(write_data),   
        .reg_write_en(RegWrite),  
        .read_data1(read_data1), 
        .read_data2(read_data2)  
    );
    //5.ALU
    // Wire to hold the second operand for the ALU
    wire [63:0] alu_operand_b;

    // ALU Source Multiplexer (Selects between Register Data 2 and Immediate Data)
    mux2_64 alu_mux_inst (
        .sel(ALUSrc),
        .i0(read_data2),    // 0: Use register read data
        .i1(imm_data),      // 1: Use sign-extended immediate
        .out(alu_operand_b)
    );

    alu_64_bit alu_inst (
        .a(read_data1),           // Operand 1
        .b(alu_operand_b),        // Operand 2 (from the Mux)
        .opcode(ALUControl),
        .cout(cout),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag),
        .result(alu_result),      // Main math output
        .zero_flag(zero_flag)          // Zero flag for branching
    );
    //6.Data Memory
    data_mem dmem_inst(
        .clk(clk),
        .reset(reset),
        .address(alu_result), 
        .write_data(read_data2),      
        .MemWrite(MemWrite),         
        .MemRead(MemRead),          
        .read_data(read_data_mem)      
    );
mux2_64 mux2_inst (
        .sel(MemtoReg), 
        .i0(alu_result),
        .i1(read_data_mem),
        .out(write_data)
    );
endmodule