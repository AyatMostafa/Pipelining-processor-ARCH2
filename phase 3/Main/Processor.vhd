library ieee;
USE ieee.std_logic_1164.ALL;

Entity processor is 
	port( clk, rst, Interrupt   : IN  std_logic;
	      InPort                : IN  std_logic_vector(31 downto 0);
	      OutPort               : OUT std_logic_vector(31 downto 0));
End processor;

Architecture pipeline of processor is
--signals from ID/EX buffer
signal controlSignals:   std_logic_vector(4 downto 0);
signal controlSignals2:  std_logic_vector(11 downto 0);
signal PC, PCNew, Rsrc1, Rsrc2: std_logic_vector(31 downto 0);
signal branch, rst_ID_EX_Q, interrupt_ID_EX_Q :   std_logic;
signal PredictionBits:   std_logic_vector(1 downto 0);
signal Opcodes       :   std_logic_vector(4 downto 0);
signal Rdst_ID_EX_Q :   std_logic_vector(2 downto 0);

--Execute signals
---------------------------
signal ALUout, WriteData, ALUout_Q, WriteData_Q,FPReg:    std_logic_vector(31 downto 0);   
signal LDflags, falsePrediction, stallAll :   std_logic;
signal NewBits,rst_intr_ID_EX_Q, rst_intr_EX_Mem_Q :   std_logic_vector(1 downto 0);
signal Rdst_EX_Mem_Q                      :   std_logic_vector(2 downto 0);
signal sigOut_EX_Mem_D, sigOut_EX_Mem_Q    :   std_logic_vector(7 downto 0);       -- Wb&fromMemToReg

--Memory Signals
----------------------------
signal ALUoutFromMem, ReadDatafromMem : std_logic_vector(31 downto 0);
signal LDPC                           : std_logic;
signal Rdst_Mem_WB_Q                  : std_logic_vector(2 downto 0);

--Write Back Signals
----------------------------
signal WriteBack, MTReg: std_logic;
signal WBsignals : std_logic_vector(1 downto 0);
signal ALUoutFromWB, ReadDatafromWB, WriteBkReg : std_logic_vector(31 downto 0);
Begin
WriteBack<= WBsignals(1);
MTReg<= WBsignals(0);
rst_intr_ID_EX_Q<= rst_ID_EX_Q & interrupt_ID_EX_Q ;
ExecuteLabel:  entity work.execute port map(controlSignals, controlSIgnals2, PC, PCNew, Rsrc1, Rsrc2, inPort, ReadDatafromMem, clk, rst_ID_EX_Q, interrupt_ID_EX_Q, 
					    branch, LDflags, predictionBits, Opcodes, NewBits, sigOut_EX_Mem_D, OutPort, ALUout, WriteData, 
					    FPreg, falsePrediction); 
EX_MemBuffer:  entity work.EX_Mem_Buffer port map(clk, stallAll, rst_intr_ID_EX_Q, sigOut_EX_Mem_D, ALUout, WriteData, Rdst_ID_EX_Q, rst_intr_EX_Mem_Q,
						  sigOut_EX_Mem_Q, ALUout_Q, WriteData_Q, Rdst_EX_Mem_Q);

MemoryLabel:   entity work.MemoryStage port map(sigOut_EX_Mem_Q(7 downto 2), ALUout_Q, WriteData_Q, clk, rst_intr_EX_Mem_Q,
						ReadDatafromMem, LDflags, LDPC);
Mem_WBBuffer:  entity work.M_WB_Buffer port map(clk, stallAll, sigOut_EX_Mem_Q(1 downto 0), ALUout_Q, ReadDatafromMem, Rdst_EX_Mem_Q, WBsignals,
						ALUoutFromWB , ReadDatafromWB, Rdst_Mem_WB_Q);
WB_stage_label:entity work.WB_stage port map(ALUoutFromWB, ReadDatafromWB, MTReg, WriteBkReg);
End pipeline;