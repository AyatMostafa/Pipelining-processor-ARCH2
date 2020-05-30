library ieee;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_1164.all;

--controlSignals(DE,FE,ALUsrc,SP,MR,MW,RW,memtoreg)
--controlSignals2(int,push,(call),in,out,ret,ints2,rti,swap,fromEA,EaH,ints3)
entity controlUnit is 
	port(
		int             :  in std_logic;
		opcode          :  in std_logic_vector(4 downto 0);
		IfBranch        :  in std_logic;
		Clk		:  in std_logic;
		rst		:  in std_logic;
		stall           :  in std_logic;
		--FetchEnable     :  out std_logic :='0';
		controlSignals2 :  out std_logic_vector(11 downto 0);-- :="000000000000";
		controlSignals  :  out std_logic_vector(7 downto 0);
		intriptOut, rstOut : out std_logic
	);
end entity controlUnit;

architecture CUFlow of controlUnit is
	signal input : std_logic_vector(1 downto 0);
	signal output : std_logic_vector(1 downto 0);
        signal intript, rstSig : std_logic;
begin

  counter: entity work.counter port map ( Clk,int,"010", intript);
  rstCounter: entity work.counter port map(Clk, rst, "010", rstSig);

  SM     : entity work.stateMachine port map ( input,Clk,rst,stall,output);

  intriptOut <=  intript; 
  rstOut     <=  rstSig;
	process(IfBranch, opcode, int, rst, intript, rstSig)
	begin 
		--if rising_edge(clk) then 
			if  (opcode = "10100")or (opcode = "10101") or (int = '1') or (intript = '1') or(rst = '1') or (rstSig ='1')then --ret reti intrupt reset
				input<="10";			
			elsif (opcode = "00010")or (opcode = "00110")or(opcode = "00111")or(opcode = "11100")or (opcode = "11101")or(opcode = "11110")or(opcode = "00000") then--swap iadd shl  shr ldm ldd sdd
				input<="01";		
			else
				input<="00";	
			end if;
		--end if;
	end process; 

	process(output, IfBranch, opcode, int, rst, intript, rstSig)
	begin 
		controlSignals2 <= "000000000000"; 
		--FetchEnable<='0';
		if(opcode="10010") then       -- Call
			controlSignals2(9) <= '1';
 	 		controlSignals <= "11010100";
		elsif(output = "00") then
			if (intript = '1') or (int ='1') or rst='1' or rstSig='1' then
				controlSignals <= "00001000";
			elsif(IfBranch = '1') then
				controlSignals <= "11000000";
			elsif (opcode = "01000") then --nop
				controlSignals <= "11000000";
			elsif (opcode = "01001") or  (opcode = "01010") or (opcode = "01011") then --not inc dec
				controlSignals <= "11000010";
			elsif (opcode = "00001") or (opcode = "00011") or  (opcode = "00100") or (opcode = "00101") then --add sub and or 
				controlSignals <= "11100010";
			elsif (opcode = "00000") then
				controlSignals <= "00100010";--swap	  
			elsif (opcode = "00010") or (opcode = "00110")or (opcode = "00111")then 
				controlSignals <= "01000000";                                --iadd shl shr--
			elsif (opcode = "11101") or (opcode = "11110")then 
				controlSignals <= "01000000"; --LDD STD --	
				controlSignals2(1) <= '1';
			elsif (opcode = "11100")  then --LDM
				controlSignals <= "01000000";
			elsif (opcode = "11000") then 
				controlSignals <= "11010100";--push
				controlSignals2(10) <= '1';
			elsif (opcode = "11001") then 
				controlSignals <= "11011011";--pop
			elsif (opcode = "01101") then 
				controlSignals <= "11000010"; --in
				controlSignals2(8) <= '1'; 
			elsif (opcode = "01100") then 
				controlSignals <= "11000000"; --out
				controlSignals2(7) <= '1';
			elsif (opcode = "10100") or (opcode = "10101") then              --ret reti 
				controlSignals <= "00011000";	
				controlSignals2(6) <= '1';
			end if;

		elsif(output = "01") then
			if (rst ='1') or (rstSig='1') then  --rst
				controlSignals <= "00000000";
			elsif (intript = '1') or (int ='1') then 
				controlSignals <= "00010100"; --intrupt
				controlSignals2(5) <= '1';
			elsif (opcode = "11100") then 
				controlSignals <= "11000010";       --ldm
			elsif (opcode = "00010") or (opcode = "00110") or  (opcode = "00111") then  --IADD SHL/R
				controlSignals <= "11000010";
			elsif(opcode = "11101")  then        --LDD
				controlSignals <= "11001011";
				controlSignals2(2) <= '1';
			elsif (opcode = "11110") then       --STD
				controlSignals <= "11000100";
				controlSignals2(2) <= '1';
			elsif (opcode = "00000") then 
				controlSignals <= "11100010"; --swap--
				controlSignals2(3) <= '1';
			
			elsif (opcode = "10101") then 
				controlSignals <= "00011000"; -- reti
				controlSignals2(4) <= '1';
			elsif (opcode = "10100") then       --ret
				controlSignals <= "00000000";				
			end if;

		elsif (output = "10") then
			if (rst ='1') or (rstSig='1') then  --rst
				controlSignals <= "01000000";
			elsif (intript = '1') or (int ='1') then 
				controlSignals <= "01010100"; --intrupt--
				controlSignals2(0) <= '1';
			elsif (opcode = "10100") or (opcode = "10101") then 
				controlSignals <= "01000000";  --ret-- rti
			end if;

		elsif (output = "11") then
			controlSignals <= "11000000"; --ret reti interrupt reset
		end if;
				
		--end if;
	end process; 
end architecture CUFlow;
