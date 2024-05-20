`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:39:47 11/04/2022 
// Design Name: 
// Module Name:    macros 
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
`define special_op 6'b000000
/*cal_i*////////////////////////
`define addi_op 6'b001000
`define addiu_op 6'b001001
`define andi_op 6'b001100
`define ori_op 6'b001101
////////////////////////////////
/*load*/////////////////////////
`define lb_op 6'b100000
`define lh_op 6'b100001
`define lw_op 6'b100011
/*store*////////////////////////
`define sb_op 6'b101000
`define sh_op 6'b101001
`define sw_op 6'b101011
////////////////////////////////
/*branch*///////////////////////
`define beq_op 6'b000100
`define bne_op 6'b000101
////////////////////////////////
/*jump*/////////////////////////
`define jal_op 6'b000011 
`define j_op 6'b000010
////////////////////////////////
/*ext_i*////////////////////////
`define lui_op 6'b001111
////////////////////////////////


/*cal_r*////////////////////////
`define add_func 6'b100000
`define addu_func 6'b100001
`define sub_func 6'b100010
`define subu_func 6'b100011
`define and_func 6'b100100
`define or_func 6'b100101
`define slt_func 6'b101010
`define sltu_func 6'b101011 
`define nop_func 6'b000000 // attention.
////////////////////////////////
/*mult_div*/////////////////////
`define mult_func 6'b011000
`define multu_func 6'b011001
`define div_func 6'b011010
`define divu_func 6'b011011
////////////////////////////////
/*mfhl*/////////////////////////
`define mfhi_func 6'b010000
`define mflo_func 6'b010010
////////////////////////////////
/*mthl*/////////////////////////
`define mthi_func 6'b010001
`define mtlo_func 6'b010011
////////////////////////////////
/*jump_reg*/////////////////////
`define jr_func 6'b001000
////////////////////////////////
/*???*//////////////////////////
`define regimm_op 6'b000001
`define bgezall 5'b10011
////////////////////////////////
/*syscall*//////////////////////
`define syscall_func 6'b001100
////////////////////////////////
/*cp0*//////////////////////////
`define cp0_op 6'b010000
`define mfc0 5'b00000
`define mtc0 5'b00100
`define eret 32'b01000010000000000000000000011000
////////////////////////////////

`define npc_j 1'b0
`define npc_b 1'b1

`define ext_zero 2'b00
`define ext_sign 2'b01
`define ext_lui 2'b10

`define alu_add 4'b0000
`define alu_addu 4'b0001
`define alu_sub 4'b0010
`define alu_subu 4'b0011
`define alu_and 4'b0100
`define alu_or 4'b0101
`define alu_slt 4'b1010
`define alu_sltu 4'b1011

`define mdu_mult 4'b0000
`define mdu_multu 4'b0001
`define mdu_div 4'b0010
`define mdu_divu 4'b0011
`define mdu_hi 1'b1
`define mdu_lo 1'b0

`define dm_wb 4'b0001
`define dm_wh 4'b0011
`define dm_ww 4'b1111
`define dm_wn 4'b0000
`define dm_rb 2'b00
`define dm_rh 2'b01
`define dm_rw 2'b10
`define dm_rn 2'b11

`define cp0_im register[12][15:10] // Interrupt Mask
`define cp0_exl register[12][1] // Exception Level
`define cp0_ie register[12][0] // Interrupt Enable
`define cp0_bd register[13][31] // Branch Delay
`define cp0_ip register[13][15:10] // Interrupt Pending
`define cp0_e_code register[13][6:2] // ExcCode
`define cp0_epc register[14]

// attention. below is wrong.
`define exc_none 5'd0
`define exc_adel 5'd4
`define exc_ades 5'd5
`define exc_syscall 5'd8
`define exc_ri 5'd10
`define exc_ov 5'd12
`define req_addr 32'h0000_4180
