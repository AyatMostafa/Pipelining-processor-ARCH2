library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity counter is Port ( 
	clk : in STD_LOGIC;
	reset: in STD_LOGIC;  --intrupt signal
	limit: IN std_logic_vector(2 downto 0);
	count : OUT std_logic
	);
end counter;

architecture Behavioral of counter is

signal l_count : std_logic_vector( 2 downto 0);
begin
process ( clk , reset, l_count )
variable sigCame: Integer:=0;
begin 

if (reset = '1') then
	l_count <= "000";
	count <= '1';
	sigCame:=1;
elsif (rising_edge(clk)) then
    	if sigCame=1 then
		if (l_count = limit) then
			l_count <= limit;
			count <= '0';
			sigCame:=0;
		else
			l_count <= l_count+1;
			count <= '1';
		end if;
	else 
		count <='0';
	end if;
end if;
END PROCESS;
end Behavioral;