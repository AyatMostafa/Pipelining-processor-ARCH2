LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Hazard_Load_case IS  
	PORT (  
		enable   : IN  std_logic;
		ID_EX_MemRead :IN std_logic; 
		ID_EX_Rt, IF_ID_S1, IF_ID_S2:  IN std_logic_vector(2 downto 0);
  		Hazard   : OUT  std_logic
		);    
END ENTITY Hazard_Load_case;


ARCHITECTURE Hazard_arch OF Hazard_Load_case IS
BEGIN
   	

    process(enable)
    BEGIN
if (enable='1') then
	if(ID_EX_MemRead = '1')and (ID_EX_Rt = IF_ID_S1 or ID_EX_Rt = IF_ID_S2) then
		Hazard <= '1';
	else
		Hazard <= '0';
	end if;
end if;
     END PROCESS;
END Hazard_arch;
