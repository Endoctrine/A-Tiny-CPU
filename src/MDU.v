`timescale 1ns / 1ps
`include "macros.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:43:52 11/17/2022 
// Design Name: 
// Module Name:    MDU 
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
module MDU(
    input [31:0] A,
	 input [31:0] B,
	 input [3:0] mdu_op,
	 input r_sel,
	 input start,
	 input we,
	 input reset,
	 input clk,
	 output [31:0] R,
	 output busy
    );
    
	 reg [31:0] hi;
	 reg [31:0] lo;
	 reg [31:0] counter;
	 reg [3:0] current_op;
	 
	 reg signed [63:0] signed_A;
	 reg [63:0] unsigned_A;
	 reg signed [63:0] signed_B;
	 reg [63:0] unsigned_B;
	 reg [31:0] A_32;
	 reg [31:0] B_32;
	 
	 wire [63:0] mult_R = signed_A * signed_B; // may be all wrong...
	 wire [63:0] multu_R = unsigned_A * unsigned_B;
	 wire [31:0] div_R = $signed(A_32) / $signed(B_32);
	 wire [31:0] divu_R = A_32 / B_32;
	 wire [31:0] mod_R = $signed(A_32) % $signed(B_32);
	 wire [31:0] modu_R = A_32 % B_32;
	 
	 always @ (posedge clk) begin
	     if(reset) begin
		      hi <= 0;
				lo <= 0;
				counter <= 0;
		  end
		  else if(we) begin
		      if(r_sel == `mdu_hi) begin
				    hi <= A;
				end
				else begin
				   lo <= A;
				end
		  end
		  else if(counter > 1) begin
		      counter <= counter - 1;
		  end
		  else if(counter == 1) begin
		      counter <= counter - 1;
				hi <= current_op == `mdu_mult ? mult_R[63:32] :
				     current_op == `mdu_multu ? multu_R[63:32] :
					  current_op == `mdu_div ? mod_R : modu_R;
				
				lo <= current_op == `mdu_mult ? mult_R[31:0] :
				     current_op == `mdu_multu ? multu_R[31:0] :
					  current_op == `mdu_div ? div_R : divu_R;
		  end
		  else begin
		      if(start && mdu_op[1] == 0) begin
				    current_op <= mdu_op;
					 A_32 <= A;
					 B_32 <= B;
					 signed_A <= {{32{A[31]}}, A};
	             unsigned_A <= {{32{1'b0}}, A};
	             signed_B <= {{32{B[31]}}, B};
	             unsigned_B <= {{32{1'b0}}, B};
					 counter <= 5;
				end
				else if(start && mdu_op[1] == 1) begin
				    current_op <= mdu_op;
					 A_32 <= A;
					 B_32 <= B;
					 signed_A <= {{32{A[31]}}, A};
	             unsigned_A <= {{32{1'b0}}, A};
	             signed_B <= {{32{B[31]}}, B};
	             unsigned_B <= {{32{1'b0}}, B};
					 counter <= 10;
				end
		  end
	 end

    assign busy = counter != 0 || start;
	 assign R = r_sel == `mdu_hi ? hi : lo;

endmodule
