 library ieee;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_1164.all;

entity ControlUnit is 
	port(
		opcode          :  in std_logic_vector(15 downto 0);
		IfBranch        :  in std_logic;
		Clk		:  in std_logic;
		rst		:  in std_logic;
		stall           :  out std_logic;
		FetchEnable     :  out std_logic;
		controlSignals  :  out std_logic_vector(9 downto 0)
	);
end entity ControlUnit;

architecture CUorkFlow of ControlUnit is
	signal input : std_logic_vector(2 downto 0);
	signal output : std_logic_vector(2 downto 0);
begin

  SM: entity work.stateMachine port map ( input,Clk,rst,output);

	process(Clk)
	begin 
		if (opcode = "00010")or (opcode = "00110")or(opcode = "00111")or(opcode = "11100")or (opcode = "11101")or(opcode = "11110") then
			input<="01";		
		elsif  (opcode = "00010")or (opcode = "00110") then
			input<="10";			
		else
			input<="00";	
		end if;
	end process; 

	process(output)
	begin 
		if(output < "00") then
			if (opcode = "01000") then --nop
			controlSignals <= "11000000";
			elsif (opcode = "01001") or  (opcode = "01010") or (opcode = "01011") then --noy inc dec
			controlSignals <= "11000010";
			elsif (opcode = "00001") or (opcode = "00011") or  (opcode = "00100") or (opcode = "00101") then --add sub and or 
			controlSignals <= "11100010";
			elsif (opcode = "00000") then --swap
			controlSignals <= "00100000";  
			elsif (opcode = "00010") or (opcode = "00110") or  (opcode = "00111") or (opcode = "11100")or (opcode = "11101") or  (opcode = "11110") then 
			controlSignals <= "01000000";--idd shl shr ldm  ldd sdd
			elsif (opcode = "11000") then 
			controlSignals <= "11010100";--push
			elsif (opcode = "11001") then 
			controlSignals <= "11011011";--pop
			elsif (opcode = "10100")or  (opcode = "10101") then 
			controlSignals <= "00011000";--ret reti
			elsif (opcode = "10111") then 
			controlSignals <= "00010100"; --intrupt
			elsif (opcode = "10110") then 
			controlSignals <= "00001000"; --reset
			elsif (opcode = "01101") then 
			controlSignals <= "11000010"; --in
			elsif (opcode = "01100") then 
			controlSignals <= "11000000"; --out
			end if;

		elsif (output < "01") then
			if (opcode = "10111") then 
			controlSignals <= "00001000"; --intrupt--
			elsif (opcode = "00000") then 
			controlSignals <= "11100010"; --swap--
			elsif (opcode = "10100") then 
			controlSignals <= "00000000";--ret--
			elsif (opcode = "10101") then 
			controlSignals <= "00011000";--reti--
			elsif (opcode = "00010") or (opcode = "00110")then 
			controlSignals <= "11000010"; --iadd shl--
			elsif (opcode = "11100") then 
			controlSignals <= "11001011"; --ldm--	
			elsif (opcode = "11101") or (opcode = "11110")then 
			controlSignals <= "01000000"; --LDD SDD--		
			end if;
			
		elsif (opcode = "10") then
			if (opcode = "10100")or  (opcode = "10101") then 
			controlSignals <= "01000000";--ret reti
			elsif (opcode = "11101") then 
			controlSignals <= "11001011"; --LDD 
			elsif (opcode = "11110")then 
			controlSignals <= "11000100"; --SDD--
			elsif (opcode = "10111") then 
			controlSignals <= "010100100"; --intrupt--
			end if;
		end if;
	
	
	end process; 
end architecture CUorkFlow;
