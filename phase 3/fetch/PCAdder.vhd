
library ieee;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity PCAdder is 
	port(
		PCin      :   in std_logic_vector(15 downto 0);
		clk       :   in std_logic;                    	
		NewPC     :   out std_logic_vector(15 downto 0)
	);
end entity PCAdder;

architecture PCAdder_flow of PCAdder is
	
begin
	if rising_edge(clk) then 
		NewPC<= PCin+"0000000000000100" ;
	
end architecture PCAdder_flow;