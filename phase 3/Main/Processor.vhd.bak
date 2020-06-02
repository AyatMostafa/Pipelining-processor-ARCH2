library ieee;
USE ieee.std_logic_1164.ALL;

package myPackages is
  type Block_Cache is array (7 downto 0) of std_logic_vector(15 downto 0);
  type Cache is array (31 downto 0) of Block_Cache;
  type Taglist is array (31 downto 0) of std_logic_vector(2 downto 0);
end package;

library ieee;
USE ieee.std_logic_1164.ALL;
use work.regFilePackage.all;
use work.myPackages.all;
Entity processor is 
	port( clk, rst, Interrupt   : IN  std_logic;
	      --PC_RST                : IN  std_logic;	
	      InPort                : IN  std_logic_vector(31 downto 0);
	      OutPort               : OUT std_logic_vector(31 downto 0));
End processor;

Architecture pipeline of processor is
-- Signals for simulation
signal registerfile: ram_type;
signal Fe_PC_out, SP_out: std_logic_vector(31 downto 0);
signal flagRegister_CNZ: std_logic_vector(2 downto 0);

--signals from IF/ID buffer
signal  En_IF_ID, rst_IF_ID : std_logic;
signal  PC_Adder_out : std_logic_vector(31 downto 0);
signal	IR_out, Imm_val_out : std_logic_vector(15 downto 0);
signal	Branch_out  : std_logic;
signal	pred_bits_out : std_logic_vector( 1 downto 0);
signal	RESET_out, INT_out, stall_IF_ID_Q : std_logic;

--signals from ID/EX buffer
signal controlSignals:   std_logic_vector(7 downto 0);
signal controlSignals2:  std_logic_vector(11 downto 0);
signal PC, PCNew, Rsrc1, Rsrc2: std_logic_vector(31 downto 0);
signal branch, rst_ID_EX_Q, interrupt_ID_EX_Q, stall_ID_EX_Q:   std_logic;
--signal PredictionBits:   std_logic_vector(1 downto 0);
signal codes       :   std_logic_vector(10 downto 0);
signal Rdst_ID_EX_Q :   std_logic_vector(2 downto 0);
signal PredBits_ID_EX:  std_logic_vector(1 downto 0);

-- Fetch Signals
signal disable_pc : std_logic;  
signal IR, Imm_value : std_logic_vector(15 downto 0);
signal PC_out : std_logic_vector(31 downto 0);
signal FE_PCAdder : std_logic_vector(31 downto 0);
signal IsBranch : std_logic;
signal Prediction: std_logic_vector(1 downto 0);
signal stall: std_logic;

-- Decode Signals
signal R1, R2, R_br: std_logic_vector(31 downto 0);
signal control_Signals2 :   std_logic_vector(11 downto 0);
signal control_Signals  :   std_logic_vector(7 downto 0);
signal Rdest:  std_logic_vector(2 downto 0);
signal En_ID_EX_buffer, flushAtDec, LDUseStall: std_logic;


--Execute signals
---------------------------
signal ALUout, WriteData, ALUout_Q, WriteData_Q,FPReg, BR_Add_reg:    std_logic_vector(31 downto 0);   
signal LDflags, falsePrediction, stallAll, BR_Add_sig, flushfromExec :   std_logic;
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
signal enableFU, enableHU, enableFlush: std_logic;
signal CachToRam, RamToCach,toInstrCach,ignore: std_logic;
signal addresstoRam: std_logic_vector(10 downto 0);
signal CTRblock, RTCblock: Block_Cache;
signal stall4, stall8, stall4Instr: std_logic;
signal rst_mem,enablePC: std_logic;
Begin
cacheControllerLabel: entity work.Cache_Controller port map(clk, rst_mem, rst_intr_EX_Mem_Q(1), sigOut_EX_Mem_Q(2), sigOut_EX_Mem_Q(3), BR_Add_sig, rst_intr_EX_Mem_Q(0),ALUout_Q(10 downto 3), FE_PC_out(10 downto 3), BR_Add_reg(10 downto 3) ,addresstoRam, CachToRam, RamToCach,toInstrCach,ignore);
MainMemoryLabel: entity work.MainMemory port map(clk, CachToRam, addresstoRam, CTRblock, RTCblock);
counter: entity work.counter port map ( Clk,CachToRam,"1000", stall8);
counter1: entity work.counter port map ( Clk,RamToCach,"0011", stall4);
counter2: entity work.counter port map ( Clk,toInstrCach,"0011", stall4Instr);

enableFU <= '1';
enableHU<='1';
enableFlush <='1';
--stallAll<='0';
process(stall8 ,stall4 , stall4Instr)
begin
if stall8 ='1' or stall4 = '1' or stall4Instr = '1' then stallAll <='1'; else stallAll <='0'; end if;
end process; 

flushAtDec <= flushfromExec when enableFlush = '1' else '0';
WriteBack<= WBsignals(1);
MTReg<= WBsignals(0);
--stallAtDec <= stall or stallAll;
rst_intr_ID_EX_Q<= rst_ID_EX_Q & interrupt_ID_EX_Q ;
En_ID_EX_buffer <= not (stallAll);
En_IF_ID <= not(stallAll) and not(LDUseStall);
enablePC <= control_Signals(6) and not(stallAll);
--En_IF_ID <= not(stallALL);
FetchLabel: ENTITY work.FetchStage port map(CLK, enableHU, '0', enablePC,
						control_Signals(1),control_Signals(3),controlSignals(3),controlSignals(1),sigOut_EX_Mem_Q(2),
						Rdst_ID_EX_Q,Rdest,Rdst_EX_Mem_Q,
						falsePrediction,LDPC, FPReg, ReadDatafromMem, R_br, BR_Add_reg, NewBits, BR_Add_sig,
					     IR, Imm_value, FE_PC_out, FE_PCAdder, IsBranch, Prediction, stall,toInstrCach,ignore,RTCblock);

IF_DEbuffer: ENTITY work.IF_ID_BUFFER port map(CLK, En_IF_ID, '0', control_Signals(7), FE_PC_out, FE_PCAdder, IR, Imm_value, IsBranch, Prediction, rst, Interrupt, stall,
						PC_out, PC_Adder_out, IR_out, Imm_val_out, Branch_out, pred_bits_out, RESET_out, INT_out, stall_IF_ID_Q);

DecodeLabel: entity work.DecodeStage port map(IR_out, Imm_val_out, clk, stallAll, Branch_out, RESET_out, INT_out, WriteBack, enableFU, enableHU, flushAtDec,sigOut_EX_Mem_Q(1),controlSignals(3), stall_IF_ID_Q,      
						Rdst_Mem_WB_Q , IR(8 downto 6),Rdst_ID_EX_Q,Rdst_EX_Mem_Q,
						WriteBkReg, ALUout_Q, R1, R2, R_br, control_Signals2, control_Signals, Rdest, LDUseStall, registerfile);
ID_EX_buffer:entity work.ID_EX_BUFFER port map(clk, En_ID_EX_buffer, RESET_out, INT_out, IR_out(13 downto 3), PC_out, PC_Adder_out, R1, R2, 
						control_Signals, control_Signals2, Rdest, Branch_out, stall_IF_ID_Q, pred_bits_out, codes, PC, PCNew, Rsrc1, Rsrc2, controlSignals,
						  controlSignals2, Rdst_ID_EX_Q, branch,  rst_ID_EX_Q, interrupt_ID_EX_Q, stall_ID_EX_Q, PredBits_ID_EX);

ExecuteLabel:  entity work.execute port map(controlSignals(4 downto 0), controlSIgnals2, PC, PCNew, Rsrc1, Rsrc2, inPort, ReadDatafromMem, clk, rst_ID_EX_Q, interrupt_ID_EX_Q, 
					    branch, LDflags, PredBits_ID_EX, codes(10 downto 6), codes(5 downto 0), Rdst_EX_Mem_Q, Rdst_Mem_WB_Q, WriteBack, sigOut_EX_Mem_Q(1),
						 enableFU, stall_ID_EX_Q, ALUout_Q, WriteBkReg, NewBits, sigOut_EX_Mem_D, OutPort, ALUout, WriteData, FPreg, BR_Add_reg, BR_Add_sig, falsePrediction,
							flushfromExec, SP_out, flagRegister_CNZ, stallAll); 
EX_MemBuffer:  entity work.EX_Mem_Buffer port map(clk, stallAll, rst_intr_ID_EX_Q, sigOut_EX_Mem_D, ALUout, WriteData, Rdst_ID_EX_Q, rst_intr_EX_Mem_Q,
						  sigOut_EX_Mem_Q, ALUout_Q, WriteData_Q, Rdst_EX_Mem_Q);

MemoryLabel:   entity work.MemoryStage port map(sigOut_EX_Mem_Q(7 downto 2), ALUout_Q, WriteData_Q, clk, rst_intr_EX_Mem_Q,
						ReadDatafromMem, LDflags, LDPC,RamToCach,CachToRam,RTCblock,CTRblock);
Mem_WBBuffer:  entity work.M_WB_Buffer port map(clk, stallAll, sigOut_EX_Mem_Q(1 downto 0), ALUout_Q, ReadDatafromMem, Rdst_EX_Mem_Q, WBsignals,
						ALUoutFromWB , ReadDatafromWB, Rdst_Mem_WB_Q);
WB_stage_label:entity work.WB_stage port map(ALUoutFromWB, ReadDatafromWB, MTReg, WriteBkReg);
process(rst_ID_EX_Q, clk, stallAll)
begin
if rst_ID_EX_Q = '1' and falling_edge(clk) and stallAll = '0' then rst_mem <='1'; else rst_mem <= '0'; end if;
end process;

End pipeline;