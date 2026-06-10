/*============================================================
 HAZARD DETECTION UNIT
 Handles:
   1. Load-use hazard  → stall + ID_Flush
   2. Exception        → EX_Flush + PC redirect to trap vector
============================================================*/
module HazardDetectionUnit (
    input        ID_EX_MemRead,
    input  [4:0] ID_EX_rd,
    input  [4:0] IF_ID_rs1,
    input  [4:0] IF_ID_rs2,
    input        exception,

    // Stall outputs
    output reg   PCWrite,         //We write 0 to freeze the PC while stalling
    output reg   stall_flag,      

    // Flush outputs
    output reg   ID_Flush,        //Handles load use data hazard
    output reg   EX_Flush,        //Used in exception handling

    output reg   PC_exception     
);
    always @(*) begin
        // ── Defaults ────────────────────────────────────────
        PCWrite      = 1'b1;
        stall_flag   = 1'b0;
        ID_Flush     = 1'b0;
        EX_Flush     = 1'b0;
        PC_exception = 1'b0;

        //Code has been written giving higher priority to exceptions than hazards...they can be intechanged
        if (exception) begin
            EX_Flush     = 1'b1;  // kill instruction entering EX/MEM
            PC_exception = 1'b1;  // redirect PC to trap vector C090000
            PCWrite      = 1'b1;  // PC must update to trap vector
            stall_flag   = 1'b0;
            ID_Flush     = 1'b0;
        end
        else if (ID_EX_MemRead &&
                ((ID_EX_rd == IF_ID_rs1) ||
                 (ID_EX_rd == IF_ID_rs2))) begin
            PCWrite      = 1'b0;  // freeze PC
            stall_flag   = 1'b1;  // freeze IF/ID
            ID_Flush     = 1'b1;  // bubble into ID/EX
            EX_Flush     = 1'b0;
            PC_exception = 1'b0;
        end
    end
endmodule
