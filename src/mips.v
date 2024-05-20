`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:31 11/30/2022 
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
module mips(
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              // 外部中断信号
    output [31:0] macroscopic_pc, // 宏观 PC

    output [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数据
    output [3 :0] m_data_byteen,  // DM 字节使能信号

    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号

    output [31:0] m_inst_addr,    // M 级 PC

    output w_grf_we,              // GRF 写使能信号
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数据

    output [31:0] w_inst_addr     // W 级 PC
    );
	 
	 assign macroscopic_pc = CPU_MPC;
	 assign i_inst_addr = CPU_i_inst_addr;
	 assign m_inst_addr = CPU_m_inst_addr;
	 assign w_grf_we = CPU_w_grf_we;
	 assign w_grf_addr = CPU_w_grf_addr;
	 assign w_grf_wdata = CPU_w_grf_wdata;
	 assign w_inst_addr = CPU_w_inst_addr;
	 
	 
	 wire [5:0] tCPUinter = {{3{1'b0}}, interrupt, Bridge_TC1_inter, Bridge_TC0_inter};
	 
	 wire [31:0] CPU_i_inst_addr;
	 wire [31:0] CPU_m_data_addr;
	 wire [31:0] CPU_m_data_wdata;
	 wire [3:0] CPU_m_data_byteen;
	 wire [31:0] CPU_m_inst_addr;
	 wire [3:0] CPU_m_dm_write_mode;
	 wire [1:0] CPU_m_dm_read_mode;
	 wire CPU_w_grf_we;
	 wire [31:0] CPU_w_grf_addr;
	 wire [31:0] CPU_w_grf_wdata;
	 wire [31:0] CPU_w_inst_addr;
	 wire [31:0] CPU_MPC;
	 
	 wire [31:0] Bridge_m_data_rdata;
	 wire [4:0] Bridge_e_code;
	 wire Bridge_TC0_inter;
	 wire Bridge_TC1_inter;
	 
	 CPU CPU(
	     .clk(clk),
		  .reset(reset),
		  .i_inst_rdata(i_inst_rdata),
		  .i_inst_addr(CPU_i_inst_addr),
		  .m_data_rdata(Bridge_m_data_rdata),
		  .m_data_addr(CPU_m_data_addr),
		  .m_data_wdata(CPU_m_data_wdata),
		  .m_data_byteen(CPU_m_data_byteen),
		  .m_inst_addr(CPU_m_inst_addr),
		  .m_dm_read_mode(CPU_m_dm_read_mode),
		  .m_dm_write_mode(CPU_m_dm_write_mode),
		  .w_grf_we(CPU_w_grf_we),
		  .w_grf_addr(CPU_w_grf_addr),
		  .w_grf_wdata(CPU_w_grf_wdata),
		  .w_inst_addr(CPU_w_inst_addr),
		  .DM_e_code(Bridge_e_code),
		  .inter(tCPUinter),
		  .MPC(CPU_MPC)
	 );
	 
	 Bridge Bridge(
	     .m_data_addr(CPU_m_data_addr),
		  .m_data_wdata(CPU_m_data_wdata),
		  .m_data_byteen(CPU_m_data_byteen),
		  .read_mode(CPU_m_dm_read_mode),
		  .m_inst_addr(CPU_m_inst_addr),
		  .clk(clk),
		  .reset(reset),
		  .write_mode(CPU_m_dm_write_mode),
		  .m_data_rdata(Bridge_m_data_rdata),
		  .e_code(Bridge_e_code),
		  .TC0_inter(Bridge_TC0_inter),
		  .TC1_inter(Bridge_TC1_inter),
		  
		  .DM_m_data_rdata(m_data_rdata),
		  .DM_m_data_addr(m_data_addr),
		  .DM_m_data_wdata(m_data_wdata),
		  .DM_m_data_byteen(m_data_byteen),
		  
		  .IG_m_int_addr(m_int_addr),
		  .IG_m_int_byteen(m_int_byteen)
	 );


endmodule
