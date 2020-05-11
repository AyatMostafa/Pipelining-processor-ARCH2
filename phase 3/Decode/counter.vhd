library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity counter is Port ( 
	clk : in STD_LOGIC;
	reset: in STD_LOGIC;  --intrupt signal
	count : OUT std_logic
	);
end counter;

architecture Behavioral of counter is

signal l_count : std_logic_vector( 2 downto 0);
begin
process ( clk , reset )
begin 
count <= '0';
if (reset = '1') then
	l_count <= "000";
	count <= '1';
else 
    if(rising_edge(clk)) then
	if (l_count = "101") then
		l_count <= "101";
	else
		l_count <= l_count + 1 ;
		count <= '1';
	end if ;
     end if ;
end if;
END PROCESS;
end Behavioral;