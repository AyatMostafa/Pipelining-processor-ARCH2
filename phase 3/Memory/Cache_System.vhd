library ieee;
USE ieee.std_logic_1164.ALL;

package myPackages is
  type Block_Cache is array (7 downto 0) of std_logic_vector(15 downto 0);
  type Cache is array (31 downto 0) of Block_Cache;
  type Taglist is array (31 downto 0) of std_logic_vector(2 downto 0);
end package;

library ieee;
USE ieee.std_logic_1164.ALL;
--use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;

use work.myPackages.all;

Entity Cache_DataMemory is
	PORT (clk : IN std_logic;
	      MR, MW, RamRead, NoWrite : IN std_logic;
	      address : IN std_logic_vector(7 DOWNTO 0);
	      datain : IN std_logic_vector(31 DOWNTO 0);
	      dataout : OUT std_logic_vector(31 DOWNTO 0);
	      blockIN: IN Block_Cache;
	      blockOUT: OUT Block_Cache);
END Cache_DataMemory;

ARCHITECTURE combinational OF Cache_DataMemory IS

SIGNAL storage : Cache;
Begin
blockOUT<= storage(to_integer(unsigned(address(7 downto 3))));
process(clk)
	variable index, displacement: Integer;
	begin
	index:= to_integer(unsigned(address(7 downto 3)));
	displacement:= to_integer(unsigned(address(2 downto 0)));
	IF rising_edge(clk) then 
		if MW = '1' and NoWrite = '0' and RamRead = '0' THEN  
		storage(index)(displacement)<= datain(15 downto 0); storage(index)(displacement+1)<= datain(31 downto 16);
		elsif  RamRead = '1' then 
		storage(index) <= blockIN;
		end if;
	END IF;
END PROCESS;

process(MR, storage, address)
	variable index, displacement: Integer;
	begin
	index:= to_integer(unsigned(address(7 downto 3)));
	displacement:= to_integer(unsigned(address(2 downto 0)));
	if MR = '1' then dataout <= storage(index)(displacement+1)&storage(index)(displacement);
	else dataout <=(others=>'0');
	end if;
end process;

End ARCHITECTURE;

library ieee;
USE ieee.std_logic_1164.ALL;
--use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;

use work.myPackages.all;

Entity Cache_InstructionMemory is
	PORT (clk : IN std_logic;
	      MW, RamRead, nowrite: IN std_logic;
	      address, addressWrite : IN std_logic_vector(7 DOWNTO 0);
	      datain : IN std_logic_vector (1 DOWNTO 0);
	      dataout : OUT std_logic_vector(15 DOWNTO 0);
	      blockIN: IN Block_Cache
	      );
END Cache_InstructionMemory;

ARCHITECTURE combinational2 OF Cache_InstructionMemory IS

SIGNAL storage : Cache;
Begin

process(clk)
	variable index, displacement, indexread: Integer;
	begin
	index:= to_integer(unsigned(addressWrite(7 downto 3)));
	displacement:=to_integer(unsigned(addressWrite(2 downto 0)));
	indexread:= to_integer(unsigned(address(7 downto 3)));
	IF rising_edge(clk) then 
		if MW = '1' and NoWrite = '0' and RamRead = '0' THEN  
		storage(index)(displacement)(15 downto 14)<= datain;
		elsif  RamRead = '1' then 
		storage(indexread) <= blockIN;
		end if;
	END IF;
END PROCESS;

process(storage, address)
	variable index, displacement: Integer;
	begin
	index:= to_integer(unsigned(address(7 downto 3)));
	displacement:= to_integer(unsigned(address(2 downto 0)));
	dataout <= storage(index)(displacement);
end process;

End ARCHITECTURE;

library ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

use work.myPackages.all;

Entity Cache_Controller is
	PORT (clk, rst, MR, MW, MWInstr: IN std_logic;
	      address, addressInstr, addressInstrWrite : IN std_logic_vector(10 DOWNTO 3);
	      AddressToRam: OUT std_logic_vector(10 DOWNTO 0);
	      MemW, CacheW, CacheWInstr, ignore: OUT std_logic);
END Cache_Controller;

ARCHITECTURE control OF Cache_Controller IS

signal TagArray, TagArrinstr : Taglist;
signal ValidArray, dirtyArray, ValidArrInstr : std_logic_vector(31 downto 0);
signal TagWrite, dirtyWrite, TagWriteInstr: std_logic;
signal index, indexInstr, indexInstrWrite: Integer;
signal tag,tagInstr, tagInstrWrite : std_logic_vector(2 downto 0);
Begin
tag<= address(10 downto 8);
tagInstr<= addressInstr(10 downto 8);
tagInstrWrite<= addressInstrWrite(10 downto 8);
index<= to_integer(unsigned((address(7 downto 3))));
indexInstr<= to_integer(unsigned((addressInstr(7 downto 3))));
indexInstrWrite<= to_integer(unsigned((addressInstrWrite(7 downto 3))));
process(clk,MR, MW, address, TagArray, ValidArray, dirtyArray, rst, ValidArrInstr, TagArrinstr,addressInstr,addressInstrWrite,MWInstr)
variable dataMissPrior: integer;
begin
dataMissPrior:=0;
if falling_edge(clk) then
	MemW<='0'; CacheW<='0'; TagWrite<='0'; dirtyWrite <= '0'; CacheWInstr <='0'; TagWriteInstr<='0'; ignore<='0';
	if MR ='1' or MW = '1' then 
		   if (ValidArray(index) = '0' or TagArray(index) /= tag) then   dataMissPrior :=1;   -- Miss
			if dirtyArray(index) = '0' then  CacheW<= '1'; TagWrite<='1'; AddressToRam<=address(10 downto 3)&"000";
			else MemW<= '1'; dirtyWrite<= '1'; AddressToRam<=TagArray(index)&Address(7 downto 3)&"000";
			end if;
		   end if;
	end if;
		
	if dataMissPrior = 0 then
		if (ValidArrInstr(indexInstr) = '0' or TagArrinstr(indexInstr) /= tagInstr) then 
				CacheWInstr <='1'; TagWriteInstr<='1'; AddressToRam<=addressInstr(10 downto 3)&"000"; end if;
		if MWInstr ='1' and (ValidArrInstr(indexInstrWrite) = '0' or TagArrinstr(indexInstrWrite) /= tagInstrWrite) then
			ignore <='1';
		end if;
			
	end if;
	
end if;
end process;

process (clk, rst, tagWrite, address, dirtyWrite, addressInstr,TagWriteInstr)
	begin
	if rst ='1' then  ValidArray<=(others=>'0'); dirtyArray<=(others=>'0'); ValidArrInstr<=(others=>'0'); end if;
	if rising_edge(clk) then 
		if dirtyWrite = '1' then dirtyArray(index)<= '0'; end if; 
 
		if MW = '1' and ValidArray(index) = '1' and TagArray(index) = tag then -- Write HIT
			dirtyArray(index)<= '1'; end if;
		if tagWrite = '1' then TagArray(index) <= tag; ValidArray(index)<='1'; end if;
		if TagWriteInstr ='1' then TagArrinstr(indexInstr) <=tagInstr; ValidArrInstr(indexInstr)<='1'; end if;
	end if;
end process;

End control;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use work.myPackages.all;

ENTITY MainMemory IS

PORT (clk, we : IN std_logic;
address : IN std_logic_vector(10 DOWNTO 0);
datain : IN Block_Cache;
dataout : OUT Block_Cache);
END MainMemory;

ARCHITECTURE main OF MainMemory IS

TYPE ram_type IS ARRAY(0 TO 2047) of std_logic_vector(15 DOWNTO 0);

SIGNAL ram : ram_type := (
 0=> "1111100100000000",
 1=> "1111100100000000",
 2=> "1111100100000000",
 3=> "0000001111000001",
 4=> "0000000000000001",
 5=> "0000001111000010",
 6=> "0000000000000010",
 7=> "0000001111000011",
 8=> "0000000000000011",
 9=> "0000001111000100",
 10=> "0000000000000100",
 11=> "0000001111000101",
 12=> "0000000000000101",
 13=> "1011001000000001",
 14=> "1010101000000010",
 15=> "1010011000000011",
 16=> "1010010000000100",
 17=> "1101000000000001",
 18=> "1010000000000101",
 19=> "1111101000000000",
 20=> "0000000000010001",
 21=> "1101000011110011",
 22=> "0001000001000010",
 23=> "1111100100000000",
 24=> "1111101100000000",
 others=>X"0000"
);

Begin
PROCESS(clk) IS
variable offset: Integer;
BEGIN
	offset:= to_integer(unsigned((address)));
	IF rising_edge(clk) THEN
		IF we = '1' THEN 
			L:for I in 0 to 7 loop
			Li:ram(offset+I) <=  datain(I);
			end loop;
		 END IF;
	END IF;
END PROCESS;
process(address, ram)
	variable offset: Integer;
	BEGIN
	offset:= to_integer(unsigned((address)));
	R:for I in 0 to 7 loop
	Ri:dataout(I) <= ram(offset+I);
	end loop;
end process;

END ARCHITECTURE;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use work.myPackages.all;

Entity CacheSystem is
	port(clk, rst, MR, MW, MWInstr: IN std_logic;
	     address, addressInstr, addressInstrWrite: IN std_logic_vector(10 downto 0);
	     datain: IN std_logic_vector(31 downto 0);
	     PredBits: In std_logic_vector(1 downto 0);
	     instrOut: out std_logic_vector(15 downto 0);
	     dataout: OUT std_logic_vector(31 downto 0));
End CacheSystem;

ARCHITECTURE final of CacheSystem is
signal RamToCach, CachToRam: std_logic;
signal RTCblock, CTRblock: block_Cache;
signal addresstoRam: std_logic_vector(10 downto 0);
signal toInstrCach, ignore: std_logic;
begin
cacheMemoryLabel: entity work.Cache_DataMemory port map(clk, MR, MW, RamToCach, CachToRam, address(7 downto 0), datain, dataout, RTCblock, CTRblock);
cacheInstrLabel: entity work.Cache_InstructionMemory port map(clk, MWInstr, toInstrCach, ignore, addressInstr(7 downto 0),addressInstrWrite(7 downto 0),PredBits, instrOut,RTCblock);
cacheControllerLabel: entity work.Cache_Controller port map(clk, rst, MR, MW, MWInstr, address(10 downto 3), addressInstr(10 downto 3), addressInstrwrite(10 downto 3) ,addresstoRam, CachToRam, RamToCach,toInstrCach,ignore);
MainMemoryLabel: entity work.MainMemory port map(clk, CachToRam, addresstoRam, CTRblock, RTCblock);
end ARCHITECTURE;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
 entity test is
	port(clk, rst, MR, MW: IN std_logic;
	     address: IN std_logic_vector(10 downto 0);
	     datain: IN std_logic_vector(31 downto 0);
	     dataout : OUT std_logic_vector(31 downto 0));
End test;

ARCHITECTURE tt of test is
begin
--weeee: entity work.CacheSystem port map(clk, rst, MR, MW, address, datain, dataout);
end tt;

	     