// FORWARDING UNIT — EX-EX, MEM-EX, and MEM-MEM paths
module ForwardingUnit (
    // Source registers
    input  [4:0]  EX_rs1,
    input  [4:0]  EX_rs2,

    // From EX/MEM pipeline register
    input         EX_MEM_RegWrite,
    input  [4:0]  EX_MEM_rd,

    // From MEM/WB pipeline register
    input         MEM_WB_RegWrite,
    input  [4:0]  MEM_WB_rd,

    // Extra signals for MEM-MEM forwarding(This is a unique modifictaion of the typical forwarding unit)
    input  [4:0]  MEM_rs2,
    input         MEM_MemWrite,
    input         WB_MemtoReg,
    output reg [1:0] ForwardA,                  
    output reg [1:0] ForwardB,


    output reg       ForwardM
);

    always @(*) begin

        // ForwardA (ALU operand A = rs1) 
        // EX-EX has priority over MEM-EX
        if (EX_MEM_RegWrite &&
            (EX_MEM_rd != 5'd0) &&
            (EX_MEM_rd == EX_rs1))
            ForwardA = 2'b10;           // EX-EX forward

        else if (MEM_WB_RegWrite &&
                 (MEM_WB_rd != 5'd0) &&
                 (MEM_WB_rd == EX_rs1))
            ForwardA = 2'b01;           // MEM-EX forward

        else
            ForwardA = 2'b00;           // no hazard, use RF

        //  ForwardB (ALU operand B = rs2)
        if (EX_MEM_RegWrite &&
            (EX_MEM_rd != 5'd0) &&
            (EX_MEM_rd == EX_rs2))
            ForwardB = 2'b10;           // EX-EX forward

        else if (MEM_WB_RegWrite &&
                 (MEM_WB_rd != 5'd0) &&
                 (MEM_WB_rd == EX_rs2))
            ForwardB = 2'b01;           // MEM-EX forward

        else
            ForwardB = 2'b00;           // no hazard, use RF
      //MEM-MEM forwarding(handles a special case)
        if (MEM_MemWrite &&
            WB_MemtoReg &&
            MEM_WB_RegWrite &&
            (MEM_WB_rd != 5'd0) &&
            (MEM_WB_rd == MEM_rs2))
            ForwardM = 1'b1;            // MEM-MEM forward

        else
            ForwardM = 1'b0;            // normal store data
    end

endmodule
