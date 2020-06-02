library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_bit_unsigned.all;
use ieee.numeric_std.all;

entity EFU is
Port ( 
clk : IN std_logic;
enable : in std_logic;
if_swap : in std_logic;
Rsr1 : in STD_LOGIC_VECTOR (2 downto 0);
Rsr2 : in STD_LOGIC_VECTOR (2 downto 0);
Rdst_exec : in STD_LOGIC_VECTOR (2 downto 0);
Rdst_mem : in STD_LOGIC_VECTOR (2 downto 0);
wb_mem    : in std_logic;
wb_exec    : in std_logic;
mux1 : out STD_LOGIC_VECTOR (1 downto 0);
mux2 : out STD_LOGIC_VECTOR (1 downto 0));

end EFU;

architecture Behavioral of EFU is 

--signal mx1 : STD_LOGIC_VECTOR (1 downto 0):="00";
--signal mx2 : STD_LOGIC_VECTOR (1 downto 0):="00";
begin

PROCESS(clk,enable, wb_exec, Rsr1, Rdst_exec, wb_mem, Rdst_mem, Rsr2) IS

BEGIN

if enable = '1' then
   --IF rising_edge(clk) THEN

     IF wb_exec = '1' and (Rsr1(0)=Rdst_exec(0) and Rsr1(1)=Rdst_exec(1) and Rsr1(2)=Rdst_exec(2)) and if_swap='0' THEN
     
        mux1 <= "10";

     elsif wb_mem = '1' and  (Rsr1(0)=Rdst_mem(0) and Rsr1(1)=Rdst_mem(1) and Rsr1(2)=Rdst_mem(2)) THEN

         mux1 <= "01";


     else

	 mux1 <= "00";
       

     END IF;
	
     IF wb_exec = '1' and (Rsr2(0)=Rdst_exec(0) and Rsr2(1)=Rdst_exec(1) and Rsr2(2)=Rdst_exec(2)) and if_swap='0' THEN
     
        mux2 <= "01";

     elsif wb_mem = '1' and  (Rsr2(0)=Rdst_mem(0) and Rsr2(1)=Rdst_mem(1) and Rsr2(2)=Rdst_mem(2)) THEN

         mux2 <= "10";
     else

	mux2 <= "00";
         

     END IF;

   --END IF;

else
   mux1<="00";
   mux2<="00";
END IF;
--mux1<= mx1;
--mux2<= mx2;

END PROCESS; 


end Behavioral;
