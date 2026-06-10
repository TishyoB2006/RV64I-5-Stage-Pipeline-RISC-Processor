module Top_Control_Unit (
    input  [6:0] opcode,       
    input  [2:0] funct3,       
    input        funct7_30,    

    output       BranchEQ,
    output       BranchNEQ,
    output       MemRead,
    output       MemWrite,
    output       MemtoReg,
    output       RegWrite,
    output       ALUSrc,
    output [1:0] ALUOP,
    output       exception      
);
    // NOTE: alucs is NOT generated here in the pipeline.

    MainControlUnit MainControlUnit_inst (
        .Opcode   (opcode),
        .funct3   (funct3),
        .BranchEQ (BranchEQ),
        .BranchNEQ(BranchNEQ),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .RegWrite (RegWrite),
        .ALUSrc   (ALUSrc),
        .MemtoReg (MemtoReg),
        .ALUOP    (ALUOP),
        .exception(exception)
    );
endmodule
