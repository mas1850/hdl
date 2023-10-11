-------------------------------------------------------------------------------
-- Dr. Kaputa
-- blink test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity calculator_tb is
end calculator_tb;

architecture arch of calculator_tb is

component calculator is
  port (
    a_in            : in  std_logic_vector(2 downto 0);
    b_in            : in  std_logic_vector(2 downto 0);
    add_btn         : in  std_logic;
    sub_btn         : in  std_logic;
    clk             : in  std_logic; 
    reset           : in  std_logic;
    a_out           : out std_logic_vector(6 downto 0);
    b_out           : out std_logic_vector(6 downto 0);
    res_out         : out std_logic_vector(6 downto 0)
    );
  end component;

constant NUM_BITS          : integer := 3;
constant SEQUENTIAL_FLAG   : boolean := true;     -- false : concurrent stimuli, true: sequential stimuli
constant PERIOD            : time := 20ns;

signal clk          : std_logic := '0';
signal reset        : std_logic := '1';
signal a            : std_logic_vector(2 downto 0) := "111";
signal b            : std_logic_vector(2 downto 0) := "111";
signal add_btn      : std_logic;
signal sub_btn      : std_logic;
signal flag         : std_logic;

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

uut: calculator  
  port map(
    a_in            => a,
    b_in            => b,
    add_btn         => add_btn,
    sub_btn         => sub_btn,
    clk             => clk,
    reset           => reset,
    a_out           => open,
    b_out           => open,
    res_out         => open
  );

sequential_tb: process
begin
  report "********** sequential testbench start **********";
  wait for 100 ns; -- let all the initial conditions trickle through
  add_btn <= '1';
  for i in 0 to ((2 ** NUM_BITS) - 1) loop
    a <= std_logic_vector(unsigned(a) + 1);
    for j in 0 to ((2 ** NUM_BITS) - 1) loop
      b <= std_logic_vector(unsigned(b) + 1);
      wait for 20 ns;
    end loop;
  end loop;
  add_btn <= '0';
  report "********** add test complete techbench stop **********";

  sub_btn <= '1';
  for i in 0 to ((2 ** NUM_BITS) - 1) loop
    a <= std_logic_vector(unsigned(a) + 1);
    for j in 0 to ((2 ** NUM_BITS) - 1) loop
      b <= std_logic_vector(unsigned(b) + 1);
      wait for 20 ns;
    end loop;
  end loop;
  sub_btn <= '0';
  report "********** sub test complete techbench stop **********";
  
  wait;
end process;

end arch;