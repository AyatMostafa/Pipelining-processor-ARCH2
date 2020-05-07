library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity Adder is
 Port ( A : in STD_LOGIC_vector(31 downto 0);
	 B : Out STD_LOGIC_vector(31 downto 0));
end Adder;
 
architecture adder_arch of Adder is
 
begin
 
 B <= A + 1;
 
end adder_arch;

