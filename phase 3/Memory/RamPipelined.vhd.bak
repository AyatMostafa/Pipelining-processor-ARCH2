LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.numeric_std.all;

ENTITY RamPipelined IS

PORT (clk : IN std_logic;
we : IN std_logic;
re : IN std_logic;
reset : IN std_logic;
interrupt : IN std_logic;
addressIN : IN std_logic_vector(10 DOWNTO 0);
datain : IN std_logic_vector(31 DOWNTO 0);
dataout : OUT std_logic_vector(31 DOWNTO 0) );
END ENTITY RamPipelined;

ARCHITECTURE sync_ram_a OF RamPipelined IS

TYPE ram_type IS ARRAY(0 TO 2047) of std_logic_vector(15 DOWNTO 0);

SIGNAL ram : ram_type := (
 0=> "0000000000000000",
 1=> "0000000000000000",
 2=> "0000011111000010",
 3=> "0000000000000010",
 4=> "0000011111000011",
 5=> "0000000000000011",
 6=> "0000011111000100",
 7=> "0000000000000100",
 8=> "0000011111000101",
 9=> "0000000000000101",
 10=> "1011001000000001",
 11=> "1010101000000010",
 12=> "1010011000000011",
 13=> "1010010000000100",
 14=> "1101000000000001",
 15=> "1010000000000101",
 16=> "1111101000000000",
 17=> "0000000000010001",
 18=> "1101000011110011",
 19=> "0001000001000010",
 20=> "1111101100000000",
OTHERS=>X"0000"
);
BEGIN

PROCESS(clk) IS
variable address: Integer;
BEGIN
address:= to_integer(unsigned(addressIN));
IF rising_edge(clk) THEN

  IF reset='1' THEN
     
     dataout <= ram(1)&ram(0);

  elsif interrupt ='1' THEN

      dataout <= ram(3)&ram(2);

  elsIF we = '1' THEN

     ram(address)   <= datain(15 downto 0);
     ram(address+1) <= datain(31 downto 16);

  elsif  re = '1' THEN

    dataout <= ram(address+1)&ram(address);

  END IF;

END IF;

END PROCESS; 

END sync_ram_a;

