//DATA MEMORY DESIGN
module DataMemory(clk,MemRead,MemWrite,wd,Address,ReadData);

       input clk,MemRead,MemWrite;
       input [63:0] wd,Address;
       output [63:0] ReadData;

       reg [63:0] DataMem[1023:0]; //memory for 1024 64 bit data

       assign ReadData = (MemRead) ? DataMem[Address[12:3]] : 64'd0;

       always @(posedge clk) begin
              if (MemWrite)
                     DataMem[Address[12:3]] <= wd;
       end

endmodule
