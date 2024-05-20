`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:30:09 11/04/2022 
// Design Name: 
// Module Name:    PC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PC(
    input [31:0] NextPC,
	 input clk,
	 input enable,
	 input reset,
	 output reg [31:0] PC
    );
	 
	 
    always @(posedge clk) begin
	     if(reset) begin
		      PC <= 'h3000;
		  end
	     else if(enable) begin
		      PC <= NextPC;
		  end
	 end

endmodule
