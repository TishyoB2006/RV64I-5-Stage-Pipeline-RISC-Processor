//THIS IS A SPECIAL REGISTER THAT STORES THE CAUSE OF AN EXCEPTION
//OCCURED.IT HELPS THE OPERATING SYSTEM IN RESOLVING THE EXCEPTION

module SEPC (
    input         clk,
    input         exception,      // write enable
    input  [63:0] EX_PC_Op,       // faulting instruction's PC
    output reg [63:0] sepc_out    
);
    always @(posedge clk) begin
        if (exception)
            sepc_out <= EX_PC_Op;
    end
endmodule
