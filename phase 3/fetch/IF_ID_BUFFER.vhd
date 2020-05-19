library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity IF_ID_BUFFER is
     port (
	clk, we, rst, decEnable : IN std_logic;
	PC, PCAdder : IN std_logic_vector(31 downto 0);
	IR, Imm_val : IN std_logic_vector(15 downto 0);
	Branch  : IN std_logic;
	pred_bits : IN std_logic_vector( 1 downto 0);
	RESET, INT : IN std_logic;
	
	PC_out, PCAdder_out : out std_logic_vector(31 downto 0);
	IR_out, Imm_val_out : Out std_logic_vector(15 downto 0);
	Branch_out  : Out std_logic;
	pred_bits_out : Out std_logic_vector( 1 downto 0);
	RESET_out, INT_out : out std_logic
	);
end IF_ID_BUFFER;

architecture arch_F_BUFFER of IF_ID_BUFFER is
signal IRenable: std_logic;

begin
	IRenable <= we and decEnable;
	lab :entity work.reg32(falling) generic map(32) port map(PC, we, clk, PC_out, rst);
	lab2 :entity work.reg32(falling) generic map(32) port map(PCAdder, we, clk, PCAdder_out, rst);
	lab3:entity work.reg32(falling) generic map(16) port map(IR, IRenable, clk, IR_out, rst);
	lab4:entity work.reg32(falling) generic map(16) port map(Imm_val, we, clk, Imm_val_out, rst);
	lab5:entity work.reg32(falling) generic map(2) port map(pred_bits, we, clk, pred_bits_out, rst);
	
	PROCESS(CLK, RST)
    BEGIN
        IF falling_EDGE(CLK) THEN
            IF rst ='1' THEN
                Branch_out	<= '0';
		RESET_out <= '0';
		INT_out   <= '0';
				
            ELSIF we='1' THEN
                Branch_out <= Branch;
		RESET_out <= RESET;
		INT_out   <= INT;
            END IF;
        END IF;
    END PROCESS;


end arch_F_BUFFER;
