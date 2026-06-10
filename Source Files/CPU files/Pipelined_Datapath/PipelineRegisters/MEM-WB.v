//MEM/WB Pipeline register
module MEM_WB (
    input clk,
    input reset,
    // Datapath inputs
    input [63:0] MEM_ALUResult,     
    input [63:0] MEM_ReadData,      
    input [63:0] MEM_PCplus4,       
    input [4:0]  MEM_rd,            
    // Control inputs
    input        MEM_MemtoReg,       
    input        MEM_RegWrite,      
    // Datapath outputs
    output reg [63:0] WB_ALUResult,
    output reg [63:0] WB_ReadData,
    output reg [63:0] WB_PCplus4,
    output reg [4:0]  WB_rd,
    // Control outputs
    output reg        WB_MemtoReg,
    output reg        WB_RegWrite
);
    always @(posedge clk) begin
        if (reset) begin
            WB_ALUResult <= 64'b0;
            WB_ReadData  <= 64'b0;
            WB_PCplus4   <= 64'b0;
            WB_rd        <= 5'b0;
            WB_MemtoReg  <= 1'b0;
            WB_RegWrite  <= 1'b0;
        end else begin
            WB_ALUResult <= MEM_ALUResult;
            WB_ReadData  <= MEM_ReadData;
            WB_PCplus4   <= MEM_PCplus4;
            WB_rd        <= MEM_rd;
            WB_MemtoReg  <= MEM_MemtoReg;
            WB_RegWrite  <= MEM_RegWrite;
        end
    end
endmodule
