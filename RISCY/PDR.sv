`timescale 1ns/1ns

module PDR(CLK, RST, EN, DATA, D_OUT);
input CLK, RST, EN;
input DATA;
output reg D_OUT;
always @(posedge CLK or negedge RST)
begin
if(!RST)
D_OUT<= 1'b0;
else if(EN)
D_OUT <= DATA;
else
D_OUT <= D_OUT;
end
endmodule
