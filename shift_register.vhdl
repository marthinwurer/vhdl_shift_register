library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_register is
	generic ( N: integer);
	port (
		clk: in std_logic;
		input: in std_logic;
		reset: in std_logic;
		state: out std_logic_vector(N-1 downto 0));
end shift_register;

architecture gaisler of shift_register is
	signal current_s, next_s: std_logic_vector(N-1 downto 0);
begin

	process (input, current_s)
		variable n: std_logic_vector(N-1 downto 0);
	begin
		n := current_s;
		n(0) := input;
		for ii in 1 to N-1 loop
			n(ii) := current_s(ii-1);
		end loop;

		
		-- update next state from variable
		next_s <= n;

		--  update output with current state
		state <= current_s;
	end process;
	
	process (clk, reset)
	begin
		if reset = '1' then
			state <= (others => '0');
			current_s <= (others => '0');

			-- swap internal states
		elsif rising_edge(clk) then current_s <= next_s; end if;
	end process;
end gaisler;


		
