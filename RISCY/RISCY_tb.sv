`timescale 1ns/1ns 
module RISCY_tb();

reg CLK, RST, EN;
reg [6:0] ADDR;
reg [3:0] OPCODE;
wire [7:0] IO;
wire IR_EN;
wire A_EN;
wire B_EN;
wire PDR_EN;
wire PORT_EN;
wire PORT_RD;
wire PC_EN;
wire PC_LOAD;
wire ALU_EN;
wire ALU_OE;
wire RAM_OE;
wire RDR_EN;
wire RAM_CS;
wire PHASE;
wire SYNC;
SC UUT(CLK, EN, RST, ADDR, OPCODE, IR_EN, A_EN, B_EN,
PDR_EN, PORT_EN, PORT_RD, PC_EN, PC_LOAD, ALU_EN, ALU_OE, RAM_OE,
RDR_EN, RAM_CS);

RISCY UUT2 (CLK,RST,IO);
initial begin
$vcdpluson;
CLK= 1'b0; EN=1'b1; RST = 1'b1; ADDR = 7'b0000000; OPCODE= 4'b0000;
#10 EN=1'b1; RST = 1'b0;
#10 RST = 1'b1;
#15 ADDR = 7'b0000000; OPCODE= 4'b0000; //load

#15 ADDR = 7'b0000110; OPCODE= 4'b1100; //branch if C
#15 ADDR = 7'b1100000; OPCODE= 4'b0010; //ADD
#15 ADDR = 7'b0101000; OPCODE= 4'b0001; // STORE
#15 ADDR = 7'b1111000; OPCODE= 4'b1000; //jump
#50 $finish;
end
always
#1 CLK=!CLK;
endmodule
