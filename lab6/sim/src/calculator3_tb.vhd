-------------------------------------------------------------------------------
-- M.A.Schneider
-- lab5 calculator3 test bench
-- last modified 11/15/23
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity calculator3_tb is
end calculator3_tb;

architecture arch of calculator3_tb is

  component calculator3 is
  port (
    in_switches       : in  std_logic_vector(7 downto 0);
    op_switches       : in  std_logic_vector(1 downto 0);
    ms_btn            : in  std_logic;
    mr_btn            : in  std_logic;
    exe_btn           : in  std_logic;
    clk               : in  std_logic; 
    reset_n           : in  std_logic;
    state_led         : out std_logic_vector(4 downto 0);
    ssd_hund          : out std_logic_vector(6 downto 0);
    ssd_tens          : out std_logic_vector(6 downto 0);
    ssd_ones          : out std_logic_vector(6 downto 0)
    );
  end component;

  signal in_switches       : std_logic_vector(7 downto 0) := "00000000";
  signal op_switches       : std_logic_vector(1 downto 0) := "00";
  signal ms_btn            : std_logic := '0';
  signal mr_btn            : std_logic := '0';
  signal exe_btn           : std_logic := '0';
  signal clk               : std_logic := '0'; 
  signal reset_n           : std_logic := '0';

  constant PERIOD          : time := 20 ns;

begin

  -- clock process
  clock: process
    begin
      clk <= not clk;
      wait for PERIOD/2;
  end process; 
   
  -- reset_n process
  async_reset: process
    begin
      wait for 2 * PERIOD;
      reset_n <= '1';
      wait;
  end process; 

  -- unit under test
  uut: calculator3
  port map(
    in_switches       => in_switches,
    op_switches       => op_switches,
    ms_btn            => ms_btn,
    mr_btn            => mr_btn,
    exe_btn           => exe_btn,
    clk               => clk,
    reset_n           => reset_n,
    state_led         => open,
    ssd_hund          => open,
    ssd_tens          => open,
    ssd_ones          => open
  );

  sequential_tb: process
  begin
    report "********** sequential testbench start **********";
    wait for 100 ns; -- let all the initial conditions trickle through

    -- test bench order of operations
    -- add four
    -- multiply by eight
    -- save data
    -- subtract eight
    -- divide by two
    -- load memory
    -- divide by two

    -- add four
    in_switches <= "00000100";
    op_switches <= "00";
    wait for 40 ns;
    exe_btn <= '1';
    wait for 40 ns;
    exe_btn <= '0';
    wait for 40 ns;

    -- multiply by eight
    in_switches <= "00001000";
    op_switches <= "10";
    wait for 40 ns;
    exe_btn <= '1';
    wait for 40 ns;
    exe_btn <= '0';
    wait for 40 ns;

    -- save data
    ms_btn <= '1';
    wait for 40 ms;
    ms_btn <= '0';
    wait for 40 ms;

    -- subtract eight
    in_switches <= "00001000";
    op_switches <= "01";
    wait for 40 ns;
    exe_btn <= '1';
    wait for 40 ns;
    exe_btn <= '0';
    wait for 40 ns;

    -- divide by two
    in_switches <= "00000010";
    op_switches <= "11";
    wait for 40 ns;
    exe_btn <= '1';
    wait for 40 ns;
    exe_btn <= '0';
    wait for 40 ns;

    -- load memory
    mr_btn <= '1';
    wait for 40 ms;
    mr_btn <= '0';
    wait for 40 ms;

    -- divide by two
    in_switches <= "00000010";
    op_switches <= "11";
    wait for 40 ns;
    exe_btn <= '1';
    wait for 40 ns;
    exe_btn <= '0';
    wait for 40 ns;

    report "********** sequential testbench end **********";

    wait;

  end process;
end arch;