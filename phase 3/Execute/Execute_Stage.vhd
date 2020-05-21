library ieee;
USE ieee.std_logic_1164.ALL;

-- Utility Entities, register and Muxes for execute stage
ENTITY SP is
PORT ( 
	D : IN std_logic_vector(31 downto 0);
	load : IN std_logic;
	Clk : IN std_logic;
	Q : OUT std_logic_vector(31 downto 0);
	rst: in std_logic);
END SP;

ARCHITECTURE Behavioral of SP is
BEGIN
	PROCESS(clk,load, rst)
	BEGIN
		if(rst ='1') then Q <= (others => '1'); Q(0)<='0'; end if;
		IF(rising_edge(clk)) THEN
			if load = '1' then Q <= D; Q(0)<='0'; end if;
		END IF;
	END PROCESS;
END ARCHITECTURE;

library ieee;
use ieee.std_logic_1164.all;
	
Entity twoInpMux is
	generic (n : integer := 32);
	port(In0, In1: IN std_logic_vector (n-1 downto 0);
	      selector:IN std_logic;
	      out1:    OUT std_logic_vector (n-1 downto 0));
end  twoInpMux;

Architecture seq of twoInpMux is
begin
	out1 <= In0 when selector = '0' else In1;
end Architecture;

library ieee;
use ieee.std_logic_1164.all;
	
Entity threeInpMux is
	generic (n : integer := 32);
	port(R1, Inport, TempSP: IN std_logic_vector (n-1 downto 0);
	      InSignal, oldSP:IN std_logic;
	      out1:    OUT std_logic_vector (n-1 downto 0));
end  threeInpMux;

Architecture seq of threeInpMux is
begin
	out1 <= Inport when InSignal = '1' else TempSP when oldSP='1' else R1;
end Architecture;

library ieee;
use ieee.std_logic_1164.all;
	
Entity FourInpMux is
	generic (n : integer := 32);
	port(PC, PCNew, flagreg, R: IN std_logic_vector (n-1 downto 0);
	      IntSP, Call, flags  :IN std_logic;
	      out1:    OUT std_logic_vector (n-1 downto 0));
end  FourInpMux;

Architecture seq of FourInpMux is
begin
	out1 <= PC when IntSP = '1' else PCNew when Call='1' else flagreg when flags = '1' else R;
end Architecture;
-- Branch Execution and Prediction circuit

library ieee;
USE ieee.std_logic_1164.ALL;
Entity BRexeceution_Prediction is
	port( branch, ZeroFlag: IN std_logic;
	      b: IN std_logic_vector(1 downto 0);  -- old prediction bits
	      F: OUT std_logic_vector(1 downto 0); -- new prediction bits
	      FP:      OUT std_logic);
End Entity;

ARCHITECTURE BRhandling OF BRexeceution_Prediction IS
Begin
	F(1) <= (b(1) and b(0)) or (b(1) and ZeroFlag) or (b(0) and ZeroFlag);
	F(0) <= (b(1) and not(b(0))) or (b(1) and ZeroFlag) or (not(b(0)) and ZeroFlag);
	FP   <= branch and((b(1) and not(ZeroFlag)) or (b(0) and ZeroFlag));
End ARCHITECTURE;

--Execute Stage
library ieee;
USE ieee.std_logic_1164.ALL;

Entity execute is
	port( ControlSignals: IN std_logic_vector(4 downto 0);
	      ControlSignals2:IN std_logic_vector(11 downto 0);
	      PC, PCNew      : IN std_logic_vector(31 downto 0);
	      Rsrcc1,Rsrcc2,InputPORT, fromMem:IN std_logic_vector(31 downto 0);
	      Clk, Rst, Interrupt, branch, ccRfromMem: IN std_logic;
	      predictionBits:  IN std_logic_vector(1 downto 0);
	      OpCode:          IN std_logic_vector(4 downto 0);
	      RADD:            IN std_logic_vector(5 downto 0);
	      Rdst_exec, Rdst_mem : in STD_LOGIC_VECTOR (2 downto 0);
              wb_mem, wb_exec, enableFU   : in STD_LOGIC;
	      Data_ex, Data_mem:   IN std_logic_vector(31 downto 0);
	      NewBits       :  OUT std_logic_vector(1 downto 0);
	      SignalsOUT    :  OUT std_logic_vector(7 downto 0);
	      OutputPort, ALUoutput, WriteData, FPReg, R_br_fetch: out std_logic_vector(31 downto 0);
	      ifJZ, falsepredictioninBR: OUT std_logic;
	      SP           : out std_logic_vector(31 downto 0);
	      FR           : out std_logic_vector(2 downto 0));
End execute;

ARCHITECTURE ExecStage OF execute IS
signal CCR: std_logic_vector(2 downto 0);
signal ALUResult, R1, SPMain, SPTemp: std_logic_vector(31 downto 0);
signal falseprediction, ifJZSig: std_logic;

--controlSignals(4-SP,3-MR,2-MW,1-RW,0-memtoreg)
--controlSignals2(11-int,10-push,9-(call),8-in,7-out,6-ret,5-ints2,4-rti,3-swap,2-fromEA,1-EaH,0-ints3)
--Lev2CTRLsignals(5>EAH, 4>fromEA, 3>we, 2>re, 1>WB, 0>fromMemtoReg)
signal SWAP, SPsignal, Insignal, oldSP, IntPC, intFlag, Call, OUTSIgnal, push, rti,ret,EAH,fromEA,we,re,WB,fromMemToReg: std_logic;
signal flags32, Rsrc1, Rsrc2:  std_logic_vector(31 downto 0);
signal mx1, mx2: std_logic_vector(1 downto 0);
constant zero: std_logic_vector(28 downto 0):="00000000000000000000000000000";
begin
SWAP<= controlSignals2(3); SPsignal<=controlSignals(4); Insignal<=controlSignals2(8);
IntPC<= controlSignals2(0); intFlag<=controlSignals2(5); Call<=controlSignals2(9);
OUTSIgnal<=controlSignals2(7); push<=controlSignals2(10); rti<=controlSignals2(4);
ret<=controlSignals2(6); EAH<=controlSignals2(1); fromEA<=controlSignals2(2); we<=controlSignals(2);
re<=controlSignals(3); WB<=controlSignals(1); fromMemToReg<=controlSignals(0);

flags32<=CCR&Zero;
oldSP <= push or Call or IntPC or intFlag;
ALU_Label: entity work.ALU port map(R1, Rsrc2, OpCode, SWAP, oldSP, ccRfromMem, Rst, fromMem(31 downto 29), ALUResult, CCR);
SP_Label : entity work.SP port map(ALUResult, SPsignal, clk, SPMain, rst);
SP_Temp:   entity work.SP port map(SPMain,'1',clk, SPTemp, rst);
R1Mux:     entity work.twoInpMux port map(Rsrc1, SPMain, SPsignal, R1);
ALUoutMux: entity work.threeInpMux port map(ALUResult, InputPORT, SPTemp, Insignal, oldSP, ALUoutput);
DataWrtmux:entity work.FourInpMux port map(PC, PCNew,flags32, Rsrc1, IntPC, Call, intFlag, WriteData);
BRanchCirc:entity work.BRexeceution_Prediction port map(branch, CCR(0), predictionBits, NewBits, falseprediction); 
FPRdestlBL:entity work.twoInpMux port map(Rsrc1, PCNew, predictionBits(1), FPReg);
SignalsOUT <= rti&ret&EAH&fromEA&we&re&WB&fromMemToReg;
R_br_fetch <= PC;
ifJZSig <= OpCode(4) and not(OpCode(3)) and not(OpCode(2)) and not(OpCode(1)) and not(OpCode(0));
falsepredictioninBR<=falseprediction and ifJZSig;
ifJZ <= ifJZSig;
Sp<=SPMain;
FR<=CCR;
process(OUTSIgnal, Rsrc1)
begin
	if (OUTSIgnal = '1') then OutputPort <= Rsrc1; end if;
end process;
-- Forwarding Unit
FULabel: entity work.EFU port map (clk,enableFU, SWAP, RADD(5 downto 3), RADD(2 downto 0), Rdst_exec, Rdst_mem, wb_mem, wb_exec, mx1, mx2);
R1FUMux: entity work.three_input_mux port map(Rsrcc1, Data_mem, Data_ex, mx1, Rsrc1);
R2FUMux: entity work.three_input_mux port map(Rsrcc2, Data_ex, Data_mem, mx2, Rsrc2);
End ExecStage;

-- EX/Mem buffer
library ieee;
USE ieee.std_logic_1164.ALL;

Entity EX_Mem_Buffer is
	port (clk, stall               : IN   std_logic;
	      rst_Int                  : IN   std_logic_vector(1 downto 0);
	      CTRLsignals_D            : IN   std_logic_vector(7 downto 0);
	      ALUOut_D, writeData_D    : IN   std_logic_vector(31 downto 0);
	      R_dest_D                 : IN   std_logic_vector(2 downto 0);
	      rst_Int_Q                : OUT  std_logic_vector(1 downto 0);
	      CTRLsignals_Q            : OUT  std_logic_vector(7 downto 0);
	      ALUOut_Q, writeData_Q    : OUT  std_logic_vector(31 downto 0);
	      R_dest_Q                 : OUT  std_logic_vector(2 downto 0));
End EX_Mem_Buffer;

Architecture buff of EX_Mem_Buffer is
signal notStall: std_logic;
Begin
notStall <= not(stall);
rst_IntLabel         : entity work.reg32(falling) generic map(2) port map(rst_Int, notStall, clk, rst_Int_Q, '0');
CTRLsignalsLabel     : entity work.reg32(falling) generic map(8) port map(CTRLsignals_D, notStall, clk, CTRLsignals_Q, '0');
ALUOut               : entity work.reg32(falling) port map(ALUOut_D, notStall, clk, ALUOut_Q, '0');
writeData            : entity work.reg32(falling) port map(writeData_D, notStall, clk, writeData_Q, '0');
RdestLabel           : entity work.reg32(falling) generic map(3) port map(R_dest_D, notStall, clk, R_dest_Q, '0');
End buff;