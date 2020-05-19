library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use std.textio.all;

entity InstrMemory is
     port (
	PC : IN std_logic_vector(31 downto 0);
	address : IN  std_logic_vector(31 DOWNTO 0);
	we : IN std_logic;
	clk : IN std_logic;
	newState : IN std_logic_vector(1 DOWNTO 0);
	IR_out : OUT std_logic_vector(15 DOWNTO 0) 
	);
end InstrMemory;

architecture arch of InstrMemory is

type ram_type is array (0 to 2**11 - 1) of std_logic_vector(15 downto 0);

impure function read_file return ram_type is
	file ram_file : text open read_mode is "initialRAM.txt";
	variable txt_line : line;
	variable txt_bit : bit_vector(15 downto 0);
	variable txt_ram : ram_type;
	variable count : integer;
	
	BEGIN
	count := 0;
	while not ENDFILE(ram_file) loop
	      readline(ram_file , txt_line);
	      read(txt_line, txt_bit);
	      txt_ram(count) := to_stdlogicvector(txt_bit);
	      count := count+1;
	end loop;
	txt_ram(count to 2**11 - 1) := (others=>(others=>'0'));
	file_close(ram_file);
	return txt_ram;
end function;
	
	signal ram : ram_type := read_file;
	signal data_reg,temp : std_logic_vector(15 downto 0);
begin
	PROCESS(clk) IS
	BEGIN
	IF rising_edge(clk) THEN
	     IF we = '1' THEN
		temp <= ram(to_integer(unsigned(address(10 downto 0))));
		temp <= newState & temp(13 downto 0);
		ram(to_integer(unsigned(address(10 downto 0)))) <= temp;
	     END IF;
	END IF;
	END PROCESS;
	IR_out <= ram(to_integer(unsigned(PC(10 downto 0))));
end arch;
