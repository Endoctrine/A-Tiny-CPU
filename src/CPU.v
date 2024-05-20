`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:42:18 11/06/2022 
// Design Name: 
// Module Name:    mips 
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
module CPU(
    input clk,
	 input reset,
	 
	 input [31:0] i_inst_rdata,
	 output [31:0] i_inst_addr,
	 
	 input [31:0] m_data_rdata,
	 output [31:0] m_data_addr,
	 output [31:0] m_data_wdata,
	 output [3:0] m_data_byteen,
	 output [31:0] m_inst_addr,
	 output [1:0] m_dm_read_mode,
	 output [3:0] m_dm_write_mode,
	 
	 output w_grf_we,
	 output [31:0] w_grf_addr,
	 output [31:0] w_grf_wdata,
	 output [31:0] w_inst_addr,
	 
	 input [4:0] DM_e_code,
	 input [5:0] inter,
	 
	 output [31:0] MPC
    );
	 
	 
	 
	 wire [31:0] tcD_instr;
	 wire tcCMP_equal;
	 wire tcCMP_gtzero;
	 wire tcMDU_busy;
	 wire tcE_rf_we;
	 wire [4:0] tcE_A3;
	 wire [1:0] tcE_Tnew;
	 wire [3:0] tcE_rf_wd_sel;
	 wire tcE_mtc0_flag;
	 wire tcM_rf_we;
	 wire [4:0] tcM_A3;
	 wire [1:0] tcM_Tnew;
	 wire [3:0] tcM_rf_wd_sel;
	 wire tcM_mtc0_flag;
	 wire tcW_rf_we;
	 wire [4:0] tcW_A3;
	 wire [1:0] tcW_Tnew;
	 wire [3:0] tcW_rf_wd_sel;
	 
	 wire stall;
	 wire [3:0] f_d1_d;
	 wire [3:0] f_d2_d;
	 wire [3:0] pc_nextpc_sel;
	 wire [3:0] rf_wa_sel;
	 wire flush_d;
	 wire npc_op;
	 wire [1:0] ext_op;
	 wire [3:0] alu_a_sel;
	 wire [3:0] alu_b_sel;
	 wire [3:0] alu_op;
	 wire [3:0] mdu_op;
	 wire mdu_r_sel;
	 wire mdu_start;
	 wire mdu_we;
	 wire [3:0] f_d1_e;
	 wire [3:0] f_d2_e;
	 wire [3:0] dm_write_mode;
	 wire [1:0] dm_read_mode;
	 wire dm_we;
	 wire [3:0] f_d2_m;
	 wire [3:0] rf_wd_sel;
	 wire rf_we;
	 wire [1:0] Tnew;
	 wire bd;
	 wire EXL_reset;
	 wire cp0_we;
	 wire [4:0] Ctrl_e_code;
	 wire mtc0_flag;
	 
    datapath datapath(
		.stall(stall), 
		.f_d1_d(f_d1_d), 
		.f_d2_d(f_d2_d), 
		.pc_nextpc_sel(pc_nextpc_sel), 
		.rf_wa_sel(rf_wa_sel), 
		.flush_d(flush_d),
		.npc_op(npc_op), 
		.ext_op(ext_op), 
		.alu_a_sel(alu_a_sel), 
		.alu_b_sel(alu_b_sel), 
		.alu_op(alu_op), 
		.mdu_op(mdu_op),
		.mdu_r_sel(mdu_r_sel),
		.mdu_start(mdu_start),
		.mdu_we(mdu_we),
		.f_d1_e(f_d1_e), 
		.f_d2_e(f_d2_e), 
		.dm_write_mode(dm_write_mode), 
		.dm_read_mode(dm_read_mode),
		.dm_we(dm_we), 
		.f_d2_m(f_d2_m), 
		.rf_wd_sel(rf_wd_sel), 
		.rf_we(rf_we), 
		.Tnew(Tnew), 
		.clk(clk), 
		.mips_rst(reset), 
		
		.tcD_instr(tcD_instr),
		.tcCMP_equal(tcCMP_equal),
		.tcCMP_gtzero(tcCMP_gtzero),
		.tcMDU_busy(tcMDU_busy),
		.tcE_rf_we(tcE_rf_we), 
		.tcE_A3(tcE_A3), 
		.tcE_Tnew(tcE_Tnew), 
		.tcE_rf_wd_sel(tcE_rf_wd_sel), 
		.tcE_mtc0_flag(tcE_mtc0_flag),
		.tcM_rf_we(tcM_rf_we), 
		.tcM_A3(tcM_A3), 
		.tcM_Tnew(tcM_Tnew), 
		.tcM_rf_wd_sel(tcM_rf_wd_sel),
      .tcM_mtc0_flag(tcM_mtc0_flag),		
		.tcW_rf_we(tcW_rf_we), 
		.tcW_A3(tcW_A3), 
		.tcW_Tnew(tcW_Tnew), 
		.tcW_rf_wd_sel(tcW_rf_wd_sel),
		
		
		.i_inst_rdata(i_inst_rdata),
		.i_inst_addr(i_inst_addr),
		.m_data_rdata(m_data_rdata),
		.m_data_addr(m_data_addr),
		.m_data_wdata(m_data_wdata),
		.m_data_byteen(m_data_byteen),
		.m_inst_addr(m_inst_addr),
		.m_dm_read_mode(m_dm_read_mode),
		.m_dm_write_mode(m_dm_write_mode),
		
		.w_grf_we(w_grf_we),
		.w_grf_addr(w_grf_addr),
		.w_grf_wdata(w_grf_wdata),
		.w_inst_addr(w_inst_addr),
		
		.DM_e_code(DM_e_code),
		.Ctrl_e_code(Ctrl_e_code),
		.bd(bd),
		.EXL_reset(EXL_reset),
		.cp0_we(cp0_we),
		.mtc0_flag(mtc0_flag),
		.inter(inter),
		
		.MPC(MPC)
	);
	
	Controller Controller(
		.instr(tcD_instr), 
		.CMP_equal(tcCMP_equal),
		.CMP_gtzero(tcCMP_gtzero),
		.MDU_busy(tcMDU_busy),
		.E_rf_we(tcE_rf_we), 
		.E_A3(tcE_A3), 
		.E_Tnew(tcE_Tnew), 
		.E_rf_wd_sel(tcE_rf_wd_sel), 
		.E_mtc0_flag(tcE_mtc0_flag),
		.M_rf_we(tcM_rf_we), 
		.M_A3(tcM_A3), 
		.M_Tnew(tcM_Tnew), 
		.M_rf_wd_sel(tcM_rf_wd_sel), 
		.M_mtc0_flag(tcM_mtc0_flag),
		.W_rf_we(tcW_rf_we), 
		.W_A3(tcW_A3), 
		.W_Tnew(tcW_Tnew), 
		.W_rf_wd_sel(tcW_rf_wd_sel), 
		
		.stall(stall), 
		.f_d1_d(f_d1_d), 
		.f_d2_d(f_d2_d), 
		.pc_nextpc_sel(pc_nextpc_sel), 
		.rf_wa_sel(rf_wa_sel), 
		.flush_d(flush_d),
		.npc_op(npc_op), 
		.ext_op(ext_op), 
		.alu_a_sel(alu_a_sel), 
		.alu_b_sel(alu_b_sel), 
		.alu_op(alu_op), 
		.mdu_op(mdu_op),
		.mdu_r_sel(mdu_r_sel),
		.mdu_start(mdu_start),
		.mdu_we(mdu_we),
		.f_d1_e(f_d1_e), 
		.f_d2_e(f_d2_e), 
		.dm_write_mode(dm_write_mode), 
		.dm_read_mode(dm_read_mode),
		.dm_we(dm_we), 
		.f_d2_m(f_d2_m), 
		.rf_wd_sel(rf_wd_sel), 
		.rf_we(rf_we), 
		.Tnew(Tnew),
		.e_code(Ctrl_e_code),
		.bd(bd),
		.EXL_reset(EXL_reset),
		.cp0_we(cp0_we),
		.mtc0_flag(mtc0_flag)
	);

endmodule
