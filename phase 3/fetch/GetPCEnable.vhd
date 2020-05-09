LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY GetPCEnable IS  
	PORT (  Pc_disable, wrong_P_signal, stall : IN std_logic; 		
  		Enable        : OUT  std_logic
		);    
END ENTITY GetPCEnable;


ARCHITECTURE arch9 OF GetPCEnable IS
BEGIn
      process(Pc_disable, wrong_P_signal, stall) is 
      begin
       if(Pc_disable = '1' OR wrong_P_signal ='1' OR stall='1' ) THEN
      		Enable <= '0';
	else Enable <= '1';
	end If;
     End Process;
END arch9;
