//IF/ID Pipeline register
module IFID(
       input clk,reset,stall_flag,flush_flag,
       input [31:0] IF_Instruction,   //IF_something basically means input side of IFID 
       input [63:0] IF_PC_Op,         //Means output of PC fed to the register
       input [63:0] IF_PCplus4,
       
       output reg [31:0] ID_Instruction,
       output reg [63:0] ID_PC_Op,
       output reg [63:0] ID_PCplus4);
       
       always @(posedge clk)begin
              if (reset||flush_flag)begin     //If reset or flushing done
                  ID_Instruction <= 32'h13;
                  ID_PC_Op <= 64'b0;
                  ID_PCplus4 <= 64'b0;
              end
              else if (stall_flag)begin      //If asked to stall output data remains same
                  ID_Instruction <= ID_Instruction;
                  ID_PC_Op <= ID_PC_Op;
                  ID_PCplus4 <= ID_PCplus4;
              end
              else begin
                   ID_Instruction <= IF_Instruction;
                   ID_PC_Op <= IF_PC_Op;
                   ID_PCplus4 <= IF_PCplus4;
              end
      end
endmodule
                  
 //NOTE:For true transfer to NOP during stalling one should send instruction to hex value of 13 insted of 0...not much effct tho      
       
