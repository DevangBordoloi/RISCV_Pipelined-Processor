module ex_mem(
    input clk, reset,
    input [1:0] ResultSrcE,
    input reg_write_en, mem_read, mem_write,
    input [63:0] alu_out, data2, PCPlus4E,
    input [4:0]  rd, rs2_ID_EX,
    output [1:0] ResultSrcM,
    output reg_write_en_out, mem_read_out, mem_write_out,
    output [63:0] alu_out_out, data2_out, PCPlus4M,
    output [4:0]  rd_out, rs2_ID_EX_out
);
    reg [1:0]  ResultSrcM_reg;
    reg        reg_write_en_reg, mem_read_reg, mem_write_reg;
    reg [63:0] alu_reg, data2_reg, pcplus4_reg;
    reg [4:0]  rd_reg, rs2_reg;

    always @(posedge clk) begin
        if (reset) begin
            ResultSrcM_reg   <= 2'b0;
            reg_write_en_reg <= 1'b0;
            mem_read_reg     <= 1'b0;
            mem_write_reg    <= 1'b0;
            alu_reg          <= 64'b0;
            data2_reg        <= 64'b0;
            pcplus4_reg      <= 64'b0;
            rd_reg           <= 5'b0;
            rs2_reg          <= 5'b0;
        end else begin
            ResultSrcM_reg   <= ResultSrcE;
            reg_write_en_reg <= reg_write_en;
            mem_read_reg     <= mem_read;
            mem_write_reg    <= mem_write;
            alu_reg          <= alu_out;
            data2_reg        <= data2;
            pcplus4_reg      <= PCPlus4E;
            rd_reg           <= rd;
            rs2_reg          <= rs2_ID_EX;
        end
    end

    assign ResultSrcM      = ResultSrcM_reg;
    assign reg_write_en_out = reg_write_en_reg;
    assign mem_read_out    = mem_read_reg;
    assign mem_write_out   = mem_write_reg;
    assign alu_out_out     = alu_reg;
    assign data2_out       = data2_reg;
    assign PCPlus4M        = pcplus4_reg;
    assign rd_out          = rd_reg;
    assign rs2_ID_EX_out   = rs2_reg;
endmodule
