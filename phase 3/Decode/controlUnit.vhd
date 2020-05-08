library ieee;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_1164.all;

--controlSignals(DE,FE,)
entity controlUnit is 
	port(
		opcode          :  in std_logic_vector(4 downto 0);
		IfBranch        :  in std_logic;
		Clk		:  in std_logic;
		rst		:  in std_logic;
		--stall           :  out std_logic;
		FetchEnable     :  out std_logic :='0';
		controlSignals2 :  out std_logic_vector(11 downto 0) :="000000000000";
		controlSignals  :  out std_logic_vector(7 downto 0)
	);
end entity controlUnit;

architecture CUFlow of controlUnit is
	signal input : std_logic_vector(1 downto 0);
	signal output : std_logic_vector(1 downto 0);
begin

  SM: entity work.stateMachine port map ( input,Clk,rst,output);

	process(Clk)
	begin 
		if rising_edge(clk) then 
			if(IfBranch = '1') then
				input<="11";
			elsif (opcode = "00010")or (opcode = "00110")or(opcode = "00111")or(opcode = "11100")or (opcode = "11101")or(opcode = "11110")or(opcode = "00000") then--swap iadd shl  shr ldm ldd sdd
				input<="01";		
			elsif  (opcode = "10100")or (opcode = "10101") or (opcode = "10111")then --ret reti intrupt
				input<="10";			
			else
				input<="00";	
			end if;
		end if;
	end process; 

	process(output)
	begin 
		controlSignals2 <= "000000000000"; 
		FetchEnable<='0';
		if(IfBranch = '1') then
			controlSignals <= "11000000"; 	
		elsif(output = "00") then
			if (opcode = "01000") then --nop
				controlSignals <= "11000000";
			elsif (opcode = "01001") or  (opcode = "01010") or (opcode = "01011") then --noy inc dec
				controlSignals <= "11000010";
			elsif (opcode = "00001") or (opcode = "00011") or  (opcode = "00100") or (opcode = "00101") then --add sub and or 
				controlSignals <= "11100010";
			elsif (opcode = "00000") then --swap
				controlSignals <= "00100000";
				FetchEnable<='1';  
			elsif (opcode = "00010") or (opcode = "00110") or  (opcode = "00111") or (opcode = "11100")or (opcode = "11101") or  (opcode = "11110") then 
				controlSignals <= "01000000";--idd shl shr ldm  ldd sdd
				if(opcode = "11101") or (opcode = "11110") then
					controlSignals2(1) <= '1';
				end if;
			elsif (opcode = "11000") then 
				controlSignals <= "11010100";--push
				controlSignals2(10) <= '1';
			elsif (opcode = "11001") then 
				controlSignals <= "11011011";--pop
			elsif (opcode = "10100")or  (opcode = "10101") then 
				controlSignals <= "00011000";--ret reti
				controlSignals2(6) <= '1';
			elsif (opcode = "10111") then 
				controlSignals <= "00010100"; --intrupt
				controlSignals2(11) <= '1';
			elsif (opcode = "10110") then 
				controlSignals <= "00001000"; --reset
			elsif (opcode = "01101") then 
				controlSignals <= "11000010"; --in
				controlSignals2(8) <= '1'; --in
			elsif (opcode = "01100") then 
				controlSignals <= "11000000"; --out
				controlSignals2(7) <= '1';
			end if;

		elsif (output = "01") then
			if (opcode = "10111") then 
				controlSignals <= "00001000"; --intrupt--
				controlSignals2(5) <= '1';
			elsif (opcode = "00000") then 
				controlSignals <= "11100010"; --swap--
				controlSignals2(3) <= '1';
			elsif (opcode = "10100") then 
				controlSignals <= "00000000";--ret--
			elsif (opcode = "10101") then 
				controlSignals <= "00011000";--reti--
				controlSignals2(4) <= '1';
			elsif (opcode = "00010") or (opcode = "00110")or (opcode = "00111")then 
				controlSignals <= "11000010"; --iadd shl shr--
			elsif (opcode = "11100") then 
				controlSignals <= "11001011"; --ldm--	
			elsif (opcode = "11101") or (opcode = "11110")then 
				controlSignals <= "01000000"; --LDD SDD--	
				controlSignals2(2) <= '1';	
			end if;
			
		elsif (opcode = "10") then
			if (opcode = "10100")or  (opcode = "10101") then 
				controlSignals <= "01000000";--ret reti
			--elsif (opcode = "11101") then 
				--controlSignals <= "11001011"; --LDD 
				--controlSignals2(1) <= "1";
			--elsif (opcode = "11110")then 
				--controlSignals <= "11000100"; --SDD--
				--controlSignals2(1) <= "1";
			elsif (opcode = "10111") then 
				controlSignals <= "01010100"; --intrupt--
				controlSignals2(0) <= '1';
			end if;

		elsif (opcode = "11") then
			controlSignals <= "00000000";
		end if;
	
	end process; 
end architecture CUFlow;
