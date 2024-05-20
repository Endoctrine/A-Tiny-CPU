`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:33 11/04/2022 
// Design Name: 
// Module Name:    EXT 
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
`include "macros.v"

module EXT(
    input [15:0] Imm16,
	 input [1:0] ext_op,
	 output [31:0] E32
    );

    assign E32 = ext_op == `ext_sign ? {{16{Imm16[15]}}, Imm16} :
	              ext_op == `ext_lui ? {Imm16, {16{1'b0}}} :
					  {{16{1'b0}}, Imm16};

endmodule
