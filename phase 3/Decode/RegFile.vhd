library IEEE;
use IEEE.STD_LOGIC_1164.all;

package regFilePackage is
	type ram_type is array (0 to 2**3 - 1) of std_logic_vector (31 downto 0);
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use work.regFilePackage.all;

entity RegFile is
     port (
	R1 , R2 : IN std_logic_vector(2 downto 0);
	R_br : IN std_logic_vector(2 downto 0);
	clk, we, rst : IN std_logic;
	write_reg: IN std_logic_vector(2 downto 0);
	write_data: IN std_logic_vector(31 downto 0);
	DataR1, DataR2, Databr : OUT std_logic_vector(31 downto 0);
	RegsOut : out ram_type 
	);
end RegFile;

architecture arch2 of RegFile is
signal ram : ram_type := (others => (others => '0'));
begin
	PROCESS(clk, rst) IS
	BEGIN
	if rst = '1' then ram <= (others => (others => '0')); end if;
	IF rising_edge(clk) THEN
	     IF we = '1' THEN
		ram(to_integer(unsigned(write_reg))) <= write_data;
	     END IF;
	END IF;
	END PROCESS;
	DataR1 <= ram(to_integer(unsigned(R1)));
	DataR2 <= ram(to_integer(unsigned(R2)));
	Databr <= ram(to_integer(unsigned(R_br)));
	RegsOut<= ram;
end arch2;

