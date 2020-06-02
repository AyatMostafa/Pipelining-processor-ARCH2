library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY Reg32 is
GENERIC(N : INTEGER := 32);
PORT ( 
	D : IN std_logic_vector(N - 1 downto 0);
	load : IN std_logic;
	Clk : IN std_logic;
	Q : OUT std_logic_vector(N - 1 downto 0);
	rst: in std_logic);
END reg32;

ARCHITECTURE falling of Reg32 is
BEGIN
	PROCESS(clk,load, rst)
	BEGIN
		if(rst ='1') then Q <= (others => '0');
		elsIF(falling_edge(clk)) THEN
			if load = '1' then Q <= D; end if;
		END IF;
	END PROCESS;
END ARCHITECTURE;

ARCHITECTURE rising of Reg32 is
BEGIN
	PROCESS(clk,load, rst)
	BEGIN
		if(rst ='1') then Q <= (others => '0');
		elsIF(rising_edge(clk)) THEN
			if load = '1' then Q <= D; end if;
		END IF;
	END PROCESS;
END ARCHITECTURE;