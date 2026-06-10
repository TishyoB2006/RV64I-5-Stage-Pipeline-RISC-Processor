module CPU_Top (
    input clk,
    input reset,
    input cpu_shutdown_button,
    output wire MEM_MemWrite,MEM_MemRead,
    output wire [63:0] MEM_WriteData,
    output wire [63:0] PC_out,           
    output wire [31:0] IF_Instruction,   

    output wire [63:0] MEM_Address,     
    output wire [63:0] MEM_ReadData
);

// Instruction Memory 
Instruction_Memory InstructionMemory_inst (
    .PC   (PC_out),
    .Instr(IF_Instruction)
);

//Data Memory 
DataMemory DataMemory_inst (
    .clk      (clk),
    .MemRead  (MEM_MemRead),
    .MemWrite (MEM_MemWrite),
    .wd       (MEM_WriteData),
    .Address  (MEM_Address),
    .ReadData (MEM_ReadData)
);

// Pipeline Datapath 
PipelineDatapath PipelineDatapath_inst (
    .clk                (clk),
    .reset              (reset),
    .cpu_shutdown_button(cpu_shutdown_button),
    // From memories
    .IF_Instruction     (IF_Instruction),
    .MEM_ReadData       (MEM_ReadData),
    // To memories
    .PC_out             (PC_out),
    .MEM_ALUResult_out  (MEM_Address),
    .MEM_StoreData_out  (MEM_WriteData),
    .MEM_MemWrite_out   (MEM_MemWrite),
    .MEM_MemRead_out    (MEM_MemRead),
    // Observation
    .WB_WriteData_out   ()    
);

endmodule
