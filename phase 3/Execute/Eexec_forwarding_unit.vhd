library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_bit_unsigned.all;
use ieee.numeric_std.all;

entity EFU is
Port ( 
clk : IN std_logic;
enable : in std_logic;
if_swap : in std_logic;
Rsrc1 : in STD_LOGIC_VECTOR (2 downto 0);
Rsrc2 : in STD_LOGIC_VECTOR (2 downto 0);
Rdst_exec : in STD_LOGIC_VECTOR (2 downto 0);
Rdst_mem : in STD_LOGIC_VECTOR (2 downto 0);
wb_mem    : in std_logic;
wb_exec    : in std_logic;
mux1 : out STD_LOGIC_VECTOR (1 downto 0);
mux2 : out STD_LOGIC_VECTOR (1 downto 0));

end EFU;

architecture Behavioral of EFU is 

signal mx1 : STD_LOGIC_VECTOR (1 downto 0):="00";
signal mx2 : STD_LOGIC_VECTOR (1 downto 0):="00";
begin

PROCESS(clk) IS

BEGIN

if enable = '1' then
   IF rising_edge(clk) THEN

     IF wb_exec = '1' and (Rsrc1(0)=Rdst_exec(0) and Rsrc1(1)=Rdst_exec(1) and Rsrc1(2)=Rdst_exec(2)) and if_swap='0' THEN
     
        mx1 <= "10";

     elsif wb_mem = '1' and  (Rsrc1(0)=Rdst_mem(0) and Rsrc1(1)=Rdst_mem(1) and Rsrc1(2)=Rdst_mem(2)) THEN

         mx1 <= "01";


     else

       mx1 <= "00";

     END IF;

     IF wb_exec = '1' and (Rsrc2(0)=Rdst_exec(0) and Rsrc2(1)=Rdst_exec(1) and Rsrc2(2)=Rdst_exec(2)) and if_swap='0' THEN
     
        mx2 <= "01";

     elsif wb_mem = '1' and  (Rsrc2(0)=Rdst_mem(0) and Rsrc2(1)=Rdst_mem(1) and Rsrc2(2)=Rdst_mem(2)) THEN

         mx2 <= "10";
     else

         mx2 <= "00";

     END IF;

   END IF;

else
   mx1<="00";
   mx2<="00";
END IF;
mux1<= mx1;
mux2<= mx2;

END PROCESS; 


end Behavioral;
