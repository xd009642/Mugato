----------------------------------------------------------------------------------
-- cclk_detector VHDL
-- Translated from Mojo-base Verilog project @ http://embeddedmicro.com/frontend/files/userfiles/files/Mojo-Base.zip
-- by Xark
--
-- This module monitors cclk line from the AVR microcontroller.  When this line
-- has been held high for 10.24 microseconds (@ 50Mhz clk) the ready signal will
-- be asserted.  Before this time the FPGA must not take control of the AVR outputs.
--
-- See http://embeddedmicro.com/tutorials/the-mojo/avr-interface
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity cclk_detector is
	port (
		clk		: in  std_logic;	-- 50Mhz clock 
		rst		: in  std_logic;	-- reset signal
		cclk	: in  std_logic;	-- configuration clock (?) from AVR
		ready	: out std_logic		-- output signal that FPGA I/O is safe to use
	);
end cclk_detector;

architecture RTL of cclk_detector is

signal ctr_d	: unsigned(8 downto 0);
signal ctr_q	: unsigned(8 downto 0);
signal ready_d	: std_logic;
signal ready_q	: std_logic;

begin
ready <= ready_q;

cclk_comb: process(cclk, ctr_q)
begin
	ready_d <= '0';		-- default to not ready
	if cclk = '0' then
		ctr_d	<= (others => '0');	-- reset counter if cclk is seen to be low
	elsif ctr_q /= "111111111" then
		ctr_d	<= ctr_q + 1;		-- if not max (512 * 20ns = 10.24 usec), increment counter
	else
		ctr_d	<= ctr_q;			-- maintain current max count
		ready_d	<= '1';				-- indicate ready (override default)
	end if;
end process cclk_comb;

cclk_seq: process(clk, rst)
begin
	if rst = '1' then				-- on reset
		ctr_q 	<= (others => '0');		-- reset counter
		ready_q <= '0';					-- indicate not ready
	elsif rising_edge(clk) then		-- on 50Mhz clock tick
		ctr_q	<= ctr_d;				-- latch signals from combinational process
		ready_q	<= ready_d;
	end if;
end process cclk_seq;

end RTL;
