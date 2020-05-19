library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity ID_EX_BUFFER is
     port (
	clk, load, rst, int : IN std_logic;
	opCode : IN std_logic_vector(10 downto 0);
	PC, PCAdder : IN std_logic_vector(31 downto 0);
	R1 : IN std_logic_vector(31 downto 0);
	R2 : IN std_logic_vector(31 downto 0);
	controlSignals1 : IN std_logic_vector(7 downto 0);
	controlSignals2 : IN std_logic_vector(11 downto 0);
	Rdst : IN std_logic_vector(2 downto 0);
	Branch  : IN std_logic;
	predBitsIN: IN std_logic_vector(1 downto 0);


	opCode_out : out std_logic_vector(10 downto 0);
	PC_out, PCAdder_out : out std_logic_vector(31 downto 0);
	R1_out : out std_logic_vector(31 downto 0);
	R2_out : out std_logic_vector(31 downto 0);
	controlSignals1_out : out std_logic_vector(7 downto 0);
	controlSignals2_out : out std_logic_vector(11 downto 0);
	Rdst_out : out std_logic_vector(2 downto 0);
	Branch_out, rst_out, int_out  : out std_logic;
	predBitsOUT: OUT std_logic_vector(1 downto 0)
	);
end ID_EX_BUFFER;

architecture arch_D_BUFFER of ID_EX_BUFFER is


begin
	reg :entity work.reg32(falling) generic map(11) port map(opCode, load, clk, opCode_out, '0');
	reg1:entity work.reg32(falling) generic map(32) port map(R1, load, clk, R1_out, '0');
	reg2:entity work.reg32(falling) generic map(32) port map(R2, load, clk, R2_out, '0');
	reg3:entity work.reg32(falling) generic map(8) port map(controlSignals1, load, clk, controlSignals1_out, '0');
	reg4 :entity work.reg32(falling) generic map(12) port map(controlSignals2, load, clk, controlSignals2_out, '0');
	reg5:entity work.reg32(falling) generic map(3) port map(Rdst, load, clk, Rdst_out, '0');
	lab :entity work.reg32(falling) generic map(32) port map(PC, load, clk, PC_out, '0');
	lab2 :entity work.reg32(falling) generic map(32) port map(PCAdder, load, clk, PCAdder_out, '0');
	predB:entity work.reg32(falling) generic map(2) port map (predBitsIN, load, clk, predBitsOUT, '0');
	PROCESS(CLK, RST, int, branch)
    BEGIN
        IF falling_EDGE(CLK) THEN
            --IF rst ='1' THEN
            --  Branch_out	<= '0';
	    --	rst_out         <= '0';
	    --  int_out         <= '0';
				
           -- ELSe 
                Branch_out <= Branch;
		rst_out    <= rst;
		int_out    <= int;
		
		
            --END IF;
        END IF;
    END PROCESS;


end arch_D_BUFFER;
