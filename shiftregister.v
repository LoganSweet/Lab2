//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output [width-1:0]  parallelDataOut,    // Shift reg data contents
output              serialDataOut       // Positive edge synchronized
);

reg [width-1:0]      shiftregistermem;

always @(posedge clk) begin
    
if(parallelLoad ==1) begin  // do thisfor parallel data in
	serialDataOut <= parallelDataIn[8];
	serialDataOut <= parallelDataIn[7];
	serialDataOut <= parallelDataIn[6];
	serialDataOut <= parallelDataIn[5];
	serialDataOut <= parallelDataIn[4];
	serialDataOut <= parallelDataIn[3];
	serialDataOut <= parallelDataIn[2];
	serialDataOut <= parallelDataIn[1];
	serialDataOut <= parallelDataIn[0];
end

else begin    // do this for serial data in
	// serial stuff goes here 
end

end

endmodule

// general thoughts: make a loop that happens width # of times, 
// and then use the idea behind the behavioral flip flop below  
// so that you can pass things along as needed. 

// from the assignment: 
// " Each of these four behaviors can be implemented in one or two lines of behavioral Verilog. 
// You may want to look at Verilog's {} concatenate syntax for implementing the serial behavior. "



module flipflop
(
output reg  q,
input       d,
input       wrenable,
input       clk
);
    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end
endmodule
