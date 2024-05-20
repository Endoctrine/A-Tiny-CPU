`timescale 1ns / 1ps
`include "macros.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:36:12 11/28/2022 
// Design Name: 
// Module Name:    CP0 
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
module CP0(
    input [4:0] Addr, //A4
	 input [31:0] DW, //D2
	 input [31:0] VPC, //M_PC
	 
	 input bd, //Controller
	 input [4:0] e_code, //M
	 input [5:0] inter, //outside
	 
	 input EXL_reset, //Controller
	 input clk, //outside
	 input we, //Controller
	 input reset, //outside 
	 
	 output [31:0] MPC,
	 output [31:0] RD,
	 output [31:0] EPC,
	 output req
    );
	 
	 assign MPC = VPC;
	 
    reg [31:0] register [0:31];
	 reg EXL_reset_delay;
	 
	 wire exc_p = ((|e_code) & !`cp0_exl) ? 1 : 0;
	 wire inter_p = ((|(inter & `cp0_im)) & !`cp0_exl & `cp0_ie) ? 1 : 0;
	 
	 assign RD = register[Addr];
	 assign EPC = `cp0_epc;
	 assign req = (exc_p | inter_p) ? 1 : 0;
	 
	 integer i;
	 
	 always @ (posedge clk) begin
	     if(reset) begin
		      for(i = 0; i < 32; i = i + 1) begin
		         register[i] <= 0;
            end
		  end
		  else begin
				EXL_reset_delay <= EXL_reset;
		      if(EXL_reset_delay) begin
				    `cp0_exl <= 1'b0;
				end
				if(we) begin
				    register[Addr] <= DW;
				end
				if(req) begin
					`cp0_exl <= 1;
					if(inter_p) begin
					    `cp0_epc <= bd ? VPC - 4 : VPC; // !!!
						 `cp0_e_code <= `exc_none;
					end else begin
					    `cp0_epc <= bd ? VPC - 4 : VPC;
						 `cp0_e_code <= e_code;
					end
					`cp0_bd <= bd;
				end
				`cp0_ip <= inter;
		  end
	 end
	 
endmodule
