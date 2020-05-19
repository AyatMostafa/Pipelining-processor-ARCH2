Library ieee;
use ieee.std_logic_1164.all;

entity stateMachine is
    port ( input: in std_logic_vector(1 downto 0);
            clk,rst: in std_logic;
            output: out std_logic_vector(1 downto 0)
	);
    end entity;

Architecture SM of stateMachine is
    type states is (S0,S1,S2,S3,s4);
    signal current_state : states := S0;

begin
	process (current_state) 
        begin
            case current_state is
                when S0  =>
                    output <= "00";
                when S1 =>
                    output <= "01";
                when S2 =>
                    output <= "01";
                when S3 =>
                    output <= "10";
		when S4 =>
                    output <= "11";
                    
            end case;
        end process;


	process (clk,rst, input) 
            begin
              if rst = '1' then
                    current_state <= S0;
	      end if;
              if falling_edge(clk) then 
                case current_state is
                    when S0 =>
			if input = "01" then current_state <= S1; 
			elsif input = "10" then current_state <= S2;
			else current_state <= S0; 
			end if;
                    when S1 =>
                        current_state <= S0;
                    when S2 =>
                        current_state <= S3; 
                    when S3 =>
                        current_state <= S4;
                    when S4 =>
                        current_state <= S0;  
                end case;
              end if;
            end process;

end Architecture;
        
