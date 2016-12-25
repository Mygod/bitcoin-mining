`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2016 01:37:18 AM
// Design Name: 
// Module Name: test_fpgaminer_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_fpgaminer_top ();

	reg clk = 1'b0;

	fpgaminer_top # (.LOOP_LOG2(0)) uut (clk);


	reg [31:0] cycle = 32'd0;

	initial begin
		clk = 0;
		#100

		// Test data
		uut.midstate_buf = 256'h228ea4732a3c9ba860c009cda7252b9161a5e75ec8c582a5f106abb3af41f790;
		uut.data_buf = 512'h000002800000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000002194261a9395e64dbed17115;
		uut.nonce = 32'h0e33337a - 256;	// Minus a little so we can exercise the code a bit
	end
	
	always #5 clk = ~clk;


	always @ (posedge clk)
	begin
		cycle <= cycle + 32'd1;
	end

endmodule
