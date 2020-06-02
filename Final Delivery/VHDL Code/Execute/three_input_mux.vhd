library ieee;
use ieee.std_logic_1164.all;
	
Entity three_input_mux is
	generic (n : integer := 32);
	port(In1, In2, In3: IN std_logic_vector (n-1 downto 0);
	      sel:IN std_logic_vector (1 downto 0);
	      out1:    OUT std_logic_vector (n-1 downto 0));
end  three_input_mux;

Architecture mux_flow of three_input_mux is
begin

PROCESS (sel, In1, In2, In3)
BEGIN
	if(sel = "00") then
		out1<=In1;
	elsif (sel = "01") then
		out1<=In2;		
	elsif  (sel = "10")then
		out1<=In3;			
	end if;
 
 
END PROCESS;
end Architecture;


