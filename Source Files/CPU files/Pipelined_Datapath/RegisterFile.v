//CONSISTS OF ALL 32 REGISTERS OF THE RISC V EACH OF 64 BIT(RV64I)
module RegisterFile(clk,RegWrite,ra1,ra2,wa,wd,rd1,rd2,rst);
       input clk;
       input RegWrite;  //Input from MAIN CONTROL UNIT
       input rst;
       input [4:0] ra1,ra2,wa; //ra1=READ ADDRESS 1 ; ra2=READ ADDRESS 2; wa=WRITE ADDRESS
       input [63:0] wd;    //DATA TO BE WRITTEN
       output [63:0] rd1,rd2;  //64 bit DATA READ FROM REGISTERS CORRESPONDING TO ra1 AND ra2
       integer i;
       reg [63:0] Registers[31:0]; //32 64 bit registers
       always @(posedge clk) begin
           if (rst)begin
              for (i =0;i<32;i=i+1)
                  Registers[i] <= 64'b0;   //ALL Unused registers stay 0
           end
           else if (RegWrite && wa!=0)   //TO PREVENT WRITING IN x0 REGISTER
               Registers[wa] <= wd;
           else Registers[wa] <= 32'b0; 
       end      //WRITE OPERATION
       /*assign rd1 = (ra1 != 0)?Registers[ra1]:0;
       assign rd2 = (ra2 != 0)?Registers[ra2]:0;*/
       assign rd1 = (ra1 == 0) ? 64'd0 : 
                    ((ra1 == wa) && RegWrite) ? wd : Registers[ra1];
                    
       assign rd2 = (ra2 == 0) ? 64'd0 : 
                    ((ra2 == wa) && RegWrite) ? wd : Registers[ra2];
endmodule  
