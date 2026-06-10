//EX/MEM Pipeline register

module EX_MEM (
    input clk,
    input reset,
    input EXflush_flag,
    
    // Inputs from Execution (EX) Stage Datapath
    input [63:0] EX_ALUResult,
    input [63:0] EX_ALUB,            // Output of forwarding mux B (Data to be stored)
    input        EX_ZeroFlag,
    input [63:0] EX_BranchTargetPC,
    input [63:0] EX_PCplus4,    
    input [4:0]  EX_rd,              // Fixed double underscore typo
    
    // Inputs from Control Unit 
    input        EX_MemRead,   
    input        EX_MemWrite,
    input        EX_MemtoReg,
    input        EX_RegWrite,
    input  EX_BranchEQ,
    input  EX_BranchNEQ, 
    
    // Outputs to Memory (MEM) Stage Datapath
    output reg [63:0] MEM_ALUResult,
    output reg [63:0] MEM_ALUB,
    output reg        MEM_ZeroFlag,
    output reg [63:0] MEM_BranchTargetPC,
    output reg [63:0] MEM_PCplus4,       
    output reg [4:0]  MEM_rd,
    output reg        MEM_MemRead,
    output reg        MEM_MemWrite,
    output reg        MEM_MemtoReg,
    output reg        MEM_RegWrite,
    output reg MEM_BranchEQ,
    output reg MEM_BranchNEQ);

    always @(posedge clk) begin
        if (reset || EXflush_flag) begin
            MEM_ALUResult       <= 64'b0;
            MEM_ALUB            <= 64'b0;
            MEM_ZeroFlag        <= 1'b0;
            MEM_BranchTargetPC  <= 64'b0;
            MEM_PCplus4         <= 64'b0;
            MEM_rd              <= 5'b0;
            MEM_MemRead   <= 1'b0;
            MEM_MemWrite  <= 1'b0;
            MEM_MemtoReg <= 1'b0;
            MEM_RegWrite  <= 1'b0;
            MEM_BranchEQ        <= 1'b0;
            MEM_BranchNEQ       <= 1'b0;
        end 
        else begin
            MEM_ALUResult       <= EX_ALUResult;
            MEM_ALUB            <= EX_ALUB;
            MEM_ZeroFlag        <= EX_ZeroFlag;
            MEM_BranchTargetPC  <= EX_BranchTargetPC;
            MEM_PCplus4         <= EX_PCplus4;
            MEM_rd              <= EX_rd;
            MEM_MemRead         <= EX_MemRead;
            MEM_MemWrite        <= EX_MemWrite;
            MEM_MemtoReg        <= EX_MemtoReg;
            MEM_RegWrite        <= EX_RegWrite;
            MEM_BranchEQ        <= EX_BranchEQ;
            MEM_BranchNEQ       <= EX_BranchNEQ;
        end
    end

endmodule
