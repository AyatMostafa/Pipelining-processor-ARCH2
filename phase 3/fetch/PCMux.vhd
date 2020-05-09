LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PCMux IS  
	PORT (  PC_Normal, Branch_de, Branch_exec, Branch_Mem : std_logic_vector(31 downto 0); 
		SEl	:  IN std_logic_vector(1 downto 0);
  		output        : OUT  std_logic_vector(31 downto 0)
		);    
END ENTITY PCMux;


ARCHITECTURE arch6 OF PCMux IS
BEGIN
     
      output <= PC_Normal WHEN SEl = "00"
		Else  Branch_de When SEl = "01"
		Else  Branch_exec when SEl = "10"
                Else  Branch_Mem;
END arch6;
