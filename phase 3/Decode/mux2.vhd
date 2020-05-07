LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux2 IS  
		port(
			in1: in std_logic_vector(15 downto 0);
			in2: in std_logic_vector(15 downto 0);
			F  : out std_logic_vector(15 downto 0);
			sel: in std_logic  
		); 
END ENTITY mux2;


ARCHITECTURE Data_flow OF mux2 IS
BEGIN
     
   F <= in1 when sel = '0'
	else in2;

     
END Data_flow;
