library ieee;
USE ieee.std_logic_1164.ALL;

package my_types_pkg is
  type array32 is array (31 downto 0) of std_logic_vector(31 downto 0);
end package;

library ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

-- SHift left/Right Circuitry
Entity shift is 
	port( operand, selector: IN std_logic_vector(31 downto 0);
	      L: IN std_logic;
	      output: OUT std_logic_vector(31 downto 0);
	      carry: OUT std_logic);
end shift;

use work.my_types_pkg.all;

Architecture seq of shift is
signal temp : array32;
constant Zero: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
begin
	process(operand, L)
	begin
		temp(0) <= operand;
		if L ='0' then
			M: for I in 30 downto 0 loop
			Mi:temp(31-I) <= operand(I downto 0)  & Zero(31 downto I+1);
			end loop;
		else
			N: for I in 30 downto 0 loop
			Ni:temp(31-I) <= Zero(31 downto I+1) & operand(31 downto (31-I));
			end loop;
		end if;
	end process;
	process(selector, temp)
	begin
		output <= Zero;
		if unsigned(selector) < 32 then output <= temp(to_integer(unsigned(selector(4 downto 0))));
		end if;
	end process;
	process(selector, Operand, L)
	begin
		if L = '0' then 
			if unsigned(selector) < 32 then carry <= operand(to_integer(32 - unsigned (selector(4 downto 0))));
			elsif unsigned(selector) = 32 then carry <= operand(0);
			else carry <= '0';	
			end if;
		else
			if unsigned(selector) < 32 then carry <= operand(to_integer(unsigned (selector(4 downto 0)) - 1));
			elsif unsigned(selector) = 32 then carry <= operand(31);
			else carry <= '0';	
			end if;		
	end if;
	end process;
END Architecture;

library ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;


Entity ALU is
	port( src1, src2: IN std_logic_vector(31 downto 0);
	      opCode: IN std_logic_vector(4 downto 0);
	      Swap, SpMinus2, fromMem, RST, int, flushed: IN std_logic;
	      flags : IN std_logic_vector(2 downto 0);
	      output: OUT std_logic_vector(31 downto 0);
	      CCRValue: OUT std_logic_vector(2 downto 0));
End ALU;

Architecture ALUArch of ALU is
signal shiftleft: std_logic_vector(31 downto 0);
signal shiftright, result: std_logic_vector(31 downto 0);
signal SHLCarry, SHRCarry, noChgFlags: std_logic;
Begin
	--ALU main functionality
	shift_L: entity work.shift port map (src1, src2, '0', shiftleft,  SHLCarry);
	shift_R: entity work.shift port map (src1, src2, '1', shiftright, SHRCarry);
	process (opCode, Swap, RST, src1, src2,SpMinus2, SHLCarry, SHRCarry, shiftleft, shiftright)
	variable operation: unsigned (4 downto 0);
	variable Arith: std_logic_vector(32 downto 0);
	constant One: std_logic_vector(31 downto 0) := "00000000000000000000000000000001";
	constant Two: std_logic_vector(31 downto 0) := "00000000000000000000000000000010";
	begin
		noChgFlags<='0';
		operation := unsigned(opCode);
		if int = '1' then result <= ONE; noChgFlags <= '1';
		elsif SpMinus2 = '1' then result <= unsigned(src1) - unsigned(Two);   --intS2, intS3, Call, Push
		elsif RST = '1' then CCRValue(2) <= '0'; elsif fromMem ='1' then CCRValue(2) <= flags(2);
		elsif operation = 0 then if Swap = '0' then result <= src1; else result <= src2; end if;     --SWAP
		elsif operation = 1 or operation = 2 then                                                    --ADD, IADD
			 Arith := unsigned('0'&src1) + unsigned('0'&src2); 
			 result<= Arith (31 downto 0); 
			 if flushed = '0' then CCRValue(2) <= Arith(32); end if;
		elsif operation = 3 then
			 Arith := unsigned('1'&src1) - unsigned('0'&src2);         --SUB
			 result<= Arith (31 downto 0); 
			 if flushed = '0' then CCRValue(2) <= Arith(32); end if;
		elsif operation = 4 then result <= src1 and src2;                                            --AND
		elsif operation = 5 then result <= src1 or src2;                                             --OR
		elsif operation = 6 then result <= shiftleft;  CCRValue(2) <= SHLCarry;                      --SHL
		elsif operation = 7 then result <= shiftright; CCRValue(2) <= SHRCarry;                      --SHR
		-- (8==> NOP    12==> OUT    13==> IN )
		elsif operation = 9  then result <= not (src1);                                              --NOT
		elsif operation = 10 then                           --INC
			 Arith := unsigned('0'&src1) + unsigned('0'&ONE); 
			 result<= Arith (31 downto 0); 
			 if flushed = '0' then CCRValue(2) <= Arith(32); end if;
		elsif operation = 11 then                           --DEC
			 Arith := unsigned('1'&src1) - unsigned('0'&ONE);    
			 result<= Arith (31 downto 0); 
			 if flushed = '0' then CCRValue(2) <= Arith(32); end if;
		elsif operation = 20 or operation = 21 or operation = 25 then result <= unsigned(src1) + unsigned(Two); --RET, RTI, pop
		elsif operation = 28 or operation = 29 or operation = 30 then result <= src2;     --LDM, LDD, STD
		else result <= ONE; noChgFlags <= '1';
		end if;
	end process;
	output <= result;
	-- CCR (N & Z) handling
	process (result, opCode, RST, noChgFlags, flags)
	variable operation: unsigned (4 downto 0);
	constant Zero: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	begin
		operation := unsigned(opCode);
		if RST = '1' then CCRValue(1 downto 0) <= "00"; elsif fromMem ='1' then CCRValue(1 downto 0) <= flags(1 downto 0); 
		elsif oPcode(4) = '0' and operation /= 8 and operation /= 12 and operation /= 13 and operation /= 6 and operation /= 7 and flushed = '0' and noChgFlags = '0'
		then CCRValue(1) <= result(31); if result = Zero then CCRValue(0) <= '1'; else CCRValue(0) <= '0'; end if;
		elsif operation = 16 and noChgFlags = '0' then CCRValue(0) <= '0'; 
		end if;
	end process;
End Architecture;