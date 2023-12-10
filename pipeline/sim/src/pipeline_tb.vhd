-------------------------------------------------------------------------------
-- Dr. Kaputa
-- pipeline testbench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline_tb is
end pipeline_tb;

architecture arch of pipeline_tb is

component pipeline is
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    result        : out std_logic_vector(15 downto 0)
  );  
end component;  

  constant period     : time := 20 ns;                                              
  signal clk          : std_logic := '0';
  signal reset        : std_logic := '1';

begin

-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process; 
 
-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset <= '0';
    wait;
end process; 

uut: pipeline  
  port map(
    clk        => clk,
    reset      => reset,
    result     => open
    );
end arch;