module id_ex(
    input clk, reset, flush,
    input [1:0] ResultSrc,
    input reg_write_en, mem_read, mem_write, branch, alu_src, Jump, JALRSrc,
    input [3:0] alu_control,
    input [63:0] ID_EX_pc_in,  
    input [63:0] PCD,           
    input [63:0] data_in_1, data_in_2, imm_gen,
    input [4:0]  ID_EX_rd_in, ID_EX_rs1_in, ID_EX_rs2_in,
    output [1:0] ResultSrcE,
    output reg_write_en_out, mem_read_out, mem_write_out, branch_out, alu_src_out, JumpE, JALRSrcE,
    output [3:0] alu_control_out,
    output [63:0] ID_EX_MEM_pc_out, 
    output [63:0] PCE,              
    output [63:0] data_out_1, data_out_2, imm_gen_out,
    output [4:0]  ID_EX_MEM_rd_out, ID_EX_MEM_rs1_out, ID_EX_MEM_rs2_out
);
    reg [1:0]  ResultSrcE_reg;
    reg        reg_write_en_reg, mem_read_reg, mem_write_reg, branch_reg, alu_src_reg, Jump_reg, JALRSrc_reg;
    reg [3:0]  alu_control_reg;
    reg [63:0] pc_plus4_reg, pc_reg;
    reg [63:0] data_out_1_reg, data_out_2_reg, imm_gen_reg;
    reg [4:0]  rd_reg, rs1_reg, rs2_reg;

    always @(posedge clk) begin
        if (reset || flush) begin
            ResultSrcE_reg    <= 2'b0;
            reg_write_en_reg  <= 1'b0;
            mem_read_reg      <= 1'b0;
            mem_write_reg     <= 1'b0;
            branch_reg        <= 1'b0;
            alu_src_reg       <= 1'b0;
            Jump_reg          <= 1'b0;
            JALRSrc_reg       <= 1'b0;
            alu_control_reg   <= 4'b0;
            pc_plus4_reg      <= 64'b0;
            pc_reg            <= 64'b0;
            data_out_1_reg    <= 64'b0;
            data_out_2_reg    <= 64'b0;
            imm_gen_reg       <= 64'b0;
            rd_reg            <= 5'b0;
            rs1_reg           <= 5'b0;
            rs2_reg           <= 5'b0;
        end else begin
            ResultSrcE_reg    <= ResultSrc;
            reg_write_en_reg  <= reg_write_en;
            mem_read_reg      <= mem_read;
            mem_write_reg     <= mem_write;
            branch_reg        <= branch;
            alu_src_reg       <= alu_src;
            Jump_reg          <= Jump;
            JALRSrc_reg       <= JALRSrc;
            alu_control_reg   <= alu_control;
            pc_plus4_reg      <= ID_EX_pc_in;
            pc_reg            <= PCD;
            data_out_1_reg    <= data_in_1;
            data_out_2_reg    <= data_in_2;
            imm_gen_reg       <= imm_gen;
            rd_reg            <= ID_EX_rd_in;
            rs1_reg           <= ID_EX_rs1_in;
            rs2_reg           <= ID_EX_rs2_in;
        end
    end

    assign ResultSrcE         = ResultSrcE_reg;
    assign reg_write_en_out   = reg_write_en_reg;
    assign mem_read_out       = mem_read_reg;
    assign mem_write_out      = mem_write_reg;
    assign branch_out         = branch_reg;
    assign alu_src_out        = alu_src_reg;
    assign JumpE              = Jump_reg;
    assign JALRSrcE           = JALRSrc_reg;
    assign alu_control_out    = alu_control_reg;
    assign ID_EX_MEM_pc_out   = pc_plus4_reg;
    assign PCE                = pc_reg;
    assign data_out_1         = data_out_1_reg;
    assign data_out_2         = data_out_2_reg;
    assign imm_gen_out        = imm_gen_reg;
    assign ID_EX_MEM_rd_out   = rd_reg;
    assign ID_EX_MEM_rs1_out  = rs1_reg;
    assign ID_EX_MEM_rs2_out  = rs2_reg;
endmodule
