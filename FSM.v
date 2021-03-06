//------------------------------------------------------------------------
// Finite State Machine
//------------------------------------------------------------------------

`include "inputconditioner.v"
`include "shiftregister.v"

module FSM
(
	input 			clk, // internal
	input 			SCLKEdge, // positive edge of sclk from input cond #2
    input 	        ChipSelCond,   			// conditioned chip select from input cond #3
    input           shiftRegOutPZero,     // parallelDataOut[0], tells us to read or write
    output reg      MISO_BUFE,   	// controls "valve". 1 if we are reading, 0 otherwise. 
    output reg      DM_WE,   		// data memory write enable 
    output reg	    ADDR_WE,        	// write enable for address latch 
	output reg		SR_WE			// shift register write enable 

);

//reg counter;
parameter width = 8;
parameter counterwidth = 5; // Counter size, in bits, >= log2(waittime)   
reg[counterwidth-1:0] counter = 0;
reg WriteController; 
reg restart;

always @(posedge clk) begin

	if (SCLKEdge == 1) begin
		if (ChipSelCond == 0) begin
			counter <= counter + 1;
			if (counter == width-1) 
				ADDR_WE <= 1;
			else if (counter == width) begin
				ADDR_WE <= 0;
					if (shiftRegOutPZero == 0)  // if you are writing to datamemory
						WriteController <= 1; 
					else if (shiftRegOutPZero == 1) begin // if you are reading to datamemory
						SR_WE <= 1;
						MISO_BUFE <= 1;	
					end
			end
			else if (counter > width) begin
				ADDR_WE <= 0;
				if (counter == 4'b1111) begin
					counter <= 0;
					if (WriteController == 1) 
						DM_WE <= 1; 
				end
			end
			
		end
		
		else if (ChipSelCond == 1) begin
			counter <= 0;
			WriteController <= 0;
			DM_WE <= 0; 
			ADDR_WE <= 0; 
			SR_WE <= 0; 
			MISO_BUFE <= 0; // to get Z 
		end
	end


end
endmodule
