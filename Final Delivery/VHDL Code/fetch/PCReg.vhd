LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity PCReg is
    port(
        d : IN std_logic_vector(31 DOWNTO 0);
        Clk, Rst, Enable : IN std_logic;
        q   : OUT std_logic_vector(31 DOWNTO 0));
end PCReg;

ARCHITECTURE arch4 OF PCReg IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
	q <= (OTHERS=>'0');
ELSIF falling_edge(Clk) and Enable = '1' THEN
	q <= d;
END IF;
END PROCESS;
END arch4;

