library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity IF_ID_BUFFER is
     port (
	PC : IN std_logic_vector(31 downto 0);
	IR, Imm_val : IN std_logic_vector(15 downto 0);
	stall, Branch  : IN std_logic;
	pred_bits : IN std_logic_vector( 1 downto 0);
	RESET, INT : IN std_logic;
	clk, we : IN std_logic;
	);
end IF_ID_BUFFER;

architecture arch_F_BUFFER of IF_ID_BUFFER is


	
begin
	lab:entity work.reg32(falling) generic map(16) port map(D, load, clk, Q1, rst);
	
end arch_F_BUFFER;

