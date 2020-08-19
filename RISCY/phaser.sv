`timescale 1ns/1ns
module phaser(CLK, RST, EN, PHASE); 
input EN,CLK,RST;
output reg [1:0] PHASE;

typedef enum reg [1:0] {FETCH, DECODE, EXEC,UPD} STATES;

always @(posedge CLK,negedge RST)

	if(!RST)
	PHASE <= 2'b00;
	else begin
	if(PHASE<=2'b11)
	PHASE <= PHASE +1'b1;
	else PHASE <= 2'b00;
	end
	endmodule
