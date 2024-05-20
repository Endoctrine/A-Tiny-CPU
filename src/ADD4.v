`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:28:41 11/04/2022 
// Design Name: 
// Module Name:    ADD4 
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
module ADD4(
    input [31:0] PC,
	 output [31:0] PC4
    );
    assign PC4 = PC + 4;

endmodule
