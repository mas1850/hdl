-------------------------------------------------------------------------------
-- M.A.Schneider
-- top level for lab 4 calculator
-- last modified 10/7/23
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is
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
end calculator;

architecture beh of calculator is

component rising_edge_synchronizer is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
end component;

component seven_seg is
  port (
    bcd             : in  std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );  
end component;  

signal a_padded     : std_logic_vector(3 downto 0);
signal b_padded     : std_logic_vector(3 downto 0);
signal flag         : std_logic := '1';
signal res          : std_logic_vector(3 downto 0);

begin

  pad: process(a_in, b_in, reset)
  begin
    if (reset = '1') then
      a_padded <= "0000";
      b_padded <= "0000";
    else
      a_padded <= '0' & a_in;
      b_padded <= '0' & b_in;
    end if;
  end process;

  bcd_a: seven_seg
  port map(
    bcd             => a_padded,
    seven_seg_out   => a_out
  );

  bcd_b: seven_seg
  port map(
    bcd             => b_padded,
    seven_seg_out   => b_out
  );

--  op-flag: process

  operation: process(a_padded, b_padded)
  begin
    if (flag = '0') then
      res <= std_logic_vector(unsigned(a_padded) + unsigned(b_padded));
    elsif (flag = '1') then
      res <= std_logic_vector(unsigned(a_padded) + unsigned (b_padded));
    end if;
  end process;

  a_lcd: seven_seg
    port map (
      bcd             => a_padded,
      seven_seg_out   => a_out
	  );

  b_lcd: seven_seg
    port map (
      bcd             => b_padded,
      seven_seg_out   => b_out
    );

  result_lcd: seven_seg
  port map (
    bcd             => res,
    seven_seg_out   => res_out
	);

end beh;