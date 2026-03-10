`timescale 1ns / 1ps
`include "pc.v"
`include "reg_file.v"
`include "ig.v"
`include "instruction_mem.v"
`include "data_mem.v"
`include "alu.v"
`include "if_id.v"
`include "id_ex.v"
`include "ex_mem.v"
`include "mem_wb.v"
//Data Unit
module pipelined_data_unit(
    input clk,reset,
    input StallF,StallD,FlushE,FlushD,
    input[1:0]ForwardAE,ForwardBE,
    input BranchD,MemReadD,MemWriteD,ALUSrcD,RegWriteD,JumpD,JALRSrcD,
    input[1:0]ResultSrcD,
    input[3:0]ALUControlD,
    output[31:0]InstrD,
    output[4:0]RsE,RtE,RdE,RdM,RdW,
    output RegWriteE,RegWriteM,RegWriteW,
    output[1:0]ResultSrcE,
    output[4:0]WriteRegE,WriteRegM,WriteRegW,
    output PCSrcE
);

    assign WriteRegE=RdE;
    assign WriteRegM=RdM;
    assign WriteRegW=RdW;
    // STAGE IF: Instruction Fetch
    wire[63:0]PCF_prime,PCF,PCPlus4F,PCTargetE;
    wire[31:0]InstrF;
    mux2_64 mux_next_pc(.i0(PCPlus4F),.i1(PCTargetE),.sel(PCSrcE),.out(PCF_prime));
    program_counter PC_reg(.clk(clk),.reset(reset),.StallF(StallF),.pc_in(PCF_prime),.pc_out(PCF));
    wire carry_out,ovf_out; 
    adder_64 pc_incrementer(.a(PCF),.b(64'd4),.sum(PCPlus4F),.carry(carry_out),.overflow(ovf_out));
    instruction_mem IMEM(.addr(PCF),.instr(InstrF));
    // IF/ID PIPELINE REGISTER
    wire[63:0]PCD,PCPlus4D;
    if_id IFID_Reg(
        .clk(clk),.reset(reset),.flush(FlushD),.IF_ID_write(!StallD),
        .IF_ID_pc_in(PCPlus4F),.IF_ID_instr_in(InstrF),.PCF(PCF),
        .IF_ID_pc_out(PCPlus4D),.IF_ID_instr_out(InstrD),.PCD(PCD)
    );
    // STAGE ID: Instruction Decode
    wire[63:0]RD1,RD2,ImmExtD,ResultW;
    reg_file RF(
        .clk(clk),.reset(reset),.read_reg1(InstrD[19:15]),.read_reg2(InstrD[24:20]),
        .write_reg(RdW),.write_data(ResultW),.reg_write_en(RegWriteW),
        .read_data1(RD1),.read_data2(RD2)
    );
    ig IMM_GEN(.instr(InstrD),.imm_data(ImmExtD));

    // ID/EX PIPELINE REGISTER
    wire[63:0]RD1E,RD2E,ImmExtE,PCE,PCPlus4E;
    wire ALUSrcE,MemReadE,MemWriteE,BranchE,JumpE,JALRSrcE;
    wire[3:0]ALUControlE;
    id_ex IDEX_Reg(
        .clk(clk),.reset(reset),.flush(FlushE),
        .ResultSrc(ResultSrcD),.reg_write_en(RegWriteD),.mem_read(MemReadD),.mem_write(MemWriteD),
        .branch(BranchD),.alu_src(ALUSrcD),.alu_control(ALUControlD),.Jump(JumpD),.JALRSrc(JALRSrcD),
        .ID_EX_pc_in(PCPlus4D),.PCD(PCD),.data_in_1(RD1),.data_in_2(RD2),.imm_gen(ImmExtD),
        .ID_EX_rd_in(InstrD[11:7]),.ID_EX_rs1_in(InstrD[19:15]),.ID_EX_rs2_in(InstrD[24:20]),
        .ResultSrcE(ResultSrcE),.reg_write_en_out(RegWriteE),.mem_read_out(MemReadE),
        .mem_write_out(MemWriteE),.branch_out(BranchE),.alu_src_out(ALUSrcE),
        .alu_control_out(ALUControlE),.PCE(PCE),.JumpE(JumpE),.JALRSrcE(JALRSrcE),.ID_EX_MEM_pc_out(PCPlus4E),
        .data_out_1(RD1E),.data_out_2(RD2E),.imm_gen_out(ImmExtE),
        .ID_EX_MEM_rd_out(RdE),.ID_EX_MEM_rs1_out(RsE),.ID_EX_MEM_rs2_out(RtE)
    );
    // STAGE EX: Execute
    wire[63:0]SrcAE,WriteDataE,SrcBE,ALUResultE;
    wire[63:0]fwd_a_s1,fwd_b_s1,ALUResultM;
    wire zero_flag_e;
    mux2_64 mux_fwd_a_s1(.i0(RD1E),.i1(ResultW),.sel(ForwardAE[0]),.out(fwd_a_s1));
    mux2_64 mux_fwd_a_s2(.i0(fwd_a_s1),.i1(ALUResultM),.sel(ForwardAE[1]),.out(SrcAE));
    mux2_64 mux_fwd_b_s1(.i0(RD2E),.i1(ResultW),.sel(ForwardBE[0]),.out(fwd_b_s1));
    mux2_64 mux_fwd_b_s2(.i0(fwd_b_s1),.i1(ALUResultM),.sel(ForwardBE[1]),.out(WriteDataE));
    mux2_64 mux_alu_src_b(.i0(WriteDataE),.i1(ImmExtE),.sel(ALUSrcE),.out(SrcBE));
    alu_64_bit ALU(.a(SrcAE),.b(SrcBE),.opcode(ALUControlE),.result(ALUResultE),.zero_flag(zero_flag_e));
    // Branch/JAL target: PCE + ImmExtE
    wire[63:0]PCTargetAdder;
    adder_64 add_br_target(.a(PCE),.b(ImmExtE),.sum(PCTargetAdder),.carry(),.overflow());
    wire[63:0]jalr_target;
    assign jalr_target = {ALUResultE[63:1], 1'b0};
    mux2_64 mux_pc_target(.i0(PCTargetAdder),.i1(jalr_target),.sel(JALRSrcE),.out(PCTargetE));
    wire br_taken_e;
    and(br_taken_e,BranchE,zero_flag_e); 
    or(PCSrcE,JumpE,br_taken_e); 
    // EX/MEM PIPELINE REGISTER
    wire[63:0]WriteDataM,PCPlus4M;
    wire[1:0]ResultSrcM;
    wire RegWriteM,MemReadM,MemWriteM;
    ex_mem EXMEM_Reg(
        .clk(clk),.reset(reset),
        .ResultSrcE(ResultSrcE),.reg_write_en(RegWriteE),.mem_read(MemReadE),.mem_write(MemWriteE),
        .alu_out(ALUResultE),.data2(WriteDataE),.PCPlus4E(PCPlus4E),.rd(RdE),.rs2_ID_EX(RtE),
        .ResultSrcM(ResultSrcM),.reg_write_en_out(RegWriteM),.mem_read_out(MemReadM),
        .mem_write_out(MemWriteM),.alu_out_out(ALUResultM),.data2_out(WriteDataM),
        .PCPlus4M(PCPlus4M),.rd_out(RdM),.rs2_ID_EX_out()
    );
    // STAGE MEM: Memory
    wire[63:0]ReadDataM;
    data_mem DMEM(.clk(clk),.reset(reset),.MemRead(MemReadM),.MemWrite(MemWriteM),
                   .address(ALUResultM),.write_data(WriteDataM),.read_data(ReadDataM));
    // MEM/WB PIPELINE REGISTER
    wire[63:0]ALUResultW,ReadDataW,PCPlus4W;
    wire[1:0]ResultSrcW;
    mem_wb MEMWB_Reg(
        .clk(clk),.reset(reset),
        .ResultSrcM(ResultSrcM),.reg_write_en(RegWriteM),
        .data(ReadDataM),.alu_out(ALUResultM),.PCPlus4M(PCPlus4M),.rd(RdM),
        .data_out(ReadDataW),.alu_out_out(ALUResultW),.PCPlus4W(PCPlus4W),.rd_out(RdW),
        .ResultSrcW(ResultSrcW),.reg_write_en_out(RegWriteW)
    );
    // STAGE WB: Writeback (2-Stage implementation)
    wire[63:0]wb_stage1;
    // mux2_64 to pick between ALUResult and ReadData
    mux2_64 mux_wb_s1(.i0(ALUResultW),.i1(ReadDataW),.sel(ResultSrcW[0]),.out(wb_stage1));
    // mux2_64 to pick between Stage1 result and PCPlus4
    mux2_64 mux_wb_s2(.i0(wb_stage1),.i1(PCPlus4W),.sel(ResultSrcW[1]),.out(ResultW));

endmodule