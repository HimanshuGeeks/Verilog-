/*
*******************************************************************************************									
***							                                ***
***The objective of this lab was to create a rom that would be similar to ram           ***
*** however this module only reads values                                               ***
***                                                                                     ***
***                                                                                    	***
***                        		        				        ***
******************************************************************************************/ 
module rom(ADDR, DATA, OE, CS);
//Parameter Declaration
	parameter WIDTH = 32;
	parameter DEPTH = 32;
//Port Declaration
	input [WIDTH-1:0] ADDR;
	input OE, CS;
	output reg [DEPTH-1:0] DATA;

//Instantiate 
	reg [DEPTH-1:0] registers [2**DEPTH-1:0];

//Behavioral Code
	always @(OE, CS, ADDR)
	begin
		if (!CS) //If CS is active
			if (OE) //Output enabled
				DATA <= registers[ADDR];
			else	//Output not enabled
				DATA <= {DEPTH{1'bz}};
		else
			DATA <= {DEPTH{1'bz}};
	end
endmodule
