library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity ID_EX_BUFFER is
     port (
	clk, load, rst : IN std_logic;
	opCode : IN std_logic_vector(4 downto 0);
	R1 : IN std_logic_vector(31 downto 0);
	R2 : IN std_logic_vector(31 downto 0);
	controlSignals1 : IN std_logic_vector(7 downto 0);
	controlSignals2 : IN std_logic_vector(11 downto 0);
	Rdst : IN std_logic_vector(2 downto 0);
	Branch  : IN std_logic;

	
	opCode_out : out std_logic_vector(4 downto 0);
	R1_out : out std_logic_vector(31 downto 0);
	R2_out : out std_logic_vector(31 downto 0);
	controlSignals1_out : out std_logic_vector(7 downto 0);
	controlSignals2_out : out std_logic_vector(11 downto 0);
	Rdst_out : out std_logic_vector(2 downto 0);
	Branch_out  : out std_logic
	);
end ID_EX_BUFFER;

architecture arch_D_BUFFER of ID_EX_BUFFER is


begin
	reg :entity work.reg32(falling) generic map(5) port map(opCode, load, clk, opCode_out, rst);
	reg1:entity work.reg32(falling) generic map(32) port map(R1, load, clk, R1_out, rst);
	reg2:entity work.reg32(falling) generic map(32) port map(R2, load, clk, R2_out, rst);
	reg3:entity work.reg32(falling) generic map(8) port map(controlSignals1, load, clk, controlSignals1_out, rst);
	reg4 :entity work.reg32(falling) generic map(12) port map(controlSignals2, load, clk, controlSignals2_out, rst);
	reg5:entity work.reg32(falling) generic map(3) port map(Rdst, load, clk, Rdst_out, rst);

	PROCESS(CLK, RST)
    BEGIN
        IF falling_EDGE(CLK) THEN
            IF rst ='1' THEN
                Branch_out	<= '0';
				
            ELSe 
                Branch_out <= Branch;
		
            END IF;
        END IF;
    END PROCESS;


end arch_D_BUFFER;
