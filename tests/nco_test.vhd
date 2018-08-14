-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 2.8.2018 21:03:23 GMT

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_cordic_gen is
end tb_cordic_gen;

architecture behaviour of tb_cordic_gen is

    component cordic_gen
        port (clk    : in std_logic;
              rst    : in std_logic;
              phase  : in unsigned (14 downto 0);
              start  : in std_logic;
              sinout : out unsigned (14 downto 0);
              done   : out std_logic);
    end component;

    signal clk    : std_logic;
    signal rst    : std_logic;
    signal phase  : unsigned (14 downto 0);
    signal start  : std_logic;
    signal sinout : unsigned (14 downto 0);
    signal done   : std_logic;

    constant period : time := 10 ns; 
    signal TbSimEnded : std_logic := '0';

begin

    dut : cordic_gen
    port map (clk    => clk,
              rst    => rst,
              phase  => phase,
              start  => start,
              sinout => sinout,
              done   => done);

    clk_process:process
	begin
		clk <= '0';
		wait for period/2;
		clk <= '1';
		wait for period/2;
	end process;
	
	phase_ramp:process(clk)
	begin
		if (rst = '1') then 
			phase <= (others => '0');
		elsif rising_edge(clk) and done then
			phase <= phase + 1;
			start <= '1';
		else 
			start <= '0';
		end if;
	end process;

    stimuli : process
    begin
        start <= '0';

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 1000 * period;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end behaviour;
