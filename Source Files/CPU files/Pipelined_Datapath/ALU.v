//OPERATIONS SUPPORTED: ADD,SUB,AND,OR,XOR,SLL,SRL 
module ALU(a,b,c,cpu_shutdown_button,z,alucs);
      input [63:0] a,b; //Operands
      input cpu_shutdown_button;
      input  [3:0] alucs; //4bit control lines
      output reg [63:0] c;   //Output
      output reg z ; //Zero Detection(high if zero detected)
      always @(*) begin
          if (cpu_shutdown_button)begin
              c = 64'b0;
              z = 1'b0;
          end
          else begin
              case(alucs)
                   4'b0000: c = a+b; //ADDITION
                   4'b0001: c = a+(~b+1); //SUBTRACTION
                   4'b0010: c = a&b; //AND
                   4'b0011: c = a|b; //OR
                   4'b0100: c = a^b; //XOR
                   4'b0101: c = a << b[5:0]; //SLL
                   4'b0110: c = a >> b[5:0];//SRL
                   default:
                         c = 64'b0;
              endcase
             z = (c == 64'd0) ? 1'b1 : 1'b0;  //ZERO DETECTION UNIT           
          end
     end
endmodule
