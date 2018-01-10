library ieee;
use ieee.std_logic_1164.all;


entity shift_register is
	generic ( N: integer);
	port (
		clk: in std_logic;
		input: in std_logic;
		reset: in std_logic;
		output: out std_logic;
		state: out std_logic_vector(N-1 downto 0));
end shift_register;

architecture behavior of shift_register is
	signal i_state: std_logic_vector(N-1 downto 0);
begin
	process (clk, reset)
	begin
		if reset = '1' then
			for ii in 0 to N-1 loop
				i_state(ii) <= '0';
			end loop;
		elsif rising_edge(clk) then
			for ii in 0 to N-2 loop
				i_state(ii+1) <= i_state(ii);
			end loop;
			i_state(0) <= input;
		end if;
		output <= i_state(N-1);
		state <= i_state;
	end process;
end behavior;


		
