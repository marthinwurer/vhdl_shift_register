library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sr_tb is
end sr_tb;


architecture behav of sr_tb is

	constant width : natural := 8;
	constant clk_period: Time := 100 ns;

	component shift_register 
	generic ( N: integer);
	port (
		clk: in std_logic;
		input: in std_logic;
		reset: in std_logic;
		state: out std_logic_vector(N-1 downto 0));
	end component;


	signal clk, input, reset, output: std_logic;
	signal state: std_logic_vector(width - 1 downto 0);
	signal current : natural;
	signal expected: std_logic_vector(width - 1 downto 0);

begin
	sr: shift_register 
	generic map(N=>width) 
		port map(clk=>clk, input=>input, reset=>reset, state=>state);

	process
	type expected_io is record
		-- inputs 
		i0: std_logic;
		-- expected output
		output: std_logic_vector(width - 1 downto 0);
	end record;

	type io_array is array(natural range <>) of expected_io;

	constant io_data: io_array :=
	(('0',('0','0','0','0','0','0','0','0')), 
	('1',('0','0','0','0','0','0','0','0')), 
	('0',('0','0','0','0','0','0','0','1')), 
	('0',('0','0','0','0','0','0','1','0')), 
	('0',('0','0','0','0','0','1','0','0')), 
	('0',('0','0','0','0','1','0','0','0')), 
	('1',('0','0','0','1','0','0','0','0')), 
	('1',('0','0','1','0','0','0','0','1')), 
	('0',('0','1','0','0','0','0','1','1')), 
	('0',('1','0','0','0','0','1','1','0')), 
	('0',('0','0','0','0','1','1','0','0')), 
	('0',('0','0','0','1','1','0','0','0')), 
	('0',('0','0','1','1','0','0','0','0')), 
	('0',('0','1','1','0','0','0','0','0')), 
	('0',('1','1','0','0','0','0','0','0')), 
	('0',('1','0','0','0','0','0','0','0')), 
	('0',('0','0','0','0','0','0','0','0')), 
	('0',('0','0','0','0','0','0','0','0')));

	begin
		reset <= '1';
		input <= '0';
		clk<='0';
		wait for clk_period/4;
		reset <= '0';
		wait for clk_period/4;

		-- set, then test each 
		for ii in io_data'range loop
			expected <= io_data(ii).output;
			clk<='1';
			wait for clk_period/2;
			input <= io_data(ii).i0;
			clk<='0';
			wait for clk_period/2;
			assert state = io_data(ii).output 
				report "bad shift output " & std_logic'image(io_data(ii).output(0)) &
				std_logic'image(state(0))
				severity error;
		end loop;

		assert false report "End of test" severity note;
		wait;
	end process;
end behav;

