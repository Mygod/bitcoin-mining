// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
// Date        : Sun Dec 25 17:20:32 2016
// Host        : mygod-dell running 64-bit Linux Mint 18 Sarah
// Command     : write_verilog -force -mode synth_stub
//               /home/mygod/Products/Vivado/bitcoin-mining/bitcoin-mining.srcs/sources_1/ip/hash_clk_gen/hash_clk_gen_stub.v
// Design      : hash_clk_gen
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module hash_clk_gen(clk_out, clk_in)
/* synthesis syn_black_box black_box_pad_pin="clk_out,clk_in" */;
  output clk_out;
  input clk_in;
endmodule
