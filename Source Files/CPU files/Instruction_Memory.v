//Hard Coded Instruction Memory....PC resets to 0 on completion
module Instruction_Memory(
    input  [63:0] PC,
    output [31:0] Instr
);
reg [31:0] mem [0:15];

/*initial begin
    // addi x1, x0, 10
    mem[0] = 32'h00A00093;
    // addi x2, x0, 20
    mem[1] = 32'h01400113;
    // add x3, x1, x2
    mem[2] = 32'h002081B3;
    // sub x4, x2, x1
    mem[3] = 32'h40110233;
    // and x5, x1, x2
    mem[4] = 32'h0020F2B3;
    // or x6, x1, x2
    mem[5] = 32'h0020E333;
    // xor x7, x1, x2
    mem[6] = 32'h0020C3B3;
    // infinite loop
    mem[7] = 32'h00000063;
end*/
initial begin

    // addi x1,x0,10
    mem[0] = 32'h00A00093;

    // addi x2,x0,20
    mem[1] = 32'h01400113;

    // add x3,x1,x2
    mem[2] = 32'h002081B3;

    // sub x4,x2,x1
    mem[3] = 32'h40110233;

    // and x5,x1,x2
    mem[4] = 32'h0020F2B3;

    // or x6,x1,x2
    mem[5] = 32'h0020E333;

    // sd x3,0(x0)
    mem[6] = 32'h00303023;

    // ld x7,0(x0)
    mem[7] = 32'h00003383;

    // beq x7,x3,+8
    // branch to mem[10] if equal
    mem[8] = 32'h00338463;

    // addi x8,x0,99
    // should be skipped
    mem[9] = 32'h06300413;

    // infinite loop
    mem[10] = 32'h00000063;

end
assign Instr = mem[PC[9:2]];

endmodule
