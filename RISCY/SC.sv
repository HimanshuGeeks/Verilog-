`timescale 1ns/1ns
module SC(CLK,RST,ADDR,OPCODE,PHASE,ALU_FlAGS,IF,IR_EN,A_EN,B_EN,PDR_EN,PORT_RD,PORT_EN,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS);
input [6:0] ADDR;
input [3:0] OPCODE;
input [1:0] PHASE;
input ALU_FlAGS;
input IF;
input CLK;
input RST;

output reg IR_EN;
output reg A_EN;
output reg B_EN;
output reg PDR_EN;
output reg PORT_EN;
output reg PORT_RD;
output reg PC_EN;
output reg PC_LOAD;
output reg ALU_EN;
output reg ALU_OE;
output reg RAM_OE;
output reg RDR_EN;
output reg RAM_CS; 

/*will use a total of four cycles that is FETCH ,DECODE,EXECUTE,UPDATE*/
typedef enum reg [1:0] {FETCH, DECODE, EXEC,UPD} STATES;
//

//NOTE that these are local params 
//use the case statements when dealing with the opcodes
localparam LOAD=4'b0000,
	   STORE=4'b0001,
	   ADD=4'b0010,
	   SUB=4'b0011,
	   AND=4'b0100,
	   OR=4'b0101,
	   XOR=4'b0110,
	   NOT=4'b0111,
	   B=4'b1000,
 	   BZ=4'b1001,
	   BN=4'b1010,
	   BV=4'b1011,
	   BC=4'b1100;
reg DATA,BRANCH, STOREREG, LOADREG,SKIP; 
reg [31:0] INSTR; 
reg [31:0] MEM[63:0];
reg [6:0] PC,ADDR_;


initial 
 $readmemb("vectors.txt", MEM);
	

always@ (posedge CLK)
	case (PHASE) 
		FETCH: begin	
            INSTR <= MEM[ADDR]; //address is given as instruction to memory
			INSTR <= 	INSTR; //delay one cycle
			IR_EN <= 1'b1;
		      end

		DECODE: begin		
		  
		  case (OPCODE)
		  ADD | SUB | AND | OR | XOR | NOT:begin
				DATA <=1'b1;
		end
		 LOAD: begin
				LOADREG <= 1'b1;
		end				
	    STORE: begin
				STOREREG<= 1'b1;
		end
		B: begin		
			    SKIP <= 1'b1;
		end
		BZ | BN | BV | BC: begin
			 BRANCH <= 1'b1;
	   end
	   	
		default: LOADREG <= 1'b0;
		
	endcase
	end	 
		 
	   EXEC: begin
    	if (DATA) 
		begin
		  ALU_OE <= 1'b1;
		  ALU_EN <= 1'b1;
		
		end
		
		else if (LOAD)
		begin
		  A_EN   <= 1'b1;
		  B_EN   <= 1'b1;
		  PDR_EN <= 1'b1;
		  PORT_EN<= 1'b1;
		  RDR_EN <= 1'b1;
		  RAM_CS <= 1'b0;
		
		end
		
		else if (STORE)
		begin
		  ALU_OE <=  1'b1;
		  RAM_CS <= 1'b0;
		  RAM_OE <= 1'b1;
		 
	    end
	    
		else 
		begin
		  A_EN   <= 1'b1;
		  B_EN   <= 1'b1;
		  PDR_EN <= 1'b1;
		  PORT_EN<= 1'b1;
		  RDR_EN <= 1'b1;
		  RAM_CS <= 1'b0;		 
		end		
	 
	

 end
 
    UPD: begin

	PC_EN <= 1'b1; //enable the program counter by giving it a high or 1 
	
	if (BRANCH | SKIP )
	   PC_LOAD <= 1'b1; // enable paralled load of PC
    else 
        PC_LOAD <= 1'b0;
    
	if (PHASE == 2'b11) 
		if (PC_LOAD == 1'b0)
		  PC <= PC + 1;	  
		else 		
		  INSTR<=MEM[ADDR_];			 	
	else
	
		
 //Reset all the enables
    IR_EN   <= 1'b0;
    A_EN    <= 1'b0;
    B_EN    <= 1'b0;
   	PDR_EN  <= 1'b0;
    PORT_EN <= 1'b0;
    PORT_RD <= 1'b0;
    PC_EN   <= 1'b0;
   	PC_LOAD <= 1'b0;
    ALU_EN  <= 1'b0;
    ALU_OE  <= 1'b0;
    RAM_OE  <= 1'b0;
    RDR_EN  <= 1'b0;
    RAM_CS  <= 1'b1; 
    LOADREG<= 1'b0;
    DATA <= 1'b0;
    BRANCH <=1'b0;
    SKIP <= 1'b0;
    
 
 end


    default: IR_EN <= IR_EN;

endcase

endmodule




