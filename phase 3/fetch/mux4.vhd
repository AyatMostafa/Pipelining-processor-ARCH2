LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux_seq IS 
	PORT (          a,b,c,d : IN std_logic_vector (15 DOWNTO 0);
			s 	: IN  std_logic_vector (1 DOWNTO 0);
			x 	: OUT std_logic_vector (15 DOWNTO 0)
		);
END entity;

ARCHITECTURE a_mux_seq OF mux_seq IS
	BEGIN
		PROCESS(a,b,c,d,s)
		BEGIN
			IF(s = "00") THEN
				x <= a ;
			ELSIF (s = "01") THEN
				x <= b;
			ELSIF (s = "10") THEN
				x <= c;	
			ELSE
				x <= d;
			END IF;
		END PROCESS;
END a_mux_seq;
