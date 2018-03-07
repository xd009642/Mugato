--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:01:48 03/07/2018
-- Design Name:   
-- Module Name:   /home/xd009642/code/pld/synthesiser/tests/test_driver.vhd
-- Project Name:  mugato
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: audio_interface
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_driver IS
END test_driver;
 
ARCHITECTURE behavior OF test_driver IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT audio_interface
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         amplitude : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
	
 	--Outputs
   signal amplitude : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	signal done : std_logic := '0';
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: audio_interface PORT MAP (
          clk => clk,
          rst => rst,
          amplitude => amplitude
        );

   -- Clock process definitions
   clk_process :process
   begin
		if done = '0' then
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
		end if;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 100 ns;	
		rst <= '0';
      wait for clk_period*10;

      -- insert stimulus here 

      done <= '1';
   end process;

END;
