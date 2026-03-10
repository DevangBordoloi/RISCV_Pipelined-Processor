module mem_wb(
    input clk, reset,
    input [1:0] ResultSrcM,
    input reg_write_en,
    input [63:0] data, alu_out, PCPlus4M,
    input [4:0]  rd,
    output [63:0] data_out, alu_out_out, PCPlus4W,
    output [4:0]  rd_out,
    output [1:0] ResultSrcW,
    output reg_write_en_out
);
    reg [1:0]  ResultSrcW_reg;
    reg        reg_write_en_reg;
    reg [63:0] data_reg, alu_reg, pcplus4_reg;
    reg [4:0]  rd_reg;

    always @(posedge clk) begin
        if (reset) begin
            ResultSrcW_reg   <= 2'b0;
            reg_write_en_reg <= 1'b0;
            data_reg         <= 64'b0;
            alu_reg          <= 64'b0;
            pcplus4_reg      <= 64'b0;
            rd_reg           <= 5'b0;
        end else begin
            ResultSrcW_reg   <= ResultSrcM;
            reg_write_en_reg <= reg_write_en;
            data_reg         <= data;
            alu_reg          <= alu_out;
            pcplus4_reg      <= PCPlus4M;
            rd_reg           <= rd;
        end
    end

    assign ResultSrcW      = ResultSrcW_reg;
    assign reg_write_en_out = reg_write_en_reg;
    assign data_out        = data_reg;
    assign alu_out_out     = alu_reg;
    assign PCPlus4W        = pcplus4_reg;
    assign rd_out          = rd_reg;
endmodule
