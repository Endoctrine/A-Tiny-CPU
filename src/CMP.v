`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:07:19 11/04/2022 
// Design Name: 
// Module Name:    CMP 
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
module CMP(
    input [31:0] D1,
	 input [31:0] D2,
	 output equal,
	 output gtzero
    );
	 
	 assign equal = D1 == D2 ? 1 : 0;
	 assign gtzero = D1[31] == 1'b1 ? 0 : 1;

endmodule
