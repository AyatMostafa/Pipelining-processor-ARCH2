library ieee;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_1164.all;


entity BranchingDataDetectionHazard is
     port (
	enable : in std_logic;
	opCode      : IN std_logic_vector(4 downto 0);
	Rdst        : IN std_logic_vector(2 downto 0);
	Decode_WB   : IN std_logic;
	Decode_MR   :IN std_logic;
	ID_EX_MR    :IN std_logic;
	ID_EX_WB    :IN std_logic;
	EX_Mem_MR   :IN std_logic; 
	ID_EX_Rdst  :IN std_logic_vector(2 downto 0);
	IF_ID_Rdst  :IN std_logic_vector(2 downto 0);
	EX_Mem_Rdst :IN std_logic_vector(2 downto 0);
	stall  : out std_logic
	);
end BranchingDataDetectionHazard;

architecture BDDH_Flow of BranchingDataDetectionHazard is

begin
    process
    BEGIN
if (enable='1') then
    if(opCode ="10000") or (opCode ="10001")or (opCode ="10010") then --jz jump call
	if (Decode_MR='1') or (ID_EX_MR='1') or (EX_Mem_MR='1') then
		if (Rdst=ID_EX_Rdst)or(Rdst=IF_ID_Rdst)or(Rdst=EX_Mem_Rdst) then
			stall<='1';
		end if;
	elsif (Decode_WB='1') or (ID_EX_WB='1') then
		if(Rdst=ID_EX_Rdst)or(Rdst=IF_ID_Rdst) then
			stall<='1';
		end if;
	else
		stall<='0';
	end if;
    end if;
end if;
     END PROCESS;
end BDDH_Flow;