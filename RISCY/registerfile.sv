/*****************************************************							
***											                                                                ***
***The objective of this lab was to create a ram that would                             ***
*** write certain values to the address bus on the rising edge.                         ***
***                                                                                     ***
***                                                                                    	***
***                        		        					                                        ***
******************************************************************************************/

`timescale 1ns/1ns
module registerfile(ADDR,WS,CS,DATA,OE);
//parameters used as widths and depths
parameter WIDTH = 32;
parameter DEPTH = 8;

input [WIDTH-1:0] ADDR; //this 32 bits
inout [DEPTH-1:0] DATA; //this is 8 bits
input CS; 
input WS; 
input OE;
reg[DEPTH-1:0] DATA_OUTY;
reg[DEPTH-1:0] DATA_INY;

//create the array
reg [DEPTH-1:0] MEM [0:(1<<WIDTH)-1];

always @(posedge WS)
begin
  if (!CS)
  if(!OE) 
  begin
    DATA_INY<=DATA;
    MEM[ADDR]<=DATA_INY;
	end
	else 
  begin
	DATA_INY<={DEPTH{1'bz}};
	DATA_OUTY<=MEM[ADDR];
	end
	else 
  begin
  DATA_INY<={DEPTH{1'bz}};
	DATA_OUTY<={DEPTH{1'bz}};
  end 
end

always @(ADDR,WS,CS,DATA,OE)
begin 
  if (!CS) 
  if (OE) 
  begin
	DATA_INY<={DEPTH{1'bz}};
	DATA_OUTY<=MEM[ADDR];
	end
	else 
  begin
	DATA_INY<= DATA;
	DATA_OUTY<={DEPTH{1'bz}};
	end
  else 
  begin
	DATA_INY<= {DEPTH{1'bz}};
	DATA_OUTY<={DEPTH{1'bz}};
 	end
end
 assign DATA = OE ? DATA_OUTY : {DEPTH{1'bz}};
endmodule
