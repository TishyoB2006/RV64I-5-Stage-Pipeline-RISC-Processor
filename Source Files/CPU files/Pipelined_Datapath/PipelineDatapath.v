// ============================================================
//  PIPELINE DATAPATH
//  Instantiates all datapath components across 5 stages:
//  IF → ID → EX → MEM → WB
// ============================================================
module PipelineDatapath (
    input clk,
    input reset,
    input cpu_shutdown_button,

    // ── FROM CPU_TOP (Instruction Memory) ───────────────────
    input [31:0] IF_Instruction,    // from Instruction Memory
    input [63:0] MEM_ReadData,      // from Data Memory

    // ── TO CPU_TOP (Memory control) ──────────────────────────
    output [63:0] PC_out,           // to Instruction Memory
    output [63:0] MEM_ALUResult_out,// to Data Memory address
    output [63:0] MEM_StoreData_out,// to Data Memory write data
    output        MEM_MemWrite_out, // to Data Memory
    output        MEM_MemRead_out,  // to Data Memory

    output [63:0] WB_WriteData_out 
);


//IF Stage
wire [63:0] PC_current;
wire [63:0] PC_plus4;
wire [63:0] PC_next;
//  IF/ID Register outputs
wire [31:0] ID_Instruction;
wire [63:0] ID_PC_Op;
wire [63:0] ID_PCplus4;
// ID Stage
wire [63:0] ID_ReadData1, ID_ReadData2;
wire [63:0] ID_Immediate;
wire [63:0] ID_BranchTargetPC;  
wire        ID_Zero;
  
// Control signals from TopControlUnit (ID stage)
wire        ID_BranchEQ, ID_BranchNEQ;
wire        ID_MemRead,  ID_MemWrite;
wire        ID_RegWrite, ID_ALUSrc, ID_MemtoReg;
wire [1:0]  ID_ALUOP;
wire        ID_exception;
  
// Hazard / Flush signals
wire        PCWrite, stall_flag;
wire        IF_Flush, ID_Flush, EX_Flush;
wire        PC_exception;
  
// ID/EX Register outputs
wire [31:0] EX_Instruction;
wire [63:0] EX_PC_Op,    EX_PCplus4;
wire [63:0] EX_ReadData1, EX_ReadData2;
wire [63:0] EX_Immediate;
wire [63:0] EX_BranchTargetPC;
wire [4:0]  EX_rs1, EX_rs2, EX_rd;
wire        EX_BranchEQ,  EX_BranchNEQ;
wire        EX_MemRead,   EX_MemWrite;
wire        EX_RegWrite,  EX_ALUSrc, EX_MemtoReg;
wire [1:0]  EX_ALUOP;

// EX Stage 
wire [3:0]  EX_alucs;
wire [63:0] EX_ALU_A, EX_ALU_B, EX_ForwardedB;
wire [63:0] EX_ALUResult;
wire        EX_ZeroFlag;
wire [1:0]  ForwardA, ForwardB;
wire        ForwardM;

//  EX/MEM Register outputs 
wire [63:0] MEM_ALUResult;
wire [63:0] MEM_ALUB;
wire        MEM_ZeroFlag;
wire [63:0] MEM_BranchTargetPC;
wire [63:0] MEM_PCplus4;
wire [4:0]  MEM_rd;
wire        MEM_MemRead,   MEM_MemWrite;
wire        MEM_RegWrite,  MEM_MemtoReg;
wire        MEM_BranchEQ,  MEM_BranchNEQ;


wire [63:0] MEM_StoreData;   // after ForwardM mux

// MEM/WB Register outputs
wire [63:0] WB_ALUResult;
wire [63:0] WB_ReadData;
wire [63:0] WB_PCplus4;
wire [4:0]  WB_rd;
wire        WB_RegWrite, WB_MemtoReg;

// WB Stage 
wire [63:0] WB_WriteData;    


//  IF STAGE
  
assign PC_plus4 = PC_current + 64'd4;
assign PC_out   = PC_current;

PC PC_inst (
    .clk    (clk),
    .reset  (reset),
    .PCWrite(PCWrite),
    .PCNext (PC_next),
    .PC     (PC_current)
);

PCInputController PC_InputController_inst (
    .PC_plus4        (PC_plus4),
    .BranchTargetPC  (ID_BranchTargetPC), 
    .BranchEQ        (ID_BranchEQ),
    .BranchNEQ       (ID_BranchNEQ),
    .Zero            (ID_Zero),            
    .PC_exception    (PC_exception),
    .PC_next         (PC_next),
    .IF_Flush        (IF_Flush)            
);

IFID IFID_inst (
    .clk           (clk),
    .reset         (reset),
    .stall_flag    (stall_flag),
    .flush_flag    (IF_Flush),
    .IF_Instruction(IF_Instruction),
    .IF_PC_Op      (PC_current),
    .IF_PCplus4    (PC_plus4),
    .ID_Instruction(ID_Instruction),
    .ID_PC_Op      (ID_PC_Op),
    .ID_PCplus4    (ID_PCplus4)
);

//  ID STAGE

Top_Control_Unit Top_Control_Unit_inst (
    .opcode   (ID_Instruction[6:0]),
    .funct3   (ID_Instruction[14:12]),
    .funct7_30(ID_Instruction[30]),
    .BranchEQ (ID_BranchEQ),
    .BranchNEQ(ID_BranchNEQ),
    .MemRead  (ID_MemRead),
    .MemWrite (ID_MemWrite),
    .MemtoReg (ID_MemtoReg),
    .RegWrite (ID_RegWrite),
    .ALUSrc   (ID_ALUSrc),
    .ALUOP    (ID_ALUOP),
    .exception(ID_exception)
);

RegisterFile RegisterFile_inst (
    .clk      (clk),
    .RegWrite (WB_RegWrite),
    .ra1      (ID_Instruction[19:15]),
    .ra2      (ID_Instruction[24:20]),
    .wa       (WB_rd),
    .wd       (WB_WriteData),
    .rd1      (ID_ReadData1),
    .rd2      (ID_ReadData2),
    .rst      (reset)
);


ImmGen ImmGen_inst (
    .instruction      (ID_Instruction),
    .Immediate_SgnExt (ID_Immediate)
);

assign ID_BranchTargetPC = ID_PC_Op + ID_Immediate;

assign ID_Zero = (ID_ReadData1 == ID_ReadData2) ? 1'b1 : 1'b0;

HazardDetectionUnit HazardDetectionUnit_inst (
    .ID_EX_MemRead  (EX_MemRead),
    .ID_EX_rd       (EX_rd),
    .IF_ID_rs1      (ID_Instruction[19:15]),
    .IF_ID_rs2      (ID_Instruction[24:20]),
    .exception      (ID_exception),
    .PCWrite        (PCWrite),
    .stall_flag     (stall_flag),
    .ID_Flush       (ID_Flush),
    .EX_Flush       (EX_Flush),
    .PC_exception   (PC_exception)
);


//  ID/EX PIPELINE REGISTER

IDEX IDEX_inst (
    .clk              (clk),
    .reset            (reset),
    .stall_flag       (stall_flag),
    .IDflush_flag     (ID_Flush),
    // Datapath
    .ID_Instruction   (ID_Instruction),
    .ID_PC_Op         (ID_PC_Op),
    .ID_PCplus4       (ID_PCplus4),
    .ID_ReadData1     (ID_ReadData1),
    .ID_ReadData2     (ID_ReadData2),
    .ID_Immediate     (ID_Immediate),
    .ID_BranchTargetPC(ID_BranchTargetPC),
    .ID_rs1           (ID_Instruction[19:15]),
    .ID_rs2           (ID_Instruction[24:20]),
    .ID_rd            (ID_Instruction[11:7]),
    // Control
    .ID_BranchEQ      (ID_BranchEQ),
    .ID_BranchNEQ     (ID_BranchNEQ),
    .ID_MemWrite      (ID_MemWrite),
    .ID_MemRead       (ID_MemRead),
    .ID_RegWrite      (ID_RegWrite),
    .ID_ALUSrc        (ID_ALUSrc),
    .ID_MemtoReg      (ID_MemtoReg),
    .ID_ALUOP         (ID_ALUOP),
    // Outputs
    .EX_Instruction   (EX_Instruction),
    .EX_PC_Op         (EX_PC_Op),
    .EX_PCplus4       (EX_PCplus4),
    .EX_ReadData1     (EX_ReadData1),
    .EX_ReadData2     (EX_ReadData2),
    .EX_Immediate     (EX_Immediate),
    .EX_BranchTargetPC(EX_BranchTargetPC),
    .EX_rs1           (EX_rs1),
    .EX_rs2           (EX_rs2),
    .EX_rd            (EX_rd),
    .EX_BranchEQ      (EX_BranchEQ),
    .EX_BranchNEQ     (EX_BranchNEQ),
    .EX_MemWrite      (EX_MemWrite),
    .EX_MemRead       (EX_MemRead),
    .EX_RegWrite      (EX_RegWrite),
    .EX_ALUSrc        (EX_ALUSrc),
    .EX_MemtoReg      (EX_MemtoReg),
    .EX_ALUOP         (EX_ALUOP)
);


//  EX STAGE

ALU_Control ALU_Control_inst (
    .ALUOP    (EX_ALUOP),
    .opcode   (EX_Instruction[6:0]),
    .funct3   (EX_Instruction[14:12]),
    .funct7_30(EX_Instruction[30]),
    .alucs    (EX_alucs)
);

ForwardingUnit ForwardingUnit_inst (
    .EX_rs1         (EX_rs1),
    .EX_rs2         (EX_rs2),
    .EX_MEM_RegWrite(MEM_RegWrite),
    .EX_MEM_rd      (MEM_rd),
    .MEM_WB_RegWrite(WB_RegWrite),
    .MEM_WB_rd      (WB_rd),
    .MEM_rs2        (MEM_rd),        
    .MEM_MemWrite   (MEM_MemWrite),  
    .WB_MemtoReg    (WB_MemtoReg),   
    .ForwardA       (ForwardA),
    .ForwardB       (ForwardB),
    .ForwardM       (ForwardM)
);

ALU_mux ALU_mux_inst (
    .ForwardA       (ForwardA),
    .EX_ReadData1   (EX_ReadData1),
    .EX_MEM_ALUResult(MEM_ALUResult),
    .WB_WriteData   (WB_WriteData),
    .ForwardB       (ForwardB),
    .EX_ReadData2   (EX_ReadData2),
    .ALUSrc         (EX_ALUSrc),
    .EX_Immediate   (EX_Immediate),
    .ALU_A          (EX_ALU_A),
    .ALU_B          (EX_ALU_B),
    .ForwardedB     (EX_ForwardedB)  
);

ALU ALU_inst (
    .a               (EX_ALU_A),
    .b               (EX_ALU_B),
    .cpu_shutdown_button(cpu_shutdown_button),
    .alucs           (EX_alucs),
    .c               (EX_ALUResult),
    .z               (EX_ZeroFlag)
);

//  EX/MEM PIPELINE REGISTER

EX_MEM EX_MEM_inst (
    .clk               (clk),
    .reset             (reset),
    .EXflush_flag      (EX_Flush),
    // Datapath
    .EX_ALUResult      (EX_ALUResult),
    .EX_ALUB           (EX_ForwardedB),     // forwarded rs2 / store data
    .EX_ZeroFlag       (EX_ZeroFlag),
    .EX_BranchTargetPC (EX_BranchTargetPC),
    .EX_PCplus4        (EX_PCplus4),
    .EX_rd             (EX_rd),
    // Control
    .EX_MemRead        (EX_MemRead),
    .EX_MemWrite       (EX_MemWrite),
    .EX_MemtoReg       (EX_MemtoReg),
    .EX_RegWrite       (EX_RegWrite),
    .EX_BranchEQ       (EX_BranchEQ),
    .EX_BranchNEQ      (EX_BranchNEQ),
    // Outputs
    .MEM_ALUResult     (MEM_ALUResult),
    .MEM_ALUB          (MEM_ALUB),
    .MEM_ZeroFlag      (MEM_ZeroFlag),
    .MEM_BranchTargetPC(MEM_BranchTargetPC),
    .MEM_PCplus4       (MEM_PCplus4),
    .MEM_rd            (MEM_rd),
    .MEM_MemRead       (MEM_MemRead),
    .MEM_MemWrite      (MEM_MemWrite),
    .MEM_MemtoReg      (MEM_MemtoReg),
    .MEM_RegWrite      (MEM_RegWrite),
    .MEM_BranchEQ      (MEM_BranchEQ),
    .MEM_BranchNEQ     (MEM_BranchNEQ)
);

//  MEM STAGE

// SEPC and SCAUSE — capture exception 
wire [63:0] sepc_out, scause_out;
SEPC SEPC_inst (
    .clk      (clk),
    .exception(PC_exception),
    .EX_PC_Op (EX_PC_Op),
    .sepc_out (sepc_out)
);
SCAUSE SCAUSE_inst (
    .clk      (clk),
    .exception(PC_exception),
    .scause_out(scause_out)
);

assign MEM_StoreData = ForwardM ? WB_ReadData : MEM_ALUB;

// Drive outputs to CPU_Top (to Data Memory)
assign MEM_ALUResult_out  = MEM_ALUResult;
assign MEM_StoreData_out  = MEM_StoreData;
assign MEM_MemWrite_out   = MEM_MemWrite;
assign MEM_MemRead_out    = MEM_MemRead;

//  MEM/WB PIPELINE REGISTER

MEM_WB MEM_WB_inst (
    .clk            (clk),
    .reset          (reset),
    // Datapath
    .MEM_ALUResult  (MEM_ALUResult),
    .MEM_ReadData   (MEM_ReadData),
    .MEM_PCplus4    (MEM_PCplus4),
    .MEM_rd         (MEM_rd),
    // Control
    .MEM_MemtoReg   (MEM_MemtoReg),
    .MEM_RegWrite   (MEM_RegWrite),
    // Outputs
    .WB_ALUResult   (WB_ALUResult),
    .WB_ReadData    (WB_ReadData),
    .WB_PCplus4     (WB_PCplus4),
    .WB_rd          (WB_rd),
    .WB_MemtoReg    (WB_MemtoReg),
    .WB_RegWrite    (WB_RegWrite)
);


//  WB STAGE

ResultMux ResultMux_inst (
    .WB_ALUResult (WB_ALUResult),
    .WB_ReadData  (WB_ReadData),
    .WB_MemtoReg  (WB_MemtoReg),
    .WB_WriteData (WB_WriteData)
);

assign WB_WriteData_out = WB_WriteData;

endmodule
