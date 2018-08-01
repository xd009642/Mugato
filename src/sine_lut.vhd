----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:19:38 03/13/2018 
-- Design Name: 
-- Module Name:    sine_lut - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sine_lut is
    Port ( phase : in  STD_LOGIC_VECTOR (14 downto 0);
           clk : in  STD_LOGIC;
		   rst : in  std_logic;
           amplitude : out  STD_LOGIC_VECTOR (14 downto 0));
end sine_lut;

architecture Behavioral of sine_lut is
type sine_lut is array (255 to 0) of std_logic_vector(15 downto 0);

signal sine: sine_lut;

begin

update: process(clk, rst)
begin
    if rst = '1' then 
        
	elsif rising_edge(clk) then

    end if;
end process update;
end Behavioral;

