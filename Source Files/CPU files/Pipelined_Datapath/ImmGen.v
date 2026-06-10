//EXTRACTS THE IMMEDIATE FIELD FROM 32 BIT INSTRUCTION AND OUTPUTS ITS SIGN EXTENDED VERSION OF 64 BITS
/*INSTEAD OF GENERATING A SEPARATE IMMEDIATE BLOCK CONTROL SIGNAL FROM THE MAIN CONTROL UNIT....THE OPCODE
  ALREADY AVAILABLE IN THE INSTRUCTION IS USED TO DISTINGUISH BETWEEN I B AND S TYPES FOR IMMEDIATE GENERATION*/
module ImmGen(instruction,Immediate_SgnExt);
       input [31:0] instruction;
       output reg [63:0] Immediate_SgnExt; //64 bit sign extended immediate
       wire [6:0] opcode;

       assign opcode = instruction[6:0];
       always @(*) begin
        case (opcode)
            // I-Type immediate
            7'b0010011,
            7'b0000011:
                Immediate_SgnExt = {{52{instruction[31]}},instruction[31:20]};
            // S-Type immediate
            7'b0100011:
                Immediate_SgnExt = {{52{instruction[31]}},instruction[31:25],instruction[11:7]};
            // B-Type immediate
            7'b1100011:
                Immediate_SgnExt = {{51{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
            default:
                Immediate_SgnExt = 64'b0;
        endcase
    end
endmodule
