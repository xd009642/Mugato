----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:01:21 03/08/2018 
-- Design Name: 
-- Module Name:    nc_osc - Behavioral 
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

entity nc_osc is
    Generic ( 
        pcw_width   : integer := 8
    );
    Port (  
        clk         : in std_logic;
        rst         : in std_logic;
        phase_in    : in std_logic_vector (pcw_width downto 0);
        phase_out   : out  std_logic_vector (pcw_width downto 0) 
    );
end nc_osc;

architecture Behavioral of nc_osc is
signal phase_buffer : std_logic_vector(pcw_width downto 0);
begin
    update: process(clk) 
    begin
        if rst = '1' then
            phase_buffer <= (others => '0');
        elsif rising_edge(clk) then
            phase_buffer <= std_logic_vector(unsigned(phase_in) + unsigned(phase_buffer));
            phase_out <= phase_buffer;
        end if;
    end process update;
    
end Behavioral;

