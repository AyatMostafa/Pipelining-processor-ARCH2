LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY GetPCEnable IS  
	PORT (  Pc_enable, stall : IN std_logic; 	--wrong_p	
  		Enable        : OUT  std_logic
		);    
END ENTITY GetPCEnable;


ARCHITECTURE arch9 OF GetPCEnable IS
BEGIn
      process(Pc_enable, stall) is 
      begin
       if(Pc_enable = '0' OR stall='1' ) THEN  -- or wrong_p
      		Enable <= '0';
	else Enable <= '1';
	end If;
     End Process;
END arch9;
