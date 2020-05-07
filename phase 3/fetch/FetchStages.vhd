library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity FetchStage is
     port (
	  CLK, Rst, INT : in std_logic;	
	  PC_RST : in std_logic;
	  disable_pc : in std_logic;
	  wrong_P_signal , Mem_PC_signal : in std_logic;
	  PC_exec, Pc_mem : in std_logic_vector(31 downto 0);
	  address_for_p : in std_logic_vector(31 downto 0);
	  new_state_p  : in std_logic_vector(1 downto 0);
	  WE_P    : IN std_logic;
	
	  
	  IR, Imm_value : Out std_logic_vector(15 downto 0);
	  PC : Out std_logic_vector(31 downto 0);
	  IsBranch : out std_logic;
	  Prediction: out std_logic_vector(1 downto 0);
	  stall, Reset : out std_logic
	);
end FetchStage;

architecture arch_fetch of FetchStage is
signal PC_normal, PC_decode, PC_out_MUX, PC_out: std_logic_vector(31 downto 0);
signal selector : std_logic_vector(1 downto 0);
signal istaken, ifJz: std_logic; -- in all cases of branching
signal stall_hazard , Enable : std_logic;
signal IR_out : std_logic_vector(15 downto 0);

begin 
	PCEnable : ENTITY work.GetPCEnable PORT MAP( disable_pc , wrong_P_signal , stall_hazard , Enable);

	PCReg1 : ENTITY work.PCReg PORT MAP( PC_out_MUX, clk, PC_RST, Enable , PC_out);
	
        Add : ENTITY work.Adder PORT MAP( PC_out , PC_normal);

        Mux : ENTITY work.PCMux PORT MAP( PC_normal, PC_decode, PC_exec, Pc_mem, selector, PC_out_MUX);

	gen_sel : ENTITY work.gen_selector PORT MAP( istaken , wrong_P_signal, Mem_PC_signal, selector);

	memory : ENTITY work.InstrMemory PORT MAP(PC_out, address_for_p, WE_P, CLK, new_state_p, IR_out);

	control_branch : ENTITY work.ControlBranch Port Map(IR_out, Clk, istaken, ifJz, PC_decode);

end arch_fetch;
