module ResultMux (
    input  [63:0] WB_ALUResult,   // from MEM/WB
    input  [63:0] WB_ReadData,    // from MEM/WB (load data)
    input         WB_MemtoReg,    // from MEM/WB control
    output [63:0] WB_WriteData    // goes to register file wd
);
    assign WB_WriteData = WB_MemtoReg ? WB_ReadData : WB_ALUResult;
endmodule
