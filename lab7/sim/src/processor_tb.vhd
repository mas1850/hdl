-------------------------------------------------------------------------------
-- M.A.Schneider
-- lab6 calculator3 test bench
-- last modified 11/20/23
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity processor_tb is
end processor_tb;

architecture beh of processor_tb is

  component processor is
  port (
    execute_btn       : in  std_logic;
    clk               : in  std_logic; 
    reset_n           : in  std_logic;
    state_led         : out std_logic_vector(4 downto 0);
    ssd_hund          : out std_logic_vector(6 downto 0);
    ssd_tens          : out std_logic_vector(6 downto 0);
    ssd_ones          : out std_logic_vector(6 downto 0)
  );
  end component;

  signal execute_btn       : std_logic := '0';
  signal reset_n           : std_logic := '0';
  signal clk               : std_logic := '0';
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
  uut: processor
  port map(
    execute_btn       => execute_btn,
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

    -- add four
    -- multiply by eight
    -- save data
    -- subtract eight
    -- divide by two
    -- load memory
    -- divide by two

    execute_btn <= '1'; -- add four
    wait for 40 ns;
    execute_btn <= '0';
    wait for 40 ns;

    execute_btn <= '1'; -- multiply by eight
    wait for 40 ns;
    execute_btn <= '0';
    wait for 40 ns;

    execute_btn <= '1'; -- save data
    wait for 40 ns;
    execute_btn <= '0';
    wait for 40 ns;

    execute_btn <= '1'; -- subtract eight
    wait for 40 ns;
    execute_btn <= '0';
    wait for 40 ns;

    execute_btn <= '1'; -- divide by two
    wait for 40 ns;
    execute_btn <= '0';
    wait for 40 ns;
    
    execute_btn <= '1'; -- load memory
    wait for 40 ns;
    execute_btn <= '0';
    wait for 40 ns;

    execute_btn <= '1'; -- divide by two
    wait for 40 ns;
    execute_btn <= '0';
    wait for 40 ns;


    report "********** sequential testbench end **********";
    wait;

  end process;
end beh;