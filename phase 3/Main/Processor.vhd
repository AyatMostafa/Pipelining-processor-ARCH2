library ieee;
USE ieee.std_logic_1164.ALL;
use work.regFilePackage.all;

Entity processor is 
	port( clk, rst, Interrupt   : IN  std_logic;
	      --PC_RST                : IN  std_logic;	
	      InPort                : IN  std_logic_vector(31 downto 0);
	      OutPort               : OUT std_logic_vector(31 downto 0));
End processor;

Architecture pipeline of processor is
-- Signals for simulation
signal registerfile: ram_type;
signal PC_out, SP_out: std_logic_vector(31 downto 0);
signal flagRegister_CNZ: std_logic_vector(2 downto 0);

--signals from IF/ID buffer
signal  En_IF_ID, rst_IF_ID : std_logic;
signal  PC_Adder_out : std_logic_vector(31 downto 0);
signal	IR_out, Imm_val_out : std_logic_vector(15 downto 0);
signal	Branch_out  : std_logic;
signal	pred_bits_out : std_logic_vector( 1 downto 0);
signal	RESET_out, INT_out : std_logic;

--signals from ID/EX buffer
signal controlSignals:   std_logic_vector(7 downto 0);
signal controlSignals2:  std_logic_vector(11 downto 0);
signal PC, PCNew, Rsrc1, Rsrc2: std_logic_vector(31 downto 0);
signal branch, rst_ID_EX_Q, interrupt_ID_EX_Q :   std_logic;
--signal PredictionBits:   std_logic_vector(1 downto 0);
signal codes       :   std_logic_vector(10 downto 0);
signal Rdst_ID_EX_Q :   std_logic_vector(2 downto 0);
signal PredBits_ID_EX:  std_logic_vector(1 downto 0);

-- Fetch Signals
signal disable_pc : std_logic;  
signal IR, Imm_value : std_logic_vector(15 downto 0);
signal Fe_PC_out : std_logic_vector(31 downto 0);
signal FE_PCAdder : std_logic_vector(31 downto 0);
signal IsBranch : std_logic;
signal Prediction: std_logic_vector(1 downto 0);
signal stall: std_logic;

-- Decode Signals
signal R1, R2, R_br: std_logic_vector(31 downto 0);
signal control_Signals2 :   std_logic_vector(11 downto 0);
signal control_Signals  :   std_logic_vector(7 downto 0);
signal Rdest:  std_logic_vector(2 downto 0);
signal En_ID_EX_buffer: std_logic;


--Execute signals
---------------------------
signal ALUout, WriteData, ALUout_Q, WriteData_Q,FPReg, BR_Add_reg:    std_logic_vector(31 downto 0);   
signal LDflags, falsePrediction, stallAll, BR_Add_sig :   std_logic;
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
signal WriteBack, MTReg, stallAtDec: std_logic;  --stall signal in case of data hazard or memory miss
signal WBsignals : std_logic_vector(1 downto 0);
signal ALUoutFromWB, ReadDatafromWB, WriteBkReg : std_logic_vector(31 downto 0);

--General Signals
---------------------------
signal enableFU: std_logic;

Begin
enableFU <= '1';
stallAll <='0';
WriteBack<= WBsignals(1);
MTReg<= WBsignals(0);
stallAtDec <= stall or stallAll;
rst_intr_ID_EX_Q<= rst_ID_EX_Q & interrupt_ID_EX_Q ;
En_ID_EX_buffer <= not (stallAll);
En_IF_ID <= not(stallAtDec);
FetchLabel: ENTITY work.FetchStage port map(CLK, '0', control_Signals(6), falsePrediction, 
						control_Signals(1),control_Signals(3),controlSignals(3),controlSignals(1),sigOut_EX_Mem_Q(2),
						Rdst_ID_EX_Q,Rdest,Rdst_EX_Mem_Q,rst_ID_EX_Q,Rdst_EX_Mem_Q,
						LDPC, FPReg, ReadDatafromMem, R_br, BR_Add_reg, NewBits, BR_Add_sig,
					     IR, Imm_value, FE_PC_out, FE_PCAdder, IsBranch, Prediction,stall);


IF_DEbuffer: ENTITY work.IF_ID_BUFFER port map(CLK, En_IF_ID, '0', control_Signals(7), FE_PC_out, FE_PCAdder, IR, Imm_value, IsBranch, Prediction, rst, Interrupt, 
						PC_out, PC_Adder_out, IR_out, Imm_val_out, Branch_out, pred_bits_out, RESET_out, INT_out);

DecodeLabel: entity work.DecodeStage port map(IR_out, Imm_val_out, clk, Branch_out, RESET_out, INT_out, WriteBack, stallAtDec,'0',sigOut_EX_Mem_Q(1),controlSignals(1),controlSignals(3),      
						Rdst_Mem_WB_Q , IR(8 downto 6),Rdst_ID_EX_Q,Rdst_EX_Mem_Q,
						WriteBkReg, R1, R2, R_br, control_Signals2, control_Signals, Rdest, registerfile);
ID_EX_buffer:entity work.ID_EX_BUFFER port map(clk, En_ID_EX_buffer, RESET_out, INT_out, IR_out(13 downto 3), PC_out, PC_Adder_out, R1, R2, 
						control_Signals, control_Signals2, Rdest, Branch_out, pred_bits_out, codes, PC, PCNew, Rsrc1, Rsrc2, controlSignals,
						  controlSignals2, Rdst_ID_EX_Q, branch,  rst_ID_EX_Q, interrupt_ID_EX_Q, PredBits_ID_EX);

ExecuteLabel:  entity work.execute port map(controlSignals(4 downto 0), controlSIgnals2, PC, PCNew, Rsrc1, Rsrc2, inPort, ReadDatafromMem, clk, rst_ID_EX_Q, interrupt_ID_EX_Q, 
					    branch, LDflags, PredBits_ID_EX, codes(10 downto 6), codes(5 downto 0), Rdst_EX_Mem_Q, Rdst_Mem_WB_Q, WriteBack, sigOut_EX_Mem_Q(1),
						 enableFU, ALUout_Q, ALUoutFromWB, NewBits, sigOut_EX_Mem_D, OutPort, ALUout, WriteData, FPreg, BR_Add_reg, BR_Add_sig, falsePrediction,
							SP_out, flagRegister_CNZ); 
EX_MemBuffer:  entity work.EX_Mem_Buffer port map(clk, stallAll, rst_intr_ID_EX_Q, sigOut_EX_Mem_D, ALUout, WriteData, Rdst_ID_EX_Q, rst_intr_EX_Mem_Q,
						  sigOut_EX_Mem_Q, ALUout_Q, WriteData_Q, Rdst_EX_Mem_Q);

MemoryLabel:   entity work.MemoryStage port map(sigOut_EX_Mem_Q(7 downto 2), ALUout_Q, WriteData_Q, clk, rst_intr_EX_Mem_Q,
						ReadDatafromMem, LDflags, LDPC);
Mem_WBBuffer:  entity work.M_WB_Buffer port map(clk, stallAll, sigOut_EX_Mem_Q(1 downto 0), ALUout_Q, ReadDatafromMem, Rdst_EX_Mem_Q, WBsignals,
						ALUoutFromWB , ReadDatafromWB, Rdst_Mem_WB_Q);
WB_stage_label:entity work.WB_stage port map(ALUoutFromWB, ReadDatafromWB, MTReg, WriteBkReg);
End pipeline;