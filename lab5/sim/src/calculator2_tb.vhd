-------------------------------------------------------------------------------
-- M.A.Schneider
-- lab5 calculator2 test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity calculator2_tb is
end calculator2_tb;

architecture arch of calculator2_tb is

  component calculator2 is
  port (
    in_switches       : in  std_logic_vector(7 downto 0);
    btn               : in  std_logic;
    clk               : in  std_logic; 
    reset             : in  std_logic;
    state_led         : out std_logic_vector(3 downto 0);
    ssd_hund          : out std_logic_vector(6 downto 0);
    ssd_tens          : out std_logic_vector(6 downto 0);
    ssd_ones          : out std_logic_vector(6 downto 0)
    );
  end component;

  signal in_switches       : std_logic_vector(7 downto 0);
  signal btn               : std_logic := '0';
  signal clk               : std_logic := '0'; 
  signal reset             : std_logic := '1';

  constant PERIOD          : time := 20ns;

begin

  -- clock process
  clock: process
    begin
      clk <= not clk;
      wait for PERIOD/2;
  end process; 
   
  -- reset process
  async_reset: process
    begin
      wait for 2 * PERIOD;
      reset <= '0';
      wait;
  end process; 

  -- unit under test
  uut: calculator2
  port map(
    in_switches       => in_switches,
    btn               => btn,
    clk               => clk, 
    reset             => reset,
    state_led         => open,
    ssd_hund          => open,
    ssd_tens          => open,
    ssd_ones          => open
  );

  sequential_tb: process
  begin
    report "********** sequential testbench start **********";
    wait for 100 ns; -- let all the initial conditions trickle through

    -- A=5, B=2, SUM=7 DIFF=3
    report "********** 5+2=7  /  5-2=3 **********";
    btn <= '0';
    in_switches <= "00000101";
    wait for 40 ns;
    btn <= '1'; -- enter input b
    wait for 40 ns;
    btn <= '0';
    in_switches <= "00000010";
    wait for 40 ns;
    btn <= '1'; -- enter sum
    wait for 40 ns;
    btn <= '0';
    wait for 40 ns;
    btn <= '1'; -- enter diff
    wait for 40 ns;
    btn <= '0';
    wait for 40 ns;
    btn <= '1'; -- enter input a
    wait for 40 ns;

    -- A=2, B=5, SUM=7 DIFF=509
    report "********** 5+2=7  /  2-5=509 **********";
    btn <= '0';
    in_switches <= "00000010";
    wait for 40 ns;
    btn <= '1'; -- enter input b
    wait for 40 ns;
    btn <= '0';
    in_switches <= "00000101";
    wait for 40 ns;
    btn <= '1'; -- enter sum
    wait for 40 ns;
    btn <= '0';
    wait for 40 ns;
    btn <= '1'; -- enter diff
    wait for 40 ns;
    btn <= '0';
    wait for 40 ns;
    btn <= '1'; -- enter input a
    wait for 40 ns;

    -- A=200, B=100, SUM=300 DIFF=100
    report "********** 200+100=300  /  200-100=100 **********";
    btn <= '0';
    in_switches <= "11001000";
    wait for 40 ns;
    btn <= '1'; -- enter input b
    wait for 40 ns;
    btn <= '0';
    in_switches <= "01100100";
    wait for 40 ns;
    btn <= '1'; -- enter sum
    wait for 40 ns;
    btn <= '0';
    wait for 40 ns;
    btn <= '1'; -- enter diff
    wait for 40 ns;
    btn <= '0';
    wait for 40 ns;
    btn <= '1'; -- enter input a
    wait for 40 ns;

    report "********** 100+200=300  /  100-200=412 **********";
    -- A=100, B=200, SUM=300 DIFF=412
    btn <= '0';
    in_switches <= "01100100";
    wait for 40 ns;
    btn <= '1'; -- enter input b
    wait for 40 ns;
    btn <= '0';
    in_switches <= "11001000";
    wait for 40 ns;
    btn <= '1'; -- enter sum
    wait for 40 ns;
    btn <= '0';
    wait for 40 ns;
    btn <= '1'; -- enter diff
    wait for 40 ns;
    btn <= '0';
    wait for 40 ns;
    btn <= '1'; -- enter input a
    wait for 40 ns;
    report "********** sequential testbench end **********";

    wait;

  end process;
end arch;