----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:47:36 03/07/2018 
-- Design Name: 
-- Module Name:    audio_interface - RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity audio_interface is
        Port ( 
            clk         : in  std_logic;
            rst         : in  std_logic;
            amplitude   : out  std_logic_vector (15 downto 0)
        );
end audio_interface;

architecture RTL of audio_interface is
    signal amplitude_m1 : std_logic_vector (15 downto 0);
begin

amplitude <= amplitude_m1;

-- This should do a simple saw wave for now
wave_gen: process(clk, rst)
begin
    if rst = '1' then
        amplitude_m1 <= (others => '0');
    elsif rising_edge(clk) then
        amplitude_m1 <= std_logic_vector( unsigned(amplitude_m1) + 1 );
    end if;
	
end process wave_gen;


end RTL;

