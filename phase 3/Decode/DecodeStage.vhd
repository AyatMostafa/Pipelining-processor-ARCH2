Library ieee;
use ieee.std_logic_1164.all;

entity DecodeStage is
	port( IR, Imm_val : IN std_logic_vector(15 downto 0);
	      clk, Branch, rst, interrupt, WriteReg, stall: IN std_logic;
	      Rwrite, Add_BR_Reg: IN std_logic_vector(2 downto 0);
	      writeData: IN std_logic_vector(31 downto 0);
	      R1, R2, R_br: OUT std_logic_vector(31 downto 0);
	      controlSignals2 :  out std_logic_vector(11 downto 0);
	      controlSignals  :  out std_logic_vector(7 downto 0);
	      Rdest:  out std_logic_vector(2 downto 0));
end entity;

Architecture decStage of DecodeStage is
signal signals2: std_logic_vector(11 downto 0);
signal signals: std_logic_vector(7 downto 0);
signal extended1, extended2, extendedIMM, R2Temp:std_logic_vector(31 downto 0);
constant zeros: std_logic_vector(15 downto 0):="0000000000000000";
constant ones: std_logic_vector(15 downto 0):="1111111111111111";
Begin
CULabel:   entity work.controlUnit port map(interrupt, IR(13 downto 9), branch, clk, rst, signals2, signals);
signals2L: entity work.twoInpMux generic map(12) port map (signals2, "000000000000", stall, controlSignals2);
signalsL:  entity work.twoInpMux generic map(8) port map (signals,"00000000", stall, controlSignals);
FileRegL : ENTITY work.RegFile PORT MAP(IR(8 downto 6), IR(5 downto 3), Add_BR_Reg, clk, WriteReg, rst, Rwrite, writeData, R1, R2Temp, R_br);
extended1 <= zeros & Imm_val;
extended2 <= ones & Imm_val;
extendedL: entity work.twoInpMux port map (extended1, extended2, Imm_val(15), extendedIMM);
sndOpMuxL: entity work.twoInpMux port map (extendedIMM, R2Temp, signals(5), R2);
RdestMuxL: entity work.twoInpMux generic map(3) port map (IR(2 downto 0), IR(8 downto 6), signals2(3), Rdest);

end Architecture;