Library ieee;
use ieee.std_logic_1164.all;

entity generateMuxSellector is
    port (  PredictionBits         : in std_logic_vector(1 downto 0);
            IfBranch,wrongBranching,fromMemory       : in std_logic;
            PCSellector   : in std_logic_vector(1 downto 0)
	);
    end entity;

Architecture GMS of generateMuxSellector is
begin

	process 

        end process;

end Architecture;