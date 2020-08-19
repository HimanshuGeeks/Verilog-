`timescale 1ns/100ps 
module alu(CLK, EN, OE, OPCODE, A, B,ALU_OUT, CF, OF, SF, ZF); 
parameter WIDTH = 8; 
output reg [WIDTH - 1:0] ALU_OUT; 
output reg CF, OF, SF, ZF; 
input [3:0] OPCODE; 
input [WIDTH - 1:0] A, B; 
input CLK, EN, OE; 

//NOTE that these are local params 
localparam A_PLUS_B=4'b0010,
	   A_MINUS_B=4'b0011,
	   A_AND_B=4'b0100,
	   A_OR_B=4'b0101,
	   A_XOR_B=4'b0110,
	   NOT_A=4'b0111;
 
always @(posedge CLK)
begin
if(!EN) begin
ALU_OUT=4'b0000;
end

//
//begin

 case (OPCODE)

 A_PLUS_B: begin

   ALU_OUT = A + B;

   CF  = ALU_OUT[8];

   ZF  = (ALU_OUT == 8'b0);

  end

 A_MINUS_B: begin

   ALU_OUT = A - B;

   CF  = ALU_OUT[8];

   ZF  = (ALU_OUT == 8'b0);

  end



 A_AND_B: begin

   ALU_OUT = A & B;

   ZF  = (ALU_OUT == 8'b0);

  end

 A_OR_B:  begin

    ALU_OUT = A | B;

    ZF  = (ALU_OUT == 8'b0);

   end
   
A_XOR_B: begin
    ALU_OUT = A ^ B;

    ZF  = (ALU_OUT == 8'b0);

   end
NOT_A: begin   
    ALU_OUT = ~A;

    ZF  = (ALU_OUT == 8'b0);

   end
default: begin

   ALU_OUT = 8'b0;

   CF  = 1'b0;

   ZF = 1'b0;

   OF =1'b0;
     
   SF=1'b0;
    
   
  end

 endcase   
end
endmodule
