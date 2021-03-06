/*
*
* Copyright (c) 2011 fpgaminer@bitcoin-mining.com
*
*
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
* 
*/

`timescale 1ns/1ps

// `define SIM

module fpgaminer_top (osc_clk, RxD, TxD, anode, segment, disp_switch);

	input osc_clk;


	//// 
	reg [255:0] state = 0;
	reg [511:0] data = 0;
   reg [31:0] 	    nonce = 32'h00000000;

	//// PLL
	wire hash_clk;
	`ifndef SIM
	   hash_clk_gen pll_blk(.clk_in(osc_clk), .clk_out(hash_clk));
	`else
		assign hash_clk = osc_clk;
	`endif


	//// Hashers
	wire [255:0] hash, hash2;
	reg [5:0] cnt = 6'd0;
	reg feedback = 1'b0;

	sha256_transform #(.LOOP(1)) uut (
		.clk(hash_clk),
		.feedback(feedback),
		.cnt(cnt),
		.rx_state(state),
		.rx_input(data),
		.tx_hash(hash)
	);
	sha256_transform #(.LOOP(1)) uut2 (
		.clk(hash_clk),
		.feedback(feedback),
		.cnt(cnt),
		.rx_state(256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667),
		.rx_input({256'h0000010000000000000000000000000000000000000000000000000080000000, hash}),
		.tx_hash(hash2)
	);


	//// Virtual Wire Control
	reg [255:0] midstate_buf = 256'b0, data_buf = 256'b0;
	wire [255:0] midstate_vw, data2_vw;

   input 	     RxD;
   
   serial_receive serrx (.clk(hash_clk), .RxD(RxD), .midstate(midstate_vw), .data2(data2_vw));
   
	//// Virtual Wire Output
	reg [31:0] golden_nonce = 0;
   reg 		   serial_send;
   wire 	   serial_busy;
   output 	   TxD;

   serial_transmit sertx (.clk(hash_clk), .TxD(TxD), .send(serial_send), .busy(serial_busy), .word(golden_nonce));
   

	//// Control Unit
	reg is_golden_ticket = 1'b0;
	reg feedback_d1 = 1'b1;
	wire [5:0] cnt_next;
	wire [31:0] nonce_next;
	wire feedback_next;
	`ifndef SIM
		wire reset;
		assign reset = 1'b0;
	`else
		reg reset = 1'b0;	// NOTE: Reset is not currently used in the actual FPGA; for simulation only.
	`endif

	assign cnt_next =  6'd0;
	// On the first count (cnt==0), load data from previous stage (no feedback)
	// on 1..LOOP-1, take feedback from current stage
	// This reduces the throughput by a factor of (LOOP), but also reduces the design size by the same amount
	assign feedback_next = 1'b0;
	assign nonce_next =
		reset ? 32'd0 :
		feedback_next ? nonce : (nonce + 32'd1);

	
	always @ (posedge hash_clk)
	begin
		`ifdef SIM
			//midstate_buf <= 256'h2b3f81261b3cfd001db436cfd4c8f3f9c7450c9a0d049bee71cba0ea2619c0b5;
			//data_buf <= 256'h00000000000000000000000080000000_00000000_39f3001b6b7b8d4dc14bfc31;
			//nonce <= 30411740;
		`else
			midstate_buf <= midstate_vw;
			data_buf <= data2_vw;
		`endif

		cnt <= cnt_next;
		feedback <= feedback_next;
		feedback_d1 <= feedback;

		// Give new data to the hasher
		state <= midstate_buf;
		data <= {384'h000002800000000000000000000000000000000000000000000000000000000000000000000000000000000080000000, nonce_next, data_buf[95:0]};
		nonce <= nonce_next;


		// Check to see if the last hash generated is valid.
		is_golden_ticket <= (hash2[255:224] == 32'h00000000) && !feedback_d1;
		if(is_golden_ticket)
		begin
			golden_nonce <= nonce - 32'h103;

		   if (!serial_busy) serial_send <= 1;
		end // if (is_golden_ticket)
		else
		  serial_send <= 0;
	   
`ifdef SIM
		if (!feedback_d1)
			$display ("nonce: %8x\nhash2: %64x\n", nonce, hash2);
`endif
	end

   // die debuggenlichten

   input disp_switch;
   output [7:0] segment;
   output [7:0] anode;

   wire [7:0] 	segment_data;

   // inverted signals, so 1111.. to turn it off
   assign segment = disp_switch? segment_data : {8{1'b1}};
   
   raw7seg disp(.clk(hash_clk), .segment(segment_data), .anode(anode), .word({midstate_vw[15:0], data2_vw[15:0], golden_nonce}));
   
endmodule

