`timescale 1ns/1ns
module counter(ADDR, CLK, EN, LOAD_EN, ADDR_OUT);

input CLK, EN, LOAD_EN;
input [4:0] ADDR;

output reg [4:0] ADDR_OUT;

  always @(posedge CLK)
  begin
    if(EN)  begin
    if (LOAD_EN)
    ADDR_OUT <= ADDR;
    else
    ADDR_OUT = ADDR_OUT + 5'b1;
    end
    else
    ADDR_OUT <= ADDR_OUT;
    end
endmodule
