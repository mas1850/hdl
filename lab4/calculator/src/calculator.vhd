-------------------------------------------------------------------------------
-- M.A.Schneider
-- top level for lab 4 calculator
-- last modified 10/18/23
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

component synchronizer_3bit is 
  port (
    clk             : in std_logic;
    reset           : in std_logic;
    async_in        : in std_logic_vector(2 downto 0);
    sync_out        : out std_logic_vector(2 downto 0)
  );
end component;

component rising_edge_synchronizer is 
  port (
    clk             : in std_logic;
    reset           : in std_logic;
    input           : in std_logic;
    edge            : out std_logic
  );
end component;

component seven_seg is
  port (
    bcd             : in  std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );  
end component;  

signal a_synced     : std_logic_vector(2 downto 0);
signal b_synced     : std_logic_vector(2 downto 0);
signal a_padded     : std_logic_vector(3 downto 0);
signal b_padded     : std_logic_vector(3 downto 0);
signal add_synced   : std_logic := '0';
signal sub_synced   : std_logic := '0';
signal flag         : std_logic := '0';
signal res          : std_logic_vector(3 downto 0) := "0000";

begin

  --synchronize all inputs
  sync_a: synchronizer_3bit
  port map(
    clk             => clk,
    reset           => reset,
    async_in        => a_in,
    sync_out        => a_synced
  );

  sync_b: synchronizer_3bit
  port map(
    clk             => clk,
    reset           => reset,
    async_in        => b_in,
    sync_out        => b_synced
  );

  sync_add: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset           => reset,
    input           => add_btn,
    edge            => add_synced
  );

  sync_sub: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset           => reset,
    input           => sub_btn,
    edge            => sub_synced
  );


  --pad and display inputs
  pad: process(a_synced, b_synced, reset)
  begin
    if (reset = '1') then
      a_padded <= "0000";
      b_padded <= "0000";
    else
      a_padded <= '0' & a_synced;
      b_padded <= '0' & b_synced;
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

  --determine if add or sub, display result
  op_flag: process(clk)
  begin
    if (add_synced = '1') then
      flag <= '0';
    elsif (sub_synced = '1') then
      flag <= '1';
    end if;
  end process;

  operation: process(a_padded, b_padded)
  begin
    if (flag = '0') then
      res <= std_logic_vector(unsigned(a_padded) + unsigned(b_padded));
    elsif (flag = '1') then
      res <= std_logic_vector(unsigned(a_padded) - unsigned (b_padded));
    end if;
  end process;

  result_lcd: seven_seg
  port map (
    bcd             => res,
    seven_seg_out   => res_out
	);

end beh;