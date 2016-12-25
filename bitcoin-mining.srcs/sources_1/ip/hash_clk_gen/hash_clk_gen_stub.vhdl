-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
-- Date        : Sun Dec 25 17:20:33 2016
-- Host        : mygod-dell running 64-bit Linux Mint 18 Sarah
-- Command     : write_vhdl -force -mode synth_stub
--               /home/mygod/Products/Vivado/bitcoin-mining/bitcoin-mining.srcs/sources_1/ip/hash_clk_gen/hash_clk_gen_stub.vhdl
-- Design      : hash_clk_gen
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hash_clk_gen is
  Port ( 
    clk_out : out STD_LOGIC;
    clk_in : in STD_LOGIC
  );

end hash_clk_gen;

architecture stub of hash_clk_gen is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out,clk_in";
begin
end;
