`timescale 1ns/1ps
`include "control_unit_wrapper.v"
`include "data_unit_wrapper_final.v"
`include "hazard_unit.v"
module risc_v_top(
    input clk,
    input reset
);
    // INTERNAL WIRES 
    wire [31:0] InstrD;
    wire [4:0] RsE,RtE,RdE,RdM,RdW;
    wire RegWriteE,RegWriteM,RegWriteW;
    wire [1:0] ResultSrcE;
    wire [4:0] WriteRegE,WriteRegM,WriteRegW;
    wire PCSrcE;

    // Control Signals
    wire BranchD,MemReadD,MemWriteD,ALUSrcD,RegWriteD,JumpD,JALRSrcD;
    wire [1:0] ResultSrcD;
    wire [3:0] ALUControlD;

    // Hazard Signals
    wire StallF,StallD,FlushE,FlushD;
    wire [1:0] ForwardAE,ForwardBE;
    // 1. CONTROL UNIT INSTANTIATION
    control_unit_top CU(
        .opcode(InstrD[6:0]),
        .instr11(InstrD[14:12]),
        .instr12(InstrD[30]),
        .zero_flag(1'b0), 
        .Branch(BranchD),
        .MemRead(MemReadD),
        .MemWrite(MemWriteD),
        .ALUSrc(ALUSrcD),
        .RegWrite(RegWriteD),
        .Jump(JumpD),
        .JALRSrc(JALRSrcD),
        .ResultSrc(ResultSrcD),
        .ALUControl(ALUControlD)
    );
    // 2. HAZARD UNIT INSTANTIATION
    hazard_unit HU(
        .rsD(InstrD[19:15]),
        .rtD(InstrD[24:20]),
        .rsE(RsE),
        .rtE(RtE),
        .WriteRegE(WriteRegE),
        .WriteRegM(WriteRegM),
        .WriteRegW(WriteRegW),
        .RegWriteE(RegWriteE),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE),
        .PCSrcE(PCSrcE),
        .JumpD(JumpD),
        .JALRSrcD(JALRSrcD),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE)
    );
    // 3. PIPELINED DATA UNIT INSTANTIATION
   pipelined_data_unit Datapath(
        .clk(clk),
        .reset(reset),
        .StallF(StallF),
        .StallD(StallD),
        .FlushE(FlushE),
        .FlushD(FlushD),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .BranchD(BranchD),
        .MemReadD(MemReadD),
        .MemWriteD(MemWriteD),
        .ALUSrcD(ALUSrcD),
        .RegWriteD(RegWriteD),
        .JumpD(JumpD),
        .JALRSrcD(JALRSrcD),
        .ResultSrcD(ResultSrcD), 
        .ALUControlD(ALUControlD),
        .InstrD(InstrD),
        .RsE(RsE),
        .RtE(RtE),
        .RdE(RdE),
        .RdM(RdM),
        .RdW(RdW),
        .RegWriteE(RegWriteE),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE),
        .WriteRegE(WriteRegE),
        .WriteRegM(WriteRegM),
        .WriteRegW(WriteRegW),
        .PCSrcE(PCSrcE)
    );

endmodule