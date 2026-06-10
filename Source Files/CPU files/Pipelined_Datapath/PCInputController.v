module PCInputController (
    input  [63:0] PC_current,
    input  [63:0] PC_plus4,
    input  [63:0] BranchTargetPC,
    input  BranchEQ,
    input  BranchNEQ,
    input  Zero,
    input  PC_exception,

    output reg [63:0] PC_next,
    output wire IF_Flush
);
    localparam [63:0] TRAP_VECTOR = 64'hC090000;

    assign branch_taken = (BranchEQ & Zero) | (BranchNEQ & ~Zero);
    assign IF_Flush = branch_taken;   // flush IF/ID when branch taken

    always @(*) begin
        if (PC_exception)
            PC_next = TRAP_VECTOR;
        else if (branch_taken)
            PC_next = BranchTargetPC;
        else
            PC_next = PC_plus4;
    end
endmodule
