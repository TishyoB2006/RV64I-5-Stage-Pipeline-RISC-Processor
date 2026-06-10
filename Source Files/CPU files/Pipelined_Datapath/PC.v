module PC (
    input wire        clk,
    input wire        reset,
    input wire [63:0] PCNext,
    input wire        PCWrite,
    output wire [63:0] PC
);

   reg [63:0] PCReg;

   always @(posedge clk or posedge reset)
   begin
      if (reset)
         PCReg <= 64'd0;
      else if (PCWrite)
         PCReg <= PCNext;
   end

   assign PC = PCReg;

endmodule
