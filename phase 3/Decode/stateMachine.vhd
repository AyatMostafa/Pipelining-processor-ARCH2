
--Reham ass3
Library ieee;
use ieee.std_logic_1164.all;

entity stateMachine is
    port ( input: in std_logic_vector(1 downto 0);
            clk,rst: in std_logic;
            output: in std_logic_vector(1 downto 0);
    end entity;

Architecture SM of stateMachine is

    type states is (S0,S1,S2,S3);
    signal current_state : states := S0;

begin

	process (current_state) 
        begin
            output <= "00";
            case current_state is
                when S0  =>
                    output <= "00";
                when S1 =>
                    output <= '01';
                when S2 =>
                    output <= '01';
                when S3 =>
                    output <= '10';
                    
            end case;
        end process;


	process (clk,rst) 
            begin
	      current_state <= S0;
              if rst = '1' then
                    current_state <= S0;
              elsif rising_edge(clk) then 
                case current_state is
                    when S0 =>
                        if input = "00" then current_state <= S0; elsif input = "01" then current_state <= S1; elsif input = "10" then current_state <= S2; end if;
                    when S1 =>
                        current_state <= S0;
                    when S2 =>
                        current_state <= S3; 
                    when S3 =>
                        current_state <= S0; 
                end case;
              end if;
            end process;

end Architecture;
        
