`timescale 1ns / 1ps
`include "macros.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:37:39 11/29/2022 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
    input clk,
	 input reset,
    input [31:0] m_data_addr,
    input [31:0] m_data_wdata,
    input [3:0] m_data_byteen,
    input [1:0] read_mode,
	 input [3:0] write_mode,
    input [31:0] m_inst_addr,
	 
	 output [31:0] m_data_rdata,
	 output [4:0] e_code,
	 output TC0_inter,
	 output TC1_inter,
	 
	 input [31:0] DM_m_data_rdata,
	 output [31:0] DM_m_data_addr,
	 output [31:0] DM_m_data_wdata,
	 output [3:0] DM_m_data_byteen,
	 
	 output [31:0] IG_m_int_addr,
	 output [3:0] IG_m_int_byteen
	 
    );
	 
	 assign m_data_rdata = DM_hit ? DM_m_data_rdata : TC0_hit ? TC0_Dout : TC1_hit ? TC1_Dout : 0;
	 assign e_code = adel ? `exc_adel : ades ? `exc_ades : `exc_none;
	 assign DM_m_data_addr = m_data_addr;
	 assign DM_m_data_wdata = m_data_wdata;
	 assign DM_m_data_byteen = DM_hit ? m_data_byteen : 0;
	 assign IG_m_int_addr = m_data_addr;
	 assign IG_m_int_byteen = IG_hit ? m_data_byteen : 0;
	 
	 wire [31:0] DM_m_data_rdata;
	 wire [31:0] TC0_Dout;
	 wire [31:0] TC1_Dout;
	 
	 wire DM_hit = (m_data_addr <= 32'h0000_2FFF) ? 1 : 0;
	 wire TC0_hit = (m_data_addr <= 32'h0000_7F0B && m_data_addr >= 32'h0000_7F00) ? 1 : 0;
	 wire TC1_hit = (m_data_addr <= 32'h0000_7F1B && m_data_addr >= 32'h0000_7F10) ? 1 : 0;
	 wire IG_hit = (m_data_addr <= 32'h0000_7F23 && m_data_addr >= 32'h0000_7F20) ? 1 : 0;
	 
	 wire TC0_we = TC0_hit ? |m_data_byteen : 0;
	 wire TC1_we = TC1_hit ? |m_data_byteen : 0;
	 
	 wire adel = ((DM_hit && read_mode == `dm_rw && m_data_addr[1:0]) ||
	             (DM_hit && read_mode == `dm_rh && m_data_addr[0]) ||
					 ((TC0_hit || TC1_hit) && (read_mode == `dm_rh || read_mode == `dm_rb)) ||
					 (read_mode != `dm_rn && !(DM_hit || TC0_hit || TC1_hit || IG_hit))) ? 1 : 0;
					 
	 wire ades = ((write_mode == `dm_ww && m_data_addr[1:0]) ||
	             (write_mode == `dm_wh && m_data_addr[0]) ||
					 ((TC0_hit || TC1_hit) && write_mode && write_mode != `dm_ww) ||
					 ((TC0_hit || TC1_hit) && write_mode && m_data_addr[3:2] == 2) ||
					 (write_mode && !(DM_hit || TC0_hit || TC1_hit || IG_hit))) ? 1 : 0;
					 
	 TC TC0(
	     .clk(clk),
        .reset(reset),
        .Addr(m_data_addr),
        .WE(TC0_we),
        .Din(m_data_wdata),
        .Dout(TC0_Dout),
        .IRQ(TC0_inter)
	 );
	 
	 TC TC1(
	     .clk(clk),
        .reset(reset),
        .Addr(m_data_addr),
        .WE(TC1_we),
        .Din(m_data_wdata),
        .Dout(TC1_Dout),
        .IRQ(TC1_inter)
	 );	 
	 
	 

endmodule
