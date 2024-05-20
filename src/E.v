`timescale 1ns / 1ps
`include "macros.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:13:48 11/04/2022 
// Design Name: 
// Module Name:    E 
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
module E(
    input [1:0] Tnew_i,
	 input [31:0] PC4_i,
	 input [4:0] A1_i,
	 input [4:0] A2_i,
	 input [4:0] A3_i,
	 input [4:0] A4_i, // for cp0
	 input [31:0] D1_i,
	 input [31:0] D2_i,
	 input [31:0] E32_i,
	 input [31:0] IR_i,
	 input clk,
	 input reset,
	 input req,
	 input stall,
	 output reg [1:0] Tnew_o,
	 output reg [31:0] PC4_o,
	 output reg [4:0] A1_o,
	 output reg [4:0] A2_o,
	 output reg [4:0] A3_o,
	 output reg [4:0] A4_o,
	 output reg [31:0] D1_o,
	 output reg [31:0] D2_o,
	 output reg [31:0] E32_o,
	 output reg [31:0] IR_o,
	 
	 input [3:0] alu_a_sel_i,
	 input [3:0] alu_b_sel_i,
	 input [3:0] alu_op_i,
	 input [3:0] mdu_op_i,
	 input mdu_r_sel_i,
	 input mdu_start_i,
	 input mdu_we_i,
	 input [3:0] f_d1_e_i,
	 input [3:0] f_d2_e_i,
	 input dm_we_i,
    input dm_re_i,
	 input [3:0] dm_write_mode_i,
	 input [1:0] dm_read_mode_i,
	 input [3:0] f_d2_m_i,
	 input [3:0] rf_wd_sel_i,
	 input [3:0] rf_wa_sel_i,
	 input rf_we_i,
	 
	 output reg [3:0] alu_a_sel_o,
	 output reg [3:0] alu_b_sel_o,
	 output reg [3:0] alu_op_o,
	 output reg [3:0] mdu_op_o,
	 output reg mdu_r_sel_o,
	 output reg mdu_start_o,
	 output reg mdu_we_o,
	 output reg [3:0] f_d1_e_o,
	 output reg [3:0] f_d2_e_o,
	 output reg [3:0] dm_write_mode_o,
	 output reg [1:0] dm_read_mode_o,
	 output reg dm_we_o,
	 output reg dm_re_o,
	 output reg [3:0] f_d2_m_o,
	 output reg [3:0] rf_wd_sel_o,
	 output reg [3:0] rf_wa_sel_o,
	 output reg rf_we_o,
	 
	 input [31:0] cp0_Addr_i,
	 input [31:0] cp0_DW_i,
	 input [4:0] e_code_i,
	 input bd_i,
	 input cp0_we_i,
	 input mtc0_flag_i,
	 input EXL_reset_i,
	 output reg [31:0] cp0_Addr_o,
	 output reg [31:0] cp0_DW_o,
	 output reg [4:0] e_code_o,
	 output reg bd_o,
	 output reg cp0_we_o,
	 output reg mtc0_flag_o,
	 output reg EXL_reset_o
    );
	 
	 always @(posedge clk) begin
	     if(reset) begin
		      PC4_o <= 'h3004;
		      A1_o <= 0;
				A2_o <= 0;
            A3_o <= 0;
				A4_o <= 0;
				D1_o <= 0;
				D2_o <= 0;
            Tnew_o <= 0;				
				alu_a_sel_o <= 0;
	         alu_b_sel_o <= 0;
	         alu_op_o <= 0;
				mdu_start_o <= 0;
				mdu_we_o <= 0;
	         f_d1_e_o <= 0;
	         f_d2_e_o <= 0;
				dm_read_mode_o <= `dm_rn;
	         dm_write_mode_o <= 0;
	         dm_we_o <= 0;
				dm_re_o <= 0;
	         f_d2_m_o <= 0;
	         rf_wd_sel_o <= 0;
	         rf_wa_sel_o <= 0;
	         rf_we_o <= 0;
				e_code_o <= 0;
				bd_o <= 0;
				cp0_we_o <= 0;
				IR_o <= 0;
				mtc0_flag_o <= 0;
				EXL_reset_o <= 0;
		  end
		  else if(req) begin
		      PC4_o <= 'h4184;
		      A1_o <= 0;
				A2_o <= 0;
            A3_o <= 0;
				A4_o <= 0;
				D1_o <= 0;
				D2_o <= 0;
            Tnew_o <= 0;				
				alu_a_sel_o <= 0;
	         alu_b_sel_o <= 0;
	         alu_op_o <= 0;
				mdu_start_o <= 0;
				mdu_we_o <= 0;
	         f_d1_e_o <= 0;
	         f_d2_e_o <= 0;
				dm_read_mode_o <= `dm_rn;
	         dm_write_mode_o <= 0;
	         dm_we_o <= 0;
				dm_re_o <= 0;
	         f_d2_m_o <= 0;
	         rf_wd_sel_o <= 0;
	         rf_wa_sel_o <= 0;
	         rf_we_o <= 0;
				e_code_o <= 0;
				bd_o <= 0;
				cp0_we_o <= 0;
				IR_o <= 0;
				mtc0_flag_o <= 0;
		  end
		  else if(stall) begin
		      PC4_o <= PC4_i;
		      A1_o <= 0;
				A2_o <= 0;
            A3_o <= 0;
				A4_o <= 0;
				D1_o <= 0;
				D2_o <= 0;
            Tnew_o <= 0;				
				alu_a_sel_o <= 0;
	         alu_b_sel_o <= 0;
	         alu_op_o <= 0;
				mdu_start_o <= 0;
				mdu_we_o <= 0;
	         f_d1_e_o <= 0;
	         f_d2_e_o <= 0;
				dm_read_mode_o <= `dm_rn;
	         dm_write_mode_o <= 0;
	         dm_we_o <= 0;
				dm_re_o <= 0;
	         f_d2_m_o <= 0;
	         rf_wd_sel_o <= 0;
	         rf_wa_sel_o <= 0;
	         rf_we_o <= 0;
				e_code_o <= 0;
				bd_o <= bd_i;
				cp0_we_o <= 0;
				IR_o <= 0;
				mtc0_flag_o <= 0;
				EXL_reset_o <= 0;
		  end
		  else begin
		      Tnew_o <= Tnew_i;
				PC4_o <= PC4_i;
				A1_o <= A1_i;
				A2_o <= A2_i;
				A3_o <= A3_i;
				A4_o <= A4_i;
				D1_o <= D1_i;
				D2_o <= D2_i;
				E32_o <= E32_i;
				IR_o <= IR_i;
				
				alu_a_sel_o <= alu_a_sel_i;
	         alu_b_sel_o <= alu_b_sel_i;
	         alu_op_o <= alu_op_i;
			   mdu_op_o <= mdu_op_i;
	         mdu_r_sel_o <= mdu_r_sel_i;
	         mdu_start_o <= mdu_start_i;
	         mdu_we_o <= mdu_we_i;
	         f_d1_e_o <= f_d1_e_i;
	         f_d2_e_o <= f_d2_e_i;
				dm_write_mode_o <= dm_write_mode_i;
				dm_read_mode_o <= dm_read_mode_i;
	         dm_we_o <= dm_we_i;
				dm_re_o <= dm_re_i;
	         f_d2_m_o <= f_d2_m_i;
	         rf_wd_sel_o <= rf_wd_sel_i;
	         rf_wa_sel_o <= rf_wa_sel_i;
	         rf_we_o <= rf_we_i;
				e_code_o <= e_code_i;
				bd_o <= bd_i;
				cp0_we_o <= cp0_we_i;
				mtc0_flag_o <= mtc0_flag_i;
				EXL_reset_o <= EXL_reset_i;
		  end
	 end


endmodule
