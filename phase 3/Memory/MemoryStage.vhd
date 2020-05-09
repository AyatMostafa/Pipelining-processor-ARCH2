library ieee;
USE ieee.std_logic_1164.ALL;

Entity MemoryStage is 
	port( controlSignals      :IN  std_logic_vector(7 downto 2);
	      ALURes, writeData   :IN  std_logic_vector(31 downto 0);
	      clk                 :IN  std_logic;
	      RST_INT             :IN  std_logic_vector(1 downto 0);
	      ALUOut, DataRead    :OUT std_logic_vector(31 downto 0);
	      LDflags_Out, LDPC   :OUT std_logic);
End MemoryStage;

Architecture Mem of MemoryStage is

--Lev2CTRLsignals(7>rti, 6>ret, 5>EAH, 4>fromEA, 3>we, 2>re, 1>WB, 0>fromMemtoReg)
signal EAreg, EAInp: std_logic_vector(3 downto 0);
signal address, AddfromEA: std_logic_vector(10 downto 0);
signal EATotal: std_logic_vector(19 downto 0);
Begin
EAInp <= ALURes(15)&ALURes(5 downto 3);
EATotal<= EAreg& ALURes(15 downto 0);
AddfromEA<= EATotal(10 downto 0);
EARegLabel:    entity work.reg32(rising) generic map(4) port map(EAInp, controlSignals(5), clk, EAreg, RST_INT(1));
addresMuxLabel:entity work.twoInpMux port map(ALURes(10 downto 0), AddfromEA, controlSignals(4), address); 
RamLabel:      entity work.RamPipelined port map(clk, controlSignals(3), controlSignals(2), RST_INT(1), RST_INT(0), address, WriteData, DataRead);
ALUOut  <= ALURes;
LDflags_Out<= controlSignals(7);
LDPC<= controlSignals(6) or RST_INT(0) or RST_INT(1);
End Mem;  

-- Mem/WB_Buffer
library ieee;
USE ieee.std_logic_1164.ALL;

Entity M_WB_Buffer is
	port (clk, stall               : IN std_logic;
	      MemToReg_WB_D            : IN std_logic_vector(1 downto 0);
	      ALUOut_D, DataRead_D     : IN std_logic_vector(31 downto 0);
	      R_dest_D                 : IN std_logic_vector(2 downto 0);
	      MemToReg_WB_Q            : OUT std_logic_vector(1 downto 0);
	      ALUOut_Q , DataRead_Q    : OUT std_logic_vector(31 downto 0);
	      R_dest_Q                 : OUT std_logic_vector(2 downto 0));
End M_WB_Buffer;

Architecture buff of M_WB_Buffer is
signal notStall: std_logic;
Begin
notStall <= not(stall);
ctrlsignalsLabel: entity work.reg32(falling) generic map(2) port map(MemToReg_WB_D, notStall, clk, MemToReg_WB_Q, '0');
ALUOutLabel     : entity work.reg32(falling) port map(ALUOut_D, notStall, clk, ALUOut_Q, '0');
DataReadLabel   : entity work.reg32(falling) port map(DataRead_D, notStall, clk, DataRead_Q, '0');
RdestLabel      : entity work.reg32(falling) generic map(3) port map(R_dest_D, notStall, clk, R_dest_Q, '0');
End buff;

library ieee;
USE ieee.std_logic_1164.ALL;

Entity WB_stage is
	port (ALUOut, MemOut : IN  std_logic_vector(31 downto 0);
	      MemToReg       : IN  std_logic;
	      WriteBack      : OUT std_logic_vector(31 downto 0));
End WB_stage;

Architecture WB of WB_stage is 
Begin
	writeDataMuxlabel: entity work.twoInpMux port map(ALUOut, MemOut, MemToReg, WriteBack);
End WB;
