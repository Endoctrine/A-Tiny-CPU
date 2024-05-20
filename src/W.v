`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:44:43 11/04/2022 
// Design Name: 
// Module Name:    W 
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
module W(
    input [1:0] Tnew_i,
	 input [4:0] A3_i,
	 input [31:0] ALUR_i,
	 input [31:0] MDUR_i,
	 input [31:0] PC4_i,
	 input [31:0] E32_i,
	 input [31:0] PC8_i,
	 input [31:0] DR_i,
	 input [31:0] CP0_RD_i,
	 input clk,
	 input reset,
	 output reg [1:0] Tnew_o,
	 output reg [4:0] A3_o,
	 output reg [31:0] ALUR_o,
	 output reg [31:0] MDUR_o,
	 output reg [31:0] PC4_o,
	 output reg [31:0] E32_o,
	 output reg [31:0] PC8_o,
	 output reg [31:0] DR_o,
	 output reg [31:0] CP0_RD_o,
	 
	 input [3:0] rf_wa_sel_i,
	 input [3:0] rf_wd_sel_i,
	 input rf_we_i,
	 
	 output reg [3:0] rf_wa_sel_o,
	 output reg [3:0] rf_wd_sel_o,
	 output reg rf_we_o
    );
    always @(posedge clk) begin
	     if(reset) begin
		      A3_o <= 0;
				Tnew_o <= 0;
		      rf_we_o <= 0;
				rf_wa_sel_o <= 0;
				rf_wd_sel_o <= 0;
		  end
		  else begin
		      Tnew_o <= Tnew_i;
	         A3_o <= A3_i;
	         ALUR_o <= ALUR_i;
				MDUR_o <= MDUR_i;
	         PC4_o <= PC4_i;
	         E32_o <= E32_i;
				PC4_o <= PC4_i;
	         PC8_o <= PC8_i;
	         DR_o <= DR_i;
				CP0_RD_o <= CP0_RD_i;
				
				rf_wa_sel_o <= rf_wa_sel_i;
				rf_wd_sel_o <= rf_wd_sel_i;
				rf_we_o <= rf_we_i;
		  end
	 end

endmodule
