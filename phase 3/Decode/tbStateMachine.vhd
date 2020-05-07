Library ieee;
use ieee.std_logic_1164.all;
entity tbMachine is
    end entity;

Architecture Test of tbMachine is
    Signal s_clk,s_rst : std_logic := '1';
    Signal s_input,s_output : std_logic_vector(1 downto 0);
    constant CLK_PERIOD : time := 200 ps;
    Signal test_output : std_logic_vector(13 downto 0) :=  "00011110011000";
    Signal test_input  : std_logic_vector(13 downto 0) := "00010001100000";

begin
    SM: entity work.stateMachine port map ( s_input,s_clk,s_rst,s_output);

process 
    begin
        s_clk <= not s_clk;
        wait for CLK_PERIOD/2;
    end process;

process 
    begin 
    s_rst <= '1';
    wait for CLK_PERIOD;
    s_rst <= '0';

    for i in 0 to test_input'length-1 loop
            s_input<=test_input(i downto i-1);
        wait for CLK_PERIOD;
        assert (s_output=test_output(i-1)) report "error in machine output" severity error;
	i:= i + 1;
--        wait for CLK_PERIOD;
    end loop;
    s_rst <= '1';
    s_input<="11";
    wait for CLK_PERIOD;
    assert (s_output="00") report "error in reset of machine " severity error;

    wait;
    end process;
end Architecture;