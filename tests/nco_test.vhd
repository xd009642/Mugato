--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:35:44 03/12/2018
-- Design Name:   
-- Module Name:   /home/xd009642/code/pld/synthesiser/tests/nco_test.vhd
-- Project Name:  mugato
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: nc_osc
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
 
ENTITY nco_test IS
END nco_test;
 
ARCHITECTURE behavior OF nco_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT nc_osc
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         phase_in : IN  std_logic_vector(7 downto 0);
         phase_offset : IN  std_logic_vector(7 downto 0);
         phase_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal phase_in : std_logic_vector(7 downto 0) := "00001111";
   signal phase_offset : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal phase_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: nc_osc PORT MAP (
          clk => clk,
          rst => rst,
          phase_in => phase_in,
          phase_offset => phase_offset,
          phase_out => phase_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
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
      wait;
   end process;

END;
