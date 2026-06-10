// ============================================================
//  EX STAGE FORWARDING + ALU INPUT MUXES
//  Three muxes combined:
//    1. ForwardA mux → selects final ALU operand A
//    2. ForwardB mux → selects forwarded rs2
//    3. ALUSrc mux   → selects ALU operand B (imm or forwarded rs2)
// ============================================================
module ALU_mux (
    input  [1:0]  ForwardA,
    input  [63:0] EX_ReadData1,     
    input  [63:0] EX_MEM_ALUResult,  
    input  [63:0] WB_WriteData,      

    input  [1:0]  ForwardB,
    input  [63:0] EX_ReadData2,     

    input         ALUSrc,
    input  [63:0] EX_Immediate,      

    output reg [63:0] ALU_A,         
    output reg [63:0] ALU_B,        
    output reg [63:0] ForwardedB    
);
    always @(*) begin
        // ── ForwardA mux ─────────────────────────────────────
        case (ForwardA)
            2'b00:   ALU_A = EX_ReadData1;      // no hazard
            2'b10:   ALU_A = EX_MEM_ALUResult;  // EX-EX forward
            2'b01:   ALU_A = WB_WriteData;       // MEM-EX forward
            default: ALU_A = EX_ReadData1;
        endcase

        // ── ForwardB mux ─────────────────────────────────────
        case (ForwardB)
            2'b00:   ForwardedB = EX_ReadData2;     // no hazard
            2'b10:   ForwardedB = EX_MEM_ALUResult; // EX-EX forward
            2'b01:   ForwardedB = WB_WriteData;      // MEM-EX forward
            default: ForwardedB = EX_ReadData2;
        endcase

        // ── ALUSrc mux ───────────────────────────────────────
        // ALU_B picks between forwarded rs2 or immediate
        ALU_B = ALUSrc ? EX_Immediate : ForwardedB;
    end
endmodule
