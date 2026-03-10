`timescale 1ns/1ps

module hazard_unit(
    input [4:0] rsD,rtD,rsE,rtE,WriteRegE,WriteRegM,WriteRegW,
    input RegWriteE,RegWriteM,RegWriteW,
    input [1:0] ResultSrcE, 
    input PCSrcE,
    input JumpD, JALRSrcD,  
    output reg [1:0] ForwardAE,ForwardBE,
    output StallF,StallD,FlushD,FlushE 
);
    // 1. EXECUTE STAGE FORWARDING 
    // Sources data from Memory (M) or Writeback (W) stages to Execute (E)
    always@(*)begin
        if((rsE!=0)&&(rsE==WriteRegM)&&RegWriteM)
            ForwardAE=2'b10;
        else if((rsE!=0)&&(rsE==WriteRegW)&&RegWriteW)
            ForwardAE=2'b01;
        else
            ForwardAE=2'b00;
    end
    always@(*)begin
        if((rtE!=0)&&(rtE==WriteRegM)&&RegWriteM)
            ForwardBE=2'b10;
        else if((rtE!=0)&&(rtE==WriteRegW)&&RegWriteW)
            ForwardBE=2'b01;
        else
            ForwardBE=2'b00;
    end
    // 2. STALL LOGIC (Load-Use Hazard)
    wire lwstall;
    // ResultSrcE[0] is high for Load instructions
    
    wire rs1_usedD = !JumpD || JALRSrcD; 
    wire rs2_usedD = !JumpD;            
    assign lwstall=ResultSrcE[0]&&((rs1_usedD&&(rsD==WriteRegE))||(rs2_usedD&&(rtD==WriteRegE)));
    // 3. PIPELINE CONTROL (Stalls and Flushes)
    // Stall IF and ID stages during a Load-Use hazard
    assign StallF=lwstall;
    assign StallD=lwstall;
    // Flush ID stage if a branch/jump is taken (PCSrcE == 1)
    assign FlushD=PCSrcE;
    // Flush EX stage if a Load-Use hazard occurs OR a branch/jump is taken
    assign FlushE=lwstall||PCSrcE;
endmodule