`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:22:44 11/04/2022 
// Design Name: 
// Module Name:    ALU 
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

module ALU(
    input [31:0] A,
	 input [31:0] B,
	 input [3:0] alu_op,
	 input [31:0] instr,
	 output [31:0] R,
	 output [4:0] e_code
    );
	 
	 function [31:0] demo_function(
	     input [31:0] A,
		  input [31:0] B
	 );
	     reg [31:0] temp;
		  integer i = 0;
		  begin
		      temp = 0;
				for(i = 0; i < 32; i = i + 1) begin
				    if(A[i] == 1 && B[i] ==  1) begin
					     temp = temp + 1;
					 end
				end
				demo_function = temp;
		  end
	 endfunction
	 //1.Always attend bitwidth of function return value.
	 
	 function [31:0] demo_function_2(
	     input [31:0] A,
		  input [31:0] B
	 );
	     reg [31:0] counter = 0;// Attention! This is not initialization in "begin/end".
		  //^ It will accumulate each time.
		  integer i;
		  begin
		      for(i = 0; i < 32; i = i + 1) begin
				    if(A[i] == 1) begin
					     counter = counter + 1;
					 end
					 if(B[i] == 1) begin
					     counter = counter + 1;
					 end
				end
				demo_function_2 = counter;
		  end
	 
	 endfunction
	 
	 wire [31:0] less_than = $signed(A) < $signed(B);
	 wire [31:0] less_than_unsigned = A < B;
	 
    assign R = (alu_op == `alu_sub || alu_op == `alu_subu) ? A - B :
	            alu_op == `alu_or ? A | B : 
					alu_op == `alu_and ? A & B :
					alu_op == `alu_slt ? less_than :
					alu_op == `alu_sltu ? less_than_unsigned :
					(alu_op == `alu_add || alu_op == `alu_addu) ? A + B : 0; 
					
	 wire [32:0] add_temp = {A[31], A} + {B[31], B};
	 wire [32:0] sub_temp = {A[31], A} - {B[31], B};
    wire add_overflow = add_temp[31] != add_temp[32];
	 wire sub_overflow = sub_temp[31] != sub_temp[32];
    wire overflow = (alu_op == `alu_add && add_overflow) || (alu_op == `alu_sub && sub_overflow);
	 
	 wire [5:0] op = instr[31:26];
    wire [4:0] instr_rs = instr[25:21];
	 wire [4:0] instr_rt = instr[20:16];
	 wire [5:0] func = instr[5:0];
	 wire [15:0] imm16 = instr[15:0];
	 wire add = op == `special_op && func == `add_func;
	 wire addi = op == `addi_op;
	 wire sub = op == `special_op && func == `sub_func;
	 wire lb = op == `lb_op; wire lh = op == `lh_op; wire lw = op == `lw_op;
	 wire sb = op == `sb_op; wire sh = op == `sh_op; wire sw = op == `sw_op;

    wire cal = add || addi || sub;
	 wire load = lb || lh || lw;
	 wire store = sb || sh || sw;

	 assign e_code = (overflow && cal) ? `exc_ov : (overflow && load) ? `exc_adel : (overflow && store) ? `exc_ades : `exc_none;


endmodule