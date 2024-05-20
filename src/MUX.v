`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:20:40 11/04/2022 
// Design Name: 
// Module Name:    MUX 
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
module MUX(
    );


endmodule

module MUX_2(
    input [31:0] a,
	 input [31:0] b,
	 input [31:0] c,
	 input [31:0] d,
	 input [1:0] sel,
	 output [1:0] out
    );
	 assign out = sel == 0 ? a :
	              sel == 1 ? b :
					  sel == 2 ? c : d;
endmodule

module MUX_3(
    input [31:0] a,
	 input [31:0] b,
	 input [31:0] c,
	 input [31:0] d,
	 input [31:0] e,
	 input [31:0] f,
	 input [31:0] g,
	 input [31:0] h,
	 input [2:0] sel,
	 output [31:0] out
);
    assign out = sel == 0 ? a :
	              sel == 1 ? b :
					  sel == 2 ? c :
					  sel == 3 ? d :
					  sel == 4 ? e :
	              sel == 5 ? f :
					  sel == 6 ? g : h;

endmodule

module MUX_4(
    input [31:0] a,
	 input [31:0] b,
	 input [31:0] c,
	 input [31:0] d,
	 input [31:0] e,
	 input [31:0] f,
	 input [31:0] g,
	 input [31:0] h,
	 input [31:0] i,
	 input [31:0] j,
	 input [31:0] k,
	 input [31:0] l,
	 input [31:0] m,
	 input [31:0] n,
	 input [31:0] o,
	 input [31:0] p,
	 
	 input [3:0] sel,
	 
	 output [31:0] out
);
    assign out = sel == 0 ? a :
	              sel == 1 ? b :
					  sel == 2 ? c :
					  sel == 3 ? d :
					  sel == 4 ? e :
	              sel == 5 ? f :
					  sel == 6 ? g :
					  sel == 7 ? h :
					  sel == 8 ? i :
	              sel == 9 ? j :
					  sel == 10 ? k :
					  sel == 11 ? l :
					  sel == 12 ? m :
	              sel == 13 ? n :
					  sel == 14 ? o : p;
					  
endmodule
