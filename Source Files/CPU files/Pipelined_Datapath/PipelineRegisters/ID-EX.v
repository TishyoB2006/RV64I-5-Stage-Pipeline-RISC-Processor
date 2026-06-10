//ID/EX PIPELINE REGISTER(Assuming PC+Imm step occurs at ID stage to reduce flushing
module IDEX(
       input clk, reset, stall_flag, IDflush_flag,
       input [31:0] ID_Instruction,
       // Inputs from Decode (ID) Stage Datapath
       input [63:0] ID_PC_Op,
       input [63:0] ID_PCplus4,
       input [63:0] ID_ReadData1,     // From Register File Port 1
       input [63:0] ID_ReadData2,     // From Register File Port 2
       input [63:0] ID_Immediate,
       input [4:0]  ID_rs1,           // Source register 1 address
       input [4:0]  ID_rs2,           // Source register 2 address
       input [4:0]  ID_rd,
       input [63:0] ID_BranchTargetPC,            // Destination register address
       // Inputs from Main Control Unit
       input        ID_BranchEQ,
       input        ID_BranchNEQ,
       input        ID_MemWrite,
       input        ID_MemRead,
       input        ID_RegWrite,
       input        ID_ALUSrc,
       input        ID_MemtoReg,
       input [1:0]  ID_ALUOP,
       input  [2:0] ID_funct3,
       input        ID_funct7_30,
       
       output reg [2:0] EX_funct3,
       output reg  EX_funct7_30,       
       output reg [63:0] EX_PC_Op,
       output reg [63:0] EX_PCplus4,
       output reg [63:0] EX_BranchTargetPC,
       output reg [63:0] EX_ReadData1,     
       output reg [63:0] EX_ReadData2,     
       output reg [63:0] EX_Immediate,    
       output reg [4:0]  EX_rs1,           
       output reg [4:0]  EX_rs2,           
       output reg [4:0]  EX_rd,
       output reg [31:0] EX_Instruction, 
       
       output reg        EX_BranchEQ,
       output reg        EX_BranchNEQ,
       output reg        EX_MemWrite,
       output reg        EX_MemRead,
       output reg        EX_RegWrite,
       output reg        EX_ALUSrc,
       output reg        EX_MemtoReg,
       output reg [1:0]  EX_ALUOP
);
       
       always @(posedge clk) begin
             if (reset || stall_flag || IDflush_flag) begin
                EX_PC_Op     <= 64'b0;
                EX_PCplus4   <= 64'b0;
                EX_ReadData1 <= 64'b0;
                EX_ReadData2 <= 64'b0;
                EX_Immediate <= 64'b0;
                EX_rs1       <= 5'b0;
                EX_rs2       <= 5'b0;
                EX_rd        <= 5'b0;
                EX_BranchEQ  <= 1'b0;
                EX_BranchNEQ <= 1'b0;
                EX_MemWrite  <= 1'b0;
                EX_MemRead   <= 1'b0;
                EX_RegWrite  <= 1'b0;
                EX_ALUSrc    <= 1'b0;
                EX_MemtoReg  <= 1'b0;
                EX_ALUOP     <= 2'b0;
                EX_Instruction <= 32'h13;
                EX_funct3 <= 3'b0;
                EX_funct7_30 <= 1'b0; //LAST TWO SIGNALS NEEED BY ALU CONTROL BLOCK
                EX_BranchTargetPC <= 64'b0;
             end
             else begin
                EX_PC_Op     <= ID_PC_Op;
                EX_PCplus4   <= ID_PCplus4;
                EX_ReadData1 <= ID_ReadData1;
                EX_ReadData2 <= ID_ReadData2; // Fixed Typo
                EX_Immediate <= ID_Immediate;
                EX_rs1       <= ID_rs1;
                EX_rs2       <= ID_rs2;
                EX_rd        <= ID_rd;
                EX_BranchEQ  <= ID_BranchEQ;
                EX_BranchNEQ <= ID_BranchNEQ; // Fixed Typo
                EX_MemWrite  <= ID_MemWrite;
                EX_MemRead   <= ID_MemRead;
                EX_RegWrite  <= ID_RegWrite;
                EX_ALUSrc    <= ID_ALUSrc;
                EX_MemtoReg  <= ID_MemtoReg;
                EX_ALUOP     <= ID_ALUOP;
                EX_Instruction <= ID_Instruction;
                EX_funct3 <= ID_funct3;
                EX_funct7_30 <= ID_funct7_30;
                EX_BranchTargetPC <= ID_BranchTargetPC;
             end
       end
endmodule
