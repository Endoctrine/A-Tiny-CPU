`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:38:17 11/04/2022 
// Design Name: 
// Module Name:    NPC 
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

module NPC(
    input [31:0] PC4,
	 input [25:0] Imm26,
	 input npc_op,
	 output [31:0] NextPC
    );
    wire [15:0] offset = Imm26 [15:0];
	 wire [31:0] npc_j = {PC4[31:28], Imm26, {2{1'b0}}};
	 wire [31:0] npc_b = PC4 + {{14{offset[15]}}, offset, {2{1'b0}}};
	 
	 assign NextPC = npc_op == `npc_j ? npc_j : npc_b;
endmodule
