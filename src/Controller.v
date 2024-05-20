`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:14 11/06/2022 
// Design Name: 
// Module Name:    Controller 
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

module Controller(
    input [31:0] instr,
	 input CMP_equal,
	 input CMP_gtzero,
	 input MDU_busy,
	 input E_rf_we,
	 input [4:0] E_A3,
	 input [1:0] E_Tnew,
	 input [3:0] E_rf_wd_sel,
	 input E_mtc0_flag,
	 input M_rf_we,
	 input [4:0] M_A3,
	 input [1:0] M_Tnew,
	 input [3:0] M_rf_wd_sel,
	 input M_mtc0_flag,
	 input W_rf_we,
	 input [4:0] W_A3,
	 input [1:0] W_Tnew,
	 input [3:0] W_rf_wd_sel,
	 
	 output stall,
	 output [3:0] f_d1_d,
	 output [3:0] f_d2_d,
	 output [3:0] pc_nextpc_sel,
	 output flush_d,
	 output [3:0] rf_wa_sel,
	 output npc_op,
	 output [1:0] ext_op,
	 output [3:0] alu_a_sel,
	 output [3:0] alu_b_sel,
	 output [3:0] alu_op,
	 output [3:0] mdu_op,
	 output mdu_r_sel,
	 output mdu_start,
	 output mdu_we,
	 output [3:0] f_d1_e,
	 output [3:0] f_d2_e,
	 output [3:0] dm_write_mode, // m_data_byteen
	 output [1:0] dm_read_mode,
	 output dm_we,
	 output [3:0] f_d2_m,
	 output [3:0] rf_wd_sel,
	 output rf_we,
	 output [1:0] Tnew,
	 
	 output bd,
	 output [4:0] e_code,
	 output EXL_reset,
	 output cp0_we,
	 output mtc0_flag
	 
    );
	 
	 wire [5:0] op = instr[31:26];
    wire [4:0] instr_rs = instr[25:21];
	 wire [4:0] instr_rt = instr[20:16];
	 wire [5:0] func = instr[5:0];
	 wire [15:0] imm16 = instr[15:0];
	 
	 wire add = op == `special_op && func == `add_func; wire addu = op == `special_op && func == `addu_func;
	 wire sub = op == `special_op && func == `sub_func; wire subu = op == `special_op && func == `subu_func;
	 wire _and = op == `special_op && func == `and_func; wire _or = op == `special_op && func == `or_func;
	 wire slt = op == `special_op && func ==`slt_func; wire sltu = op == `special_op && func == `sltu_func;

	 wire addi = op == `addi_op; wire addiu = op == `addiu_op;
	 wire andi = op == `andi_op; wire ori = op == `ori_op;
	 
	 wire lb = op == `lb_op; wire lh = op == `lh_op; wire lw = op == `lw_op;
	 wire sb = op == `sb_op; wire sh = op == `sh_op; wire sw = op == `sw_op;
	 
	 wire mult = op == `special_op && func == `mult_func; wire multu = op == `special_op && func == `multu_func;
	 wire div = op == `special_op && func == `div_func; wire divu = op == `special_op && func == `divu_func;
	 
	 wire mfhi = op == `special_op && func == `mfhi_func; wire mflo = op == `special_op && func == `mflo_func;
	 
	 wire mthi = op == `special_op && func == `mthi_func; wire mtlo = op == `special_op && func == `mtlo_func;
	 
	 wire beq = op == `beq_op; wire bne = op == `bne_op;
	 wire jal = op == `jal_op; wire j = op == `j_op;
	 
	 wire jr = op == `special_op && func == `jr_func;
	 
	 wire lui = op == `lui_op;
	 
	 wire bgezall = op == `regimm_op && instr_rt == `bgezall;
	 
	 wire nop = op == `special_op && func == `nop_func;
	 wire syscall = op == `special_op && func == `syscall_func;
	 wire mfc0 = op == `cp0_op && instr_rs == `mfc0 && instr[10:0] == 0;
	 wire mtc0 = op == `cp0_op && instr_rs == `mtc0 && instr[10:0] == 0;
	 wire eret = instr == `eret;
	 
	 wire beq_p = beq && CMP_equal;
	 wire bne_p = bne && !CMP_equal;
	 wire bgezall_p = bgezall && CMP_gtzero;
	 
	 ///////////////////////////////////
	 wire cal_r = add || addu || sub || subu || _and || _or || slt || sltu;
	 wire cal_i = addi || addiu || andi || ori;
	 wire load = lb || lh || lw;
	 wire store = sb || sh || sw;
	 wire mult_div = mult || multu || div || divu;
	 wire mfhl = mfhi || mflo;
	 wire mthl = mthi || mtlo;
	 wire branch = beq_p || bne_p || bgezall_p;
	 wire jump = jal || j;
	 wire jump_reg = jr;
	 wire link = jal || bgezall_p;
	 wire ext_i = lui;
	 ///////////////////////////////////
	 wire unknown_instr = !(cal_r || cal_i || load || store || mult_div || mfhl || mthl ||
	                       beq || bne || bgezall || jump || jump_reg || ext_i ||
								  syscall || mfc0 || mtc0 || eret || nop);
	 ///////////////////////////////////
	 
	 assign pc_nextpc_sel = (branch || jump) ? 1 : (jump_reg) ? 2 : (eret) ? 3 : 0;//
	 assign npc_op = (jump) ? `npc_j : `npc_b;//
	 assign flush_d = ((bgezall && !CMP_gtzero && !stall) || (eret && !stall)) ? 1 : 0;//
	 assign ext_op = (ori || andi) ? `ext_zero : (lui) ? `ext_lui : `ext_sign;//
    assign rf_wa_sel = (cal_i || load || ext_i || mfc0) ? 1 : (link) ? 2 : 0;//
	 assign alu_a_sel = (link) ? 1 : 0;//
	 assign alu_b_sel = (cal_i || load || store) ? 1 : (link) ? 2 : 0;//
	 assign alu_op = (sub) ? `alu_sub : (subu) ? `alu_subu : (_and || andi) ? `alu_and : 
	                 (_or || ori) ? `alu_or : (slt) ? `alu_slt : (sltu) ? `alu_sltu : 
						  (add || addi || load || store || link) ? `alu_add : `alu_addu;//
	 assign mdu_op = (mult) ? `mdu_mult : (multu) ? `mdu_multu : (div) ? `mdu_div : `mdu_divu;
	 assign mdu_r_sel = (mfhi || mthi) ? `mdu_hi : `mdu_lo;
	 assign mdu_start = (mult_div) ? 1 : 0;
	 assign mdu_we = (mthl) ? 1 : 0;
	 assign dm_write_mode = (sb) ? `dm_wb : (sh) ? `dm_wh : (sw) ? `dm_ww : `dm_wn;//
	 assign dm_read_mode = (lb) ? `dm_rb : (lh) ? `dm_rh : (lw) ? `dm_rw : `dm_rn;//
	 assign dm_we = (store) ? 1 : 0;//
	 assign rf_wd_sel = (ext_i) ? 1 : (load) ? 2 : (link) ? 3 : (mfhl) ? 4 : (mfc0) ? 5 : 0;
	 assign rf_we = (cal_r || cal_i || load || link || ext_i || mfhl || mfc0) ? 1 : 0;
	 assign Tnew = (ext_i) ? 0 : (cal_r || cal_i || link || mfhl) ? 1 : 2;
	 assign bd = (beq || bne || bgezall || jump || jump_reg) ? 1 : 0;
	 assign e_code = syscall ? `exc_syscall : unknown_instr ? `exc_ri : `exc_none;
	 assign cp0_we = mtc0 ? 1 : 0;
	 assign EXL_reset = eret ? 1 : 0;
	 assign mtc0_flag = mtc0 ? 1 : 0;
	 
	 wire [1:0] rsTuse = (beq || bne || bgezall || jump_reg || mthl) ? 0 : (cal_r || cal_i || load || store || mult_div) ? 1 : (0) ? 2 : 3;
	 wire [1:0] rtTuse = (beq || bne) ? 0 : (cal_r || mult_div) ? 1 : (store || mtc0) ? 2 : 3;
	 
	 wire ForwardED1 = (E_rf_we == 1 && instr_rs == E_A3 && instr_rs != 0 && rsTuse != 3 && rsTuse >= E_Tnew) ? 1 : 0;
	 wire ForwardMD1 = (M_rf_we == 1 && instr_rs == M_A3 && instr_rs != 0 && rsTuse != 3 && rsTuse >= M_Tnew && ForwardED1 == 0) ? 1 : 0;
	 wire ForwardWD1 = (W_rf_we == 1 && instr_rs == W_A3 && instr_rs != 0 && rsTuse != 3 && rsTuse >= W_Tnew && ForwardED1 == 0 && ForwardMD1 == 0) ? 1 : 0;
	 
	 wire ForwardED2 = (E_rf_we == 1 && instr_rt == E_A3 && instr_rt != 0 && rtTuse != 3 && rtTuse >= E_Tnew) ? 1 : 0;
	 wire ForwardMD2 = (M_rf_we == 1 && instr_rt == M_A3 && instr_rt != 0 && rtTuse != 3 && rtTuse >= M_Tnew && ForwardED2 == 0) ? 1 : 0;
	 wire ForwardWD2 = (W_rf_we == 1 && instr_rt == W_A3 && instr_rt != 0 && rtTuse != 3 && rtTuse >= W_Tnew && ForwardED2 == 0 && ForwardMD2 == 0) ? 1 : 0;
	 
	 wire rsStall = ((E_rf_we == 1 && instr_rs == E_A3 && instr_rs != 0 && rsTuse != 3 && rsTuse < E_Tnew)||
                   (M_rf_we == 1 && instr_rs == M_A3 && instr_rs != 0 && rsTuse != 3 && rsTuse < M_Tnew)||
                   (W_rf_we == 1 && instr_rs == W_A3 && instr_rs != 0 && rsTuse != 3 && rsTuse < W_Tnew)) ? 1 : 0;
	 
	 wire rtStall = ((E_rf_we == 1 && instr_rt == E_A3 && instr_rt != 0 && rtTuse != 3 && rtTuse < E_Tnew)||
                   (M_rf_we == 1 && instr_rt == M_A3 && instr_rt != 0 && rtTuse != 3 && rtTuse < M_Tnew)||
                   (W_rf_we == 1 && instr_rt == W_A3 && instr_rt != 0 && rtTuse != 3 && rtTuse < W_Tnew)) ? 1 : 0;
    
	 wire mduStall = ((mult_div || mfhl || mthl) && MDU_busy) ? 1 : 0;
	 
	 wire cp0Stall = ((E_mtc0_flag || M_mtc0_flag) && eret) ? 1 : 0;
	 
    assign stall = (rsStall || rtStall || mduStall || cp0Stall) ? 1 : 0;

    assign f_d1_d = (ForwardWD1) ? 1 :
	                 (ForwardMD1 && M_rf_wd_sel == 0) ? 2 :
						  (ForwardMD1 && M_rf_wd_sel == 4) ? 3 :
						  (ForwardMD1 && M_rf_wd_sel == 1) ? 4 :
						  (ForwardMD1 && M_rf_wd_sel == 3) ? 5 :
						  (ForwardED1 && E_rf_wd_sel == 1) ? 6 : 0;
						
    assign f_d2_d = (ForwardWD2) ? 1 :
	                 (ForwardMD2 && M_rf_wd_sel == 0) ? 2 :
						  (ForwardMD2 && M_rf_wd_sel == 4) ? 3 :
						  (ForwardMD2 && M_rf_wd_sel == 1) ? 4 :
						  (ForwardMD2 && M_rf_wd_sel == 3) ? 5 :
						  (ForwardED2 && E_rf_wd_sel == 1) ? 6 : 0;
						
    assign f_d1_e = (ForwardMD1) ? 1 :
	                 (ForwardED1 && E_rf_wd_sel == 0) ? 2 :
						  (ForwardED1 && E_rf_wd_sel == 4) ? 3 :
						  (ForwardED1 && E_rf_wd_sel == 1) ? 4 :
						  (ForwardED1 && E_rf_wd_sel == 3) ? 5 : 0;
						
    assign f_d2_e = (ForwardMD2) ? 1 :
	                 (ForwardED2 && E_rf_wd_sel == 0) ? 2 :
						  (ForwardED2 && E_rf_wd_sel == 4) ? 3 :
						  (ForwardED2 && E_rf_wd_sel == 1) ? 4 :
						  (ForwardED2 && E_rf_wd_sel == 3) ? 5 : 0;
						
    assign f_d2_m = ForwardED2 ? 1 : 0;
	 
endmodule
