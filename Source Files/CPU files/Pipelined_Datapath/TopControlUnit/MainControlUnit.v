/*MAIN CONTROL UNIT THAT GENERATE ALL CONTROL SIGNALS OF
  THE PROCESSOR BASED ON THE INPUT 7 BIT OPCODE*/
module MainControlUnit(Opcode,funct3,BranchEQ,BranchNEQ,MemWrite,MemRead,RegWrite,ALUOP,ALUSrc,MemtoReg,exception);  //BranchEQ and BranchNEQ
       input [6:0] Opcode; 
       input [2:0] funct3;                                                                         //used for beq and bneq
       output reg BranchEQ,BranchNEQ,MemWrite,MemRead,RegWrite,ALUSrc,MemtoReg;
       output reg [1:0] ALUOP;
       output reg exception;
       always @(*) begin
             exception = 1'b0;
             case(Opcode)
                  7'b0110011:begin             //CONTROL SIGNALS FOR R TYPE INSTRUCTIONS
                            MemRead = 1'b0;
                            MemWrite = 1'b0;
                            BranchEQ = 1'b0;
                            BranchNEQ =1'b0;
                            MemtoReg = 1'b0;
                            ALUSrc = 1'b0;
                            RegWrite = 1'b1;
                            ALUOP = 2'b10;
                  end
                  7'b0000011:begin            //CONTROL SIGNALS FOR I TYPE INSTRUCTION ld
                            MemRead = 1'b1;
                            MemWrite = 1'b0;
                            BranchEQ = 1'b0;
                            BranchNEQ = 1'b0;
                            MemtoReg = 1'b1;
                            ALUSrc = 1'b1;
                            RegWrite = 1'b1;
                            ALUOP = 2'b00;
                  end
                  7'b0010011: begin           //CONTROL SIGNALS FOR I TYPE ARITHMETIC AND LOGICAL INSTRUCTIONS
                            RegWrite = 1'b1;
                            ALUSrc = 1'b1;
                            MemWrite = 1'b0;
                            BranchEQ = 1'b0;
                            BranchNEQ = 1'b0;
                            ALUOP = 2'b10;
                            MemtoReg = 1'b0;
                            MemRead = 1'b0;
                  end
                  7'b0100011:begin           //CONTROL SIGNALS FOR S TYPE INSTRUCTIONS
                            MemRead = 1'b0;
                            MemWrite = 1'b1;
                            BranchEQ = 1'b0;
                            BranchNEQ = 1'b0;
                            MemtoReg = 1'b0;
                            ALUSrc = 1'b1;
                            RegWrite = 1'b0;
                            ALUOP = 2'b00;
                  end
                  7'b1100011:begin          //CONTROL SIGNALS FOR B TYPE INSTRUCTIONS
                            MemRead = 1'b0;
                            MemWrite = 1'b0;
                            MemtoReg = 1'b0;
                            ALUSrc = 1'b0;
                            RegWrite = 1'b0;
                            ALUOP = 2'b01;
                            if(funct3 == 3'b000) begin
                               BranchEQ = 1'b1;
                               BranchNEQ = 1'b0;
                           end
                           else if(funct3 == 3'b001) begin
                                 BranchEQ = 1'b0;
                                 BranchNEQ = 1'b1;
                           end
                            
                  end
                  default: begin
                         MemRead  = 1'b0;
                         MemWrite = 1'b0;
                         BranchEQ  = 1'b0;
                         BranchNEQ = 1'b0;
                         MemtoReg = 1'b0;
                         ALUSrc   = 1'b0;
                         RegWrite = 1'b0;
                         ALUOP    = 2'b00;
                         exception = 1'b1;
                  end
             endcase
         end
endmodule
