`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:57:08 11/04/2022 
// Design Name: 
// Module Name:    RF 
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
module RF(
    input [4:0] A1,
	 input [4:0] A2,
	 input [4:0] A3,
	 input [31:0] DW,
	 input [31:0] PC,
	 input clk,
	 input enable,
	 input reset,
	 output [31:0] RD1,
	 output [31:0] RD2
    );
	 
	 reg [31:0] register [0:31];
	 integer i;
	 always @(posedge clk) begin
	     if(reset) begin
		      for(i = 0; i < 32; i = i + 1) begin
		         register[i] <= 0;
            end
		  end
		  else begin
		      if(enable) begin
				    if(A3 != 0) begin
					     register[A3] <= DW;
					 end else begin
					     register[A3] <= 0;
					 end
				end
		  end
	 end

    assign RD1 = register[A1];
	 assign RD2 = register[A2];

endmodule
