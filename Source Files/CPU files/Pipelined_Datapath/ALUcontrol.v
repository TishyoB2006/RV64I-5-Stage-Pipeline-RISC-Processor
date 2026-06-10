//GENERATES "alucs" signal from ALUOP and func fields
module ALU_Control(ALUOP,opcode,funct3,funct7_30,alucs);
       input [1:0] ALUOP;  //Received from Main Control Unit
       input [6:0] opcode; //Opcode extracted from Instruction[6:0]
       input [2:0] funct3; //funct3 field extracted from Instruction[14:12]
       input funct7_30; //Also extracted from Instruction received..we only use 31st bit...as funct 7 for all R opns and I opns
                        //Only sub operation has 1 in the bit after msb that is the 31st bit of the instruction
       output reg [3:0] alucs;
       always @(*) begin
             if (ALUOP == 2'b00)
                 alucs = 4'b0000;      //SIGNAL FOR ADD OPERATION(sd,ld instructions)
             else if (ALUOP ==2'b01)
                 alucs = 4'b0001;      //SIGNAL FOR SUB OPERATION(beq,bneq instructions)
             else if (ALUOP == 2'b10) begin
                  case (funct3)
                       3'b000:begin
                              if (opcode == 7'b0110011) begin     //TO AVOID CONFUSION AS funct 7 field DNE FOR I TYPE
                                   if (funct7_30)
                                       alucs = 4'b0001; // SUB instructions
                                   else
                                       alucs = 4'b0000; // ADD instructions
                              end
                              else
                                   alucs = 4'b0000; // ADDI instructions
                       end
                       3'b111:
                              alucs = 4'b0010;     // AND and ANDI instructions
                       3'b110:
                              alucs = 4'b0011;     // OR and ORI instructions
                       3'b100:
                              alucs = 4'b0100;     // XOR and XORI instructions
                       3'b001:
                              alucs = 4'b0101;     // SLL instruction
                       3'b101:
                              alucs = 4'b0110;     // SRL instruction
                       default:
                              alucs = 4'b0000;
                  endcase
           end
           else
               alucs = 4'b0000;
       end
endmodule
