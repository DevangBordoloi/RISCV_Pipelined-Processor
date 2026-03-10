`include "cu.v"
`include "alu_cu.v"
`include "jal_jump.v"
module control_unit_top (
    input [6:0] opcode,
    input [2:0] instr11,
    input instr12,
    input zero_flag,
    output Branch, MemRead, MemWrite, ALUSrc, RegWrite, Jump, JALRSrc,
    output [1:0] ResultSrc,
    output [3:0] ALUControl
);

    wire [1:0] w_ALUOp;
    wire w_MemtoReg;

    jump_control JC (
        .opcode(opcode),
        .Jump(Jump),
        .JALRSrc(JALRSrc)
    );

    cu Main_Control (
        .opcode(opcode),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(w_MemtoReg),
        .ALUOp(w_ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    alu_cu ALU_Control (
        .ALUOp(w_ALUOp),
        .funct3(instr11),
        .funct7_bit(instr12),
        .ALUControl(ALUControl)
    );
    assign ResultSrc = {Jump, w_MemtoReg};

endmodule

