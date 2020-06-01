library ieee;
USE ieee.std_logic_1164.ALL;

package myPackages is
  type Block_Cache is array (7 downto 0) of std_logic_vector(15 downto 0);
  type Cache is array (31 downto 0) of Block_Cache;
  type Taglist is array (31 downto 0) of std_logic_vector(2 downto 0);
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use work.myPackages.all;

entity FetchStage is
     port (
	  CLK: in std_logic;	
	  enable_in: in std_logic;	
	  PC_RST : in std_logic;
	  disable_pc : in std_logic;
	 
	 Decode_WB , Decode_MR ,ID_EX_MR ,ID_EX_WB ,EX_Mem_MR  : in std_logic;
	  ID_EX_Rdst ,IF_ID_Rdst ,EX_Mem_Rdst  : in std_logic_vector(2 downto 0);
	 
 	wrong_P_signal , Mem_PC_signal : in std_logic;
	  PC_exec, Pc_mem, PC_decode: in std_logic_vector(31 downto 0);
	  address_for_p : in std_logic_vector(31 downto 0);
	  new_state_p  : in std_logic_vector(1 downto 0);
	  WE_P    : IN std_logic;
	
	  IR, Imm_value : Out std_logic_vector(15 downto 0);
	  PC : Out std_logic_vector(31 downto 0);
	  PCAdder : Out std_logic_vector(31 downto 0);
	  IsBranch : out std_logic;
	  Prediction: out std_logic_vector(1 downto 0);
	  stall: out std_logic;
	  toInstrCach, ignore: In std_logic;
	  RTCblock: in Block_Cache
	);
end FetchStage;




architecture arch_fetch of FetchStage is
signal PC_normal, PC_out_MUX, PC_out: std_logic_vector(31 downto 0);
signal selector : std_logic_vector(1 downto 0);
signal istaken, ifJz: std_logic; -- in all cases of branching
signal stall_hazard , Enable : std_logic;
signal IR_out : std_logic_vector(15 downto 0);

begin 
	PCEnable : ENTITY work.GetPCEnable PORT MAP( disable_pc, stall_hazard , Enable);

	PCReg1 : ENTITY work.PCReg PORT MAP( PC_out_MUX, clk, PC_RST, Enable , PC_out);
	
        Add : ENTITY work.Adder PORT MAP( PC_out , PC_normal);

        Mux : ENTITY work.PCMux PORT MAP( PC_normal, PC_decode, PC_exec, Pc_mem, selector, PC_out_MUX);

	gen_sel : ENTITY work.gen_selector PORT MAP( istaken , wrong_P_signal, Mem_PC_signal, selector);

	memory : ENTITY work.InstrMemory PORT MAP(PC_out, address_for_p, WE_P, CLK, new_state_p, IR_out);
	--cacheInstrLabel: entity work.Cache_InstructionMemory port map(clk, WE_P, toInstrCach, ignore, PC_out(7 downto 0),address_for_p(7 downto 0),new_state_p, IR_out,RTCblock);
	
	control_branch : ENTITY work.ControlBranch Port Map(IR_out, Clk, istaken, ifJz);
	
	Branching_Data_hazard : ENTITY work.BranchingDataDetectionHazard Port Map(enable_in, istaken, IR_out(8 downto 6),  Decode_WB , Decode_MR ,ID_EX_MR ,ID_EX_WB ,EX_Mem_MR ,ID_EX_Rdst ,IF_ID_Rdst ,EX_Mem_Rdst,stall_hazard);
	
	--stall_hazard<='0';
	IR <= IR_out;
	Imm_value <= IR_out;
	PC <= PC_out;
	PCAdder <= PC_normal;
	ISBranch <= istaken Or ifJz;
	stall <= stall_hazard;
	Prediction <= IR_out(15 downto 14);
	
end arch_fetch;