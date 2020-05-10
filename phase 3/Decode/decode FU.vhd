library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_bit_unsigned.all;
use ieee.numeric_std.all;

entity DFU is
Port ( 
clk : IN std_logic;
Rdest_JZ : in STD_LOGIC_VECTOR (2 downto 0);
Rdst_exec : in STD_LOGIC_VECTOR (2 downto 0);
Rdst_mem : in STD_LOGIC_VECTOR (2 downto 0);
wb_mem    : in std_logic;
wb_exec    : in std_logic;
mux1 : out STD_LOGIC_VECTOR (1 downto 0));

end DFU;

architecture Behavioral of DFU is 

signal mx1 : STD_LOGIC_VECTOR (1 downto 0):="00";

begin


PROCESS(clk) IS

BEGIN

IF rising_edge(clk) THEN

  IF wb_exec = '1' and (Rdest_JZ(0)=Rdst_exec(0) and Rdest_JZ(1)=Rdst_exec(1) and Rdest_JZ(2)=Rdst_exec(2)) THEN
     
     mx1 <= "10";

  elsif wb_mem = '1' and  (Rdest_JZ(0)=Rdst_mem(0) and Rdest_JZ(1)=Rdst_mem(1) and Rdest_JZ(2)=Rdst_mem(2)) THEN

      mx1 <= "01";


  else

    mx1 <= "00";

  END IF;

END IF;

mux1<= mx1;

END PROCESS; 


end Behavioral;
