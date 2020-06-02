library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;


entity ControlBranch is
     port (
	IR : IN std_logic_vector(15 downto 0);
	clk: IN std_logic;
	ifBranch : out std_logic;     -- get rdst to pc 
	ifJZ : out std_logic
	);
	--Rdest : out std_logic_vector(31 downto 0)
	--);
end ControlBranch;

architecture arch3 of ControlBranch is	
signal R1, R2 : std_logic_vector(31 downto 0);
begin
	process(IR) is
	begin
	   ifBranch <= '0'; ifJZ <= '0';
	   if IR(13 downto 9) = "10000"  Then   -- JZ
		if IR(15 downto 14) = "10" OR IR(15 downto 14) = "11" then
			ifBranch <= '1';
		end IF;
	        ifJZ <= '1';
	   ELSIF IR(13 downto 9) = "10001" OR IR(13 downto 9) = "10010" THEN -- JMP OR CALL
		ifBranch <= '1';
	   END IF;
	END PROCESS;	
	--FileReg1 : ENTITY work.RegFile PORT MAP("000", "000", IR(2 downto 0), clk, '0', "000", "00000000000000000000000000000000", R1, R2, Rdest);
end arch3;
