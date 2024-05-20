`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:32:31 11/04/2022 
// Design Name: 
// Module Name:    D 
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
module D(
    input [31:0] IR_i,
	 input [31:0] PC4_i,
	 input clk,
	 input reset,
	 input req,
	 input flush,
	 input enable,
	 output reg [31:0] IR_o,
	 output reg [31:0] PC4_o,
	 
	 input [4:0] e_code_i,
	 input bd_i,
	 output reg [4:0] e_code_o,
	 output reg bd_o
    );

	 always @(posedge clk) begin
	     if(reset) begin
		      PC4_o <= 'h3004;
		      IR_o <= 0;
				e_code_o <= 0;
				bd_o <= 0;
		  end
		  else if(req) begin
		      PC4_o <= 'h4184;
		      IR_o <= 0;
				e_code_o <= 0;
				bd_o <= 0;
		  end
		  else if(flush) begin
		      IR_o <= 0;
				e_code_o <= 0;
				bd_o <= 0;
		  end
		  else begin
		      if(enable) begin
				    IR_o <= IR_i;
		          PC4_o <= PC4_i;
					 e_code_o <= e_code_i;
					 bd_o <= bd_i; 
				end
		  end
	 end

endmodule
