LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY gen_selector IS  
	PORT (  Is_branch, signal_exec, signal_Me : IN std_logic; 		
  		selectors        : OUT  std_logic_vector(1 downto 0)
		);    
END ENTITY gen_selector;


ARCHITECTURE arch8 OF gen_selector IS
BEGIn
      selectors <= "01" WHEN Is_branch = '1'
		Else  "10" When signal_exec = '1'
		Else  "11" when signal_Me = '1'
                Else  "00";
END arch8;
