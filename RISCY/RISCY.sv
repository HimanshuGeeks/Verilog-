`timescale 1ns/1ns 
module RISCY (CLK,RST,IO);
input CLK,RST;
inout [7:0] IO;

//Sequence Controller steps through a fetch/decode/execute/update sequence. This requries four master clocks.
wire IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, EN, LOAD_EN;
wire ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS;
wire DATA,OE, CS,WS;
wire IFLAG;
wire SYC; //AASD to Phasor
wire PHASE; //phasor to SQ
wire [7:0] DATA_RAM_8; 
wire [7:0] DATA_MUX; 
wire [6:0] ADDR;
wire P_DIR_REG_TO_TRI;
wire [7:0] P_DATA_REG_TO_TRI;
wire [7:0] ROM_DATA;
wire [7:0] RAM_DATA;

wire [7:0] A, B;
wire [3:0] OPCODE;
wire OF, CF, SF, ZF;

counter mahcounter(ADDR[4:0], CLK, EN, LOAD_EN, PC_to_ROM);
rom  mahrom(ADDR, DATA, OE, CS);
register  regy (CLK, IR_EN, DATA_ROM_32, {OPCODE,IFLAG, ADDR, ROM_DATA});
registerfile myramy (ADDR,WS,CS,DATA_RAM_8,OE);
register regy2(CLK, RDR_EN, DATA_RAM_8, RAM_DATA);
PDR p1 (CLK, RST, PDR_EN, DATA_MUX[0], P_DIR_REG_to_TRI);
TSB t1(P_DATA_REG_TO_TRI, P_DIR_REG_TO_TRI, IO);
TSB t2(IO, PORT_RD, DATA_RAM_8);
scale_mux muxy(ROM_DATA, RAM_DATA, DATA_MUX, RAM_OE);
register r1(CLK, A_EN, DATA_MUX, A);
register r2(CLK, B_EN, DATA_MUX, B);
alu myalu(CLK, ALU_EN, ALU_OE, OPCODE, A, B, DATA_RAM_8, CF, OF, SF, ZF);
AASD a1 (RST, CLK, SYC);
phaser myphaser(CLK, SYC, EN, Phase);
SC sc1(CLK,RST,ADDR,OPCODE,PHASE,ALU_FlAGS,IF,IR_EN,A_EN,B_EN,PDR_EN,PORT_RD,PORT_EN,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS);
endmodule
