/*THIS REGISTER STORES THE ADDRESS OF THE LAST INCORRECT ONSTRUCTION
THIS HELPS THE PROCESSOR IN RESUMING THE PROPER WORKFLOW ONCE THE 
EXCEPTION HAS BEEN HANDLED*/

module SCAUSE (
    input         clk,
    input         exception,
    output reg [63:0] scause_out  
);
    always @(posedge clk) begin
        if (exception)
            scause_out <= 64'd2;  // code 2 = illegal instruction
    end
endmodule
