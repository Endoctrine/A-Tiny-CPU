`timescale 1ns / 1ps
`include "macros.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:25 11/04/2022 
// Design Name: 
// Module Name:    datapath 
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
module datapath(
    input stall,
    input [3:0] f_d1_d,
	 input [3:0] f_d2_d,
	 input [3:0] pc_nextpc_sel,
	 input flush_d,
	 input [3:0] rf_wa_sel,
	 input npc_op,
	 input [1:0] ext_op,
	 input [3:0] alu_a_sel,
	 input [3:0] alu_b_sel,
	 input [3:0] alu_op,
	 input [3:0] mdu_op,
	 input mdu_r_sel,
	 input mdu_start,
	 input mdu_we,
	 input [3:0] f_d1_e,
	 input [3:0] f_d2_e,
	 input [3:0] dm_write_mode,
	 input [1:0] dm_read_mode,
	 input dm_we,
	 input dm_re,
	 input [3:0] f_d2_m,
	 input [3:0] rf_wd_sel,
	 input rf_we,
	 input [1:0] Tnew,
	 
	 input clk,
	 input mips_rst,
	 
	 output [31:0] tcD_instr,
	 output tcCMP_equal,
	 output tcCMP_gtzero,
	 output tcMDU_busy,
	 output tcE_rf_we,
	 output [4:0] tcE_A3,
	 output [1:0] tcE_Tnew,
	 output [3:0] tcE_rf_wd_sel,
	 output tcE_mtc0_flag,
	 output tcM_rf_we,
	 output [4:0] tcM_A3,
	 output [1:0] tcM_Tnew,
	 output [3:0] tcM_rf_wd_sel,
	 output tcM_mtc0_flag,
	 output tcW_rf_we,
	 output [4:0] tcW_A3,
	 output [1:0] tcW_Tnew,
	 output [3:0] tcW_rf_wd_sel,
	 
	 input [31:0] i_inst_rdata,
	 output [31:0] i_inst_addr,
	 
	 input [31:0] m_data_rdata,
	 output [31:0] m_data_addr,
	 output [31:0] m_data_wdata,
	 output [3:0] m_data_byteen,
	 output [31:0] m_inst_addr,
	 output m_dm_re,
	 output [3:0] m_dm_write_mode,
	 output [1:0] m_dm_read_mode,
	 
	 output w_grf_we,
	 output [31:0] w_grf_addr,
	 output [31:0] w_grf_wdata,
	 output [31:0] w_inst_addr,
	 
	 input [4:0] Ctrl_e_code,
	 input [4:0] DM_e_code,
	 input bd,
	 input EXL_reset,
	 input cp0_we,
	 input [5:0] inter,
	 input mtc0_flag,
	 
	 output [31:0] MPC
	 
    );
	 assign tcD_instr = D_IR_o;
	 assign tcCMP_equal = CMP_equal;
	 assign tcCMP_gtzero = CMP_gtzero;
	 assign tcMDU_busy = MDU_busy;
	 assign tcE_rf_we = E_rf_we_o;
	 assign tcE_A3 = E_A3_o;
	 assign tcE_Tnew = E_Tnew_o;
	 assign tcE_rf_wd_sel = E_rf_wd_sel_o;
	 assign tcE_mtc0_flag = E_mtc0_flag_o;
	 assign tcM_rf_we = M_rf_we_o;
	 assign tcM_A3 = M_A3_o;
	 assign tcM_Tnew = M_Tnew_o;
	 assign tcM_rf_wd_sel = M_rf_wd_sel_o;
	 assign tcM_mtc0_flag = M_mtc0_flag_o;
	 assign tcW_rf_we = W_rf_we_o;
	 assign tcW_A3 = W_A3_o;
	 assign tcW_Tnew = W_Tnew_o;
	 assign tcW_rf_wd_sel = W_rf_wd_sel_o;
	 	 
	 assign w_grf_we = W_rf_we_o;
	 assign w_grf_addr = W_A3_o;
	 assign w_grf_wdata = MUXRFDW_out;
	 assign w_inst_addr = RF_PC;
	 
	 
    wire [31:0] ADD4_PC4;
    wire [31:0] ALU_R;
	 wire [31:0] MDU_R;
	 wire CMP_equal;
	 wire CMP_gtzero;
	 wire [31:0] D_IR_o;
	 wire [31:0] D_PC4_o;
	 wire [31:0] DM_D;
	 wire [1:0] E_Tnew_o;
	 wire [31:0] E_PC4_o;
	 wire [4:0] E_A1_o;
	 wire [4:0] E_A2_o;
	 wire [4:0] E_A3_o;
	 wire [4:0] E_A4_o;
	 wire [31:0] E_D1_o;
	 wire [31:0] E_D2_o;
	 wire [31:0] E_E32_o;
	 wire [31:0] E_IR_o;
	 wire [31:0] EXT_E32;
	 wire [31:0] IM_IR;
	 wire [1:0] M_Tnew_o;
	 wire [31:0] M_D2_o;
	 wire [4:0] M_A2_o;
	 wire [4:0] M_A3_o;
	 wire [4:0] M_A4_o;
	 wire [31:0] M_ALUR_o;
	 wire [31:0] M_MDUR_o;
	 wire [31:0] M_PC4_o;
	 wire [31:0] M_E32_o;
	 wire [31:0] M_PC8_o;
	 wire [31:0] NPC_NextPC;
	 wire [31:0] PC_PC;
	 wire [31:0] RF_RD1;
	 wire [31:0] RF_RD2;
	 wire [1:0] W_Tnew_o;
	 wire [4:0] W_A3_o;
	 wire [31:0] W_ALUR_o;
	 wire [31:0] W_MDUR_o;
	 wire [31:0] W_PC4_o;
	 wire [31:0] W_E32_o;
	 wire [31:0] W_PC8_o;
	 wire [31:0] W_DR_o;
	 wire [31:0] W_CP0_RD_o;
	 
	 wire [31:0] CP0_RD;
	 wire [31:0] CP0_EPC;
	 wire CP0_req;
	 
	 wire [4:0] D_e_code_o;
	 wire D_bd_o;
	 
	 wire [3:0] E_alu_a_sel_o;
	 wire [3:0] E_alu_b_sel_o;
	 wire [3:0] E_alu_op_o;
	 wire	[3:0] E_mdu_op_o;
	 wire E_mdu_r_sel_o;
	 wire E_mdu_start_o;
	 wire E_mdu_we_o;
	 wire [3:0] E_f_d1_e_o;
	 wire [3:0] E_f_d2_e_o;
	 wire [3:0] E_dm_write_mode_o;
	 wire [1:0] E_dm_read_mode_o;
	 wire E_dm_we_o;
	 wire E_dm_re_o;
	 wire [3:0] E_f_d2_m_o;
	 wire [3:0] E_rf_wd_sel_o;
	 wire [3:0] E_rf_wa_sel_o;
	 wire E_rf_we_o;
	 wire [4:0] E_e_code_o;
	 wire E_bd_o;
	 wire E_cp0_we_o;
	 wire E_mtc0_flag_o;
	 wire E_EXL_reset_o;
	 
	 wire ALU_zero;
	 wire MDU_busy;
	 
	 wire [3:0] M_dm_write_mode_o;
	 wire [1:0] M_dm_read_mode_o;
	 wire M_dm_we_o;
	 wire M_dm_re_o;
	 wire [3:0] M_f_d2_m_o;
	 wire [3:0] M_rf_wa_sel_o;
	 wire M_rf_we_o;
	 wire [3:0] M_rf_wd_sel_o;
	 wire [4:0] M_e_code_o;
	 wire M_bd_o;
	 wire M_cp0_we_o;
	 wire M_mtc0_flag_o;
	 wire M_EXL_reset_o;
	 
	 wire [3:0] W_rf_wa_sel_o;
	 wire [3:0] W_rf_wd_sel_o;
	 wire W_rf_we_o;
	 
	 wire [25:0] D_IR_Imm26 = D_IR_o [25:0];
	 wire [15:0] D_IR_Imm16 = D_IR_o [15:0];
	 wire [4:0] D_IR_rs = D_IR_o [25:21];
	 wire [4:0] D_IR_rd = D_IR_o [15:11];
	 wire [4:0] D_IR_rt = D_IR_o [20:16];
	 
	 
	 wire [31:0] MUXPC_out;
	 wire [31:0] MUXEA3_out;
	 wire [31:0] MUXALUA_out;
	 wire [31:0] MUXALUB_out;
	 wire [31:0] MUXRFA3_out;
	 wire [31:0] MUXRFDW_out;
	 
	 wire [31:0] MFD1D_out;
	 wire [31:0] MFD2D_out;
	 wire [31:0] MFD1E_out;
	 wire [31:0] MFD2E_out;
	 wire [31:0] MFD2M_out;
	 
	 MUX_4 MFD1D(
	     .a(RF_RD1),
		  .b(MUXRFDW_out),
		  .c(M_ALUR_o),
		  .d(M_MDUR_o),
		  .e(M_E32_o),
		  .f(M_PC8_o),
		  .g(E_E32_o),
		  .sel(f_d1_d),
		  .out(MFD1D_out)
	 );
	 
	 MUX_4 MFD2D(
	     .a(RF_RD2),
		  .b(MUXRFDW_out),
		  .c(M_ALUR_o),
		  .d(M_MDUR_o),
		  .e(M_E32_o),
		  .f(M_PC8_o),
		  .g(E_E32_o),
		  .sel(f_d2_d),
		  .out(MFD2D_out)
	 );
	 
	 MUX_4 MFD1E(
	     .a(E_D1_o),
		  .b(MUXRFDW_out),
		  .c(M_ALUR_o),
		  .d(M_MDUR_o),
		  .e(M_E32_o),
		  .f(M_PC8_o),
		  .sel(E_f_d1_e_o),
		  .out(MFD1E_out)
	 );
	 
	 MUX_4 MFD2E(
	     .a(E_D2_o),
		  .b(MUXRFDW_out),
		  .c(M_ALUR_o),
		  .d(M_MDUR_o),
		  .e(M_E32_o),
		  .f(M_PC8_o),
		  .sel(E_f_d2_e_o),
		  .out(MFD2E_out)
	 );
	 
	 MUX_4 MFD2M(
	     .a(M_D2_o),
		  .b(MUXRFDW_out),
		  .sel(M_f_d2_m_o),
		  .out(MFD2M_out)
	 );
	 
	 MUX_4 MUXPC(
	     .a(ADD4_PC4),
		  .b(NPC_NextPC),
		  .c(MFD1D_out),
		  .d(CP0_EPC),
		  .sel(pc_nextpc_sel),
		  .out(MUXPC_out)
	 );
	 	 
	 parameter RA = 31;
	 
	 MUX_4 MUXEA3(
	     .a(D_IR_rd),
		  .b(D_IR_rt),
		  .c(RA),
		  .sel(rf_wa_sel),
		  .out(MUXEA3_out)
	 );
	 
	 MUX_4 MUXALUA(
	     .a(MFD1E_out),
		  .b(E_PC4_o),
		  .sel(E_alu_a_sel_o),
		  .out(MUXALUA_out)
	 );
	 
	 parameter FOUR = 4;
	 
	 MUX_4 MUXALUB(
	     .a(MFD2E_out),
		  .b(E_E32_o),
		  .c(FOUR),
		  .sel(E_alu_b_sel_o),
		  .out(MUXALUB_out)
	 );
	
	 MUX_4 MUXRFDW(
	     .a(W_ALUR_o),
		  .b(W_E32_o),
		  .c(W_DR_o),		  
		  .d(W_PC8_o),
		  .e(W_MDUR_o),
		  .f(W_CP0_RD_o),
		  .sel(W_rf_wd_sel_o),
		  .out(MUXRFDW_out)
	 );

	 wire stall_n = ~stall;
	 
	 wire [31:0] PC_NextPC = CP0_req ? `req_addr : MUXPC_out;
	 
	 
	 PC PC(
	     .NextPC(PC_NextPC),
		  .reset(mips_rst),
		  .clk(clk),
		  .enable(stall_n | CP0_req),
		  .PC(PC_PC)
	 );
	 
	 /*exc_optimizor*////////////////////
	 wire [4:0] ALU_e_code;
	 wire [4:0] IM_e_code = i_inst_addr[1:0] || i_inst_addr > 32'h6fff || i_inst_addr < 32'h3000 ? `exc_adel : `exc_none;
	 wire [4:0] f_e_code = IM_e_code;
	 wire [4:0] d_e_code = D_e_code_o ? D_e_code_o : Ctrl_e_code;
	 wire [4:0] e_e_code = E_e_code_o ? E_e_code_o : ALU_e_code;
	 wire [4:0] m_e_code = M_e_code_o ? M_e_code_o : DM_e_code;
	 ////////////////////////////////////
	 
	 /////////////////////////////
	 /*IM*////////////////////////
	 /////////////////////////////
	 assign i_inst_addr = PC_PC;
	 assign IM_IR = i_inst_rdata;
	 /////////////////////////////
	 
	 ADD4 ADD4(
	     .PC(PC_PC),
		  .PC4(ADD4_PC4)
	 );
	 
	 
	 D D(
	     .IR_i(IM_e_code ? 0 : IM_IR),
		  .PC4_i(ADD4_PC4),
		  .e_code_i(f_e_code),
		  .bd_i(bd),
		  .clk(clk),
		  .reset(mips_rst),
		  .req(CP0_req),
		  .flush(flush_d),
		  .enable(stall_n),
		  .IR_o(D_IR_o),
		  .PC4_o(D_PC4_o),
		  .e_code_o(D_e_code_o),
		  .bd_o(D_bd_o)
	 );
	 
	 NPC NPC(
	     .PC4(D_PC4_o),
		  .Imm26(D_IR_Imm26),
		  .npc_op(npc_op),
		  .NextPC(NPC_NextPC)
	 );
	 
	 wire [31:0] RF_PC = W_PC4_o - 4;
	 
	 RF RF(
	     .A1(D_IR_rs),
		  .A2(D_IR_rt),
		  .A3(W_A3_o),
		  .DW(MUXRFDW_out),
		  .PC(RF_PC),
		  .clk(clk),
		  .enable(W_rf_we_o),
		  .reset(mips_rst),
		  .RD1(RF_RD1),
		  .RD2(RF_RD2)
	 );
	 
	 CMP CMP(
	     .D1(MFD1D_out),
		  .D2(MFD2D_out),
		  .equal(CMP_equal),
		  .gtzero(CMP_gtzero)
	 );
	 
	 EXT EXT(
	     .Imm16(D_IR_Imm16),
		  .ext_op(ext_op),
		  .E32(EXT_E32)
	 );
	 
	 
	 E E(
		.Tnew_i(Tnew), 
		.PC4_i(D_PC4_o), 
		.A1_i(), 
		.A2_i(), 
		.A3_i(MUXEA3_out), 
		.A4_i(D_IR_rd), 
		.D1_i(MFD1D_out), 
		.D2_i(MFD2D_out), 
		.E32_i(EXT_E32), 
		.clk(clk), 
		.reset(mips_rst), 
		.req(CP0_req),
		.stall(stall),
		.Tnew_o(E_Tnew_o), 
		.PC4_o(E_PC4_o), 
		.A1_o(), 
		.A2_o(), 
		.A3_o(E_A3_o), 
		.A4_o(E_A4_o), 
		.D1_o(E_D1_o), 
		.D2_o(E_D2_o), 
		.E32_o(E_E32_o),
		.IR_i(D_IR_o),
		.IR_o(E_IR_o),
      		
		.alu_a_sel_i(alu_a_sel), 
		.alu_b_sel_i(alu_b_sel), 
		.alu_op_i(alu_op), 
		.mdu_op_i(mdu_op),
		.mdu_r_sel_i(mdu_r_sel),
		.mdu_start_i(mdu_start),
		.mdu_we_i(mdu_we),
		.f_d1_e_i(f_d1_e), 
		.f_d2_e_i(f_d2_e), 
		.dm_we_i(dm_we), 
		.dm_re_i(dm_re), 
		.dm_write_mode_i(dm_write_mode), 
		.dm_read_mode_i(dm_read_mode),
		.f_d2_m_i(f_d2_m), 
		.rf_wd_sel_i(rf_wd_sel), 
		.rf_wa_sel_i(rf_wa_sel), 
		.rf_we_i(rf_we), 
		.e_code_i(d_e_code),
		.bd_i(D_bd_o),
		.cp0_we_i(cp0_we),
		.mtc0_flag_i(mtc0_flag),
		.EXL_reset_i(EXL_reset),
		
		.alu_a_sel_o(E_alu_a_sel_o), 
		.alu_b_sel_o(E_alu_b_sel_o), 
		.alu_op_o(E_alu_op_o), 
		.mdu_op_o(E_mdu_op_o),
		.mdu_r_sel_o(E_mdu_r_sel_o),
		.mdu_start_o(E_mdu_start_o),
		.mdu_we_o(E_mdu_we_o),
		.f_d1_e_o(E_f_d1_e_o), 
		.f_d2_e_o(E_f_d2_e_o), 
		.dm_write_mode_o(E_dm_write_mode_o), 
		.dm_read_mode_o(E_dm_read_mode_o),
		.dm_we_o(E_dm_we_o),
      .dm_re_o(E_dm_re_o),		
		.f_d2_m_o(E_f_d2_m_o), 
		.rf_wd_sel_o(E_rf_wd_sel_o), 
		.rf_wa_sel_o(E_rf_wa_sel_o), 
		.rf_we_o(E_rf_we_o),
		.e_code_o(E_e_code_o),
		.bd_o(E_bd_o),
		.cp0_we_o(E_cp0_we_o),
		.mtc0_flag_o(E_mtc0_flag_o),
		.EXL_reset_o(E_EXL_reset_o)
	);
	
	ALU ALU(
	    .A(MUXALUA_out),
		 .B(MUXALUB_out),
		 .alu_op(E_alu_op_o),
		 .instr(E_IR_o),
		 .R(ALU_R),
		 .e_code(ALU_e_code)
	);
	
	MDU MDU(
	    .A(MFD1E_out),
		 .B(MFD2E_out),
		 .mdu_op(E_mdu_op_o),
		 .r_sel(E_mdu_r_sel_o),
		 .start(E_mdu_start_o & !CP0_req),
		 .we(E_mdu_we_o & !CP0_req),
		 .reset(mips_rst),
		 .clk(clk),
	    .R(MDU_R),
		 .busy(MDU_busy)
	);
	
	wire [1:0] M_Tnew_i = E_Tnew_o == 0 ? 0 : E_Tnew_o - 1;
	M M(
		.Tnew_i(M_Tnew_i),
		.D2_i(MFD2E_out),
		.A2_i(), 
		.A3_i(E_A3_o), 
		.A4_i(E_A4_o), 
		.ALUR_i(ALU_R), 
		.MDUR_i(MDU_R),
		.PC4_i(E_PC4_o), 
		.E32_i(E_E32_o), 
		.PC8_i(ALU_R),		
		.clk(clk), 
		.reset(mips_rst), 
		.req(CP0_req),
		.Tnew_o(M_Tnew_o), 
		.D2_o(M_D2_o), 
		.A2_o(), 
		.A3_o(M_A3_o), 
		.A4_o(M_A4_o), 
		.ALUR_o(M_ALUR_o), 
		.MDUR_o(M_MDUR_o),
		.PC4_o(M_PC4_o), 
		.E32_o(M_E32_o), 
		.PC8_o(M_PC8_o),
		
		.dm_write_mode_i(E_dm_write_mode_o), 
		.dm_read_mode_i(E_dm_read_mode_o),
		.dm_we_i(E_dm_we_o), 
		.dm_re_i(E_dm_re_o), 
		.f_d2_m_i(E_f_d2_m_o), 
		.rf_wa_sel_i(E_rf_wa_sel_o), 
		.rf_we_i(E_rf_we_o), 
		.rf_wd_sel_i(E_rf_wd_sel_o),
		.e_code_i(e_e_code),
		.bd_i(E_bd_o),
		.cp0_we_i(E_cp0_we_o),
		.mtc0_flag_i(E_mtc0_flag_o),
		.EXL_reset_i(E_EXL_reset_o),
		
		.dm_write_mode_o(M_dm_write_mode_o), 
		.dm_read_mode_o(M_dm_read_mode_o),
		.dm_we_o(M_dm_we_o), 
		.dm_re_o(M_dm_re_o), 
		.f_d2_m_o(M_f_d2_m_o), 
		.rf_wa_sel_o(M_rf_wa_sel_o), 
		.rf_we_o(M_rf_we_o), 
		.rf_wd_sel_o(M_rf_wd_sel_o),
		.e_code_o(M_e_code_o),
		.bd_o(M_bd_o),
		.cp0_we_o(M_cp0_we_o),
		.mtc0_flag_o(M_mtc0_flag_o),
		.EXL_reset_o(M_EXL_reset_o)
	);
	
	////////////////////////////////////////////////////
	/*DM*///////////////////////////////////////////////
	////////////////////////////////////////////////////
	wire [31:0] M_PC = M_PC4_o - 4; 
	
	wire [7:0] m_data_rdata_byte = m_data_addr[1:0] == 0 ? m_data_rdata[7:0] :
	                               m_data_addr[1:0] == 1 ? m_data_rdata[15:8] :
											 m_data_addr[1:0] == 2 ? m_data_rdata[23:16] : m_data_rdata[31:24];

	wire [15:0] m_data_rdata_half = m_data_addr[1] == 0 ? m_data_rdata[15:0] : m_data_rdata[31:16];
		
	assign DM_D = M_dm_read_mode_o == `dm_rb ? {{24{m_data_rdata_byte[7]}}, m_data_rdata_byte} : 
	              M_dm_read_mode_o == `dm_rh ? {{16{m_data_rdata_half[15]}}, m_data_rdata_half} : 
					  m_data_rdata;
	assign m_data_addr = M_ALUR_o; // align in tb.
	assign m_data_wdata = MFD2M_out << (m_data_addr[1:0] * 8);
	assign m_data_byteen = M_dm_write_mode_o == `dm_wn | CP0_req ? 0 : 
	                       M_dm_write_mode_o == `dm_wb ? `dm_wb << m_data_addr[1:0] : 
	                       M_dm_write_mode_o == `dm_wh ? `dm_wh << m_data_addr[1:0] : `dm_ww;
	assign m_dm_re = M_dm_re_o;
	assign m_dm_write_mode = M_dm_write_mode_o;
	assign m_inst_addr = M_PC;
	assign m_dm_read_mode = M_dm_read_mode_o;
	////////////////////////////////////////////////////
	
	CP0 CP0(
	    .Addr(M_A4_o),
		 .DW(MFD2M_out),
		 .VPC(M_PC),
		 
		 .bd(M_bd_o),
		 .e_code(m_e_code),
		 .inter(inter),
		 
		 .EXL_reset(M_EXL_reset_o),
		 .clk(clk),
		 .we(M_cp0_we_o),
		 .reset(mips_rst),
		 
		 .MPC(MPC),
		 .RD(CP0_RD),
		 .EPC(CP0_EPC),
		 .req(CP0_req)
	);
	
	wire [1:0] W_Tnew_i = M_Tnew_o == 0 ? 0 : M_Tnew_o - 1;
	wire W_reset = mips_rst | CP0_req;
	
	W W(
		.Tnew_i(W_Tnew_i), 
		.A3_i(M_A3_o), 
		.ALUR_i(M_ALUR_o), 
		.MDUR_i(M_MDUR_o),
		.PC4_i(M_PC4_o), 
		.E32_i(M_E32_o), 
		.PC8_i(M_PC8_o), 
		.DR_i(DM_D), 
		.CP0_RD_i(CP0_RD),
		.clk(clk), 
		.reset(W_reset), 
		.Tnew_o(W_Tnew_o), 
		.A3_o(W_A3_o), 
		.ALUR_o(W_ALUR_o), 
		.MDUR_o(W_MDUR_o),
		.PC4_o(W_PC4_o), 
		.E32_o(W_E32_o), 
		.PC8_o(W_PC8_o), 
		.DR_o(W_DR_o),
		.CP0_RD_o(W_CP0_RD_o),
		
		.rf_wa_sel_i(M_rf_wa_sel_o), 
		.rf_wd_sel_i(M_rf_wd_sel_o), 
		.rf_we_i(M_rf_we_o), 
		.rf_wa_sel_o(W_rf_wa_sel_o), 
		.rf_wd_sel_o(W_rf_wd_sel_o), 
		.rf_we_o(W_rf_we_o)
	);
	
	

endmodule
