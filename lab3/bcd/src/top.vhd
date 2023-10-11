-------------------------------------------------------------------------------
-- M.A.Schneider
-- top level for lab 3 step 5/6
-- last modified 10/7/23
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity top is
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    output          : out std_logic_vector(6 downto 0)
  );
end top;

architecture beh of top is

component generic_counter is
  generic (
    max_count       : integer := 3
  );
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    output          : out std_logic
  );  
end component;  

component generic_adder_beh is
  generic (
    bits    : integer := 4
  );
  port (
    a       : in  std_logic_vector(bits-1 downto 0);
    b       : in  std_logic_vector(bits-1 downto 0);
    cin     : in  std_logic;
    sum     : out std_logic_vector(bits-1 downto 0);
    cout    : out std_logic
  );
end component;

component seven_seg is
  port (
    bcd             : in std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );
end component;

signal b_in            : std_logic_vector(3 downto 0) := "0001";
signal cin             : std_logic := '0';
signal enable          : std_logic;
signal sum             : std_logic_vector(3 downto 0) := "0011";
signal sum_sig         : std_logic_vector(3 downto 0) := "0000";
signal cout            : std_logic;

begin

-- counter, enables sum_sig update
counter: generic_counter
  generic map (
    max_count    => 4 --change from 4 to 49,999,999 for real life test
  )
  port map (
    clk          => clk,
    reset        => reset,
    output       => enable
  );

-- adds to sum_sig
adder: generic_adder_beh
  generic map (
    bits   => 4
  )
  port map(
    a      => sum_sig,
    b      => b_in,
    cin    => cin,
    sum    => sum,
    cout   => open
  );

-- updates sig value
reg: process(clk,reset)
begin
  if (reset = '1') then
    sum_sig <= "1111";
  elsif (clk'event and clk = '1' and enable = '1') then
    if (sum = "1001") then
      sum_sig <= "1111";
    else
      sum_sig <= sum;
    end if;
  end if;
end process;

-- convert value to seven segment display
segment: seven_seg
  port map(
    bcd             => sum_sig,
    seven_seg_out   => output
  );
  
end beh;