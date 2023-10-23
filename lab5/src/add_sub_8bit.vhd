-------------------------------------------------------------------------------
-- M.A.Schneider
-- top level for lab 5 calculator
-- last modified 10/23/23
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is
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
end calculator;

architecture beh of calculator is

  component synchronizer_8bit is 
    port (
      clk             : in  std_logic;
      reset           : in  std_logic;
      async_in        : in  std_logic_vector(7 downto 0);
      sync_out        : out std_logic_vector(7 downto 0)
    );
  end component;
  
  component rising_edge_synchronizer is 
    port (
      clk             : in  std_logic;
      reset           : in  std_logic;
      input           : in  std_logic;
      edge            : out std_logic
    );
  end component;
  
  component double_dabble is
    port (
      result_padded   : in  std_logic_vector(11 downto 0); 
      ones            : out std_logic_vector(3 downto 0);
      tens            : out std_logic_vector(3 downto 0);
      hundreds        : out std_logic_vector(3 downto 0)
    );  
  end component;  

  component seven_seg is
    port (
      bcd             : in  std_logic_vector(3 downto 0);
      seven_seg_out   : out std_logic_vector(6 downto 0)
    );  
  end component;  

  signal in_sync      : std_logic_vector(7 downto 0);
  signal in_a         : std_logic_vector(7 downto 0);
  signal in_b         : std_logic_vector(7 downto 0);
  signal btn_sync     : std_logic;

  signal res          : std_logic_vector(8 downto 0);
  signal res_padded   : std_logic_vector(11 downto 0);
  signal bin_hund     : out std_logic_vector(3 downto 0);
  signal bin_tens     : out std_logic_vector(3 downto 0);
  signal bin_ones     : out std_logic_vector(3 downto 0)

  type calc_state    is (IN_A, IN_B, ADD, SUB);
  signal pres_state   : calc_state;
  signal next_state   : calc_state;

begin

  -- synchronize all inputs
  sync_input: synchronizer_8bit
  port map(
    clk             => clk,
    reset           => reset,
    async_in        => in_switches,
    sync_out        => in_sync
  );

  sync_button: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset           => reset,
    input           => btn,
    edge            => btn_sync
  );

  -- next state logic and state register
  state_reg: process (clk, reset)
  begin
    if (reset = '1') then
      pres_state <= IN_A;
    elsif(rising_edge(clk)) then
      pres_state <= next_state;
    end if;
  end process; -- end state register

  next_state_logic: process(pres_state)
  begin
    case pres_state is
      when IN_A =>
        if (btn_sync = '1') then
          next_state <= IN_B;
        end if;

      when IN_B =>
      if (btn_sync = '1') then
        next_state <= ADD;
      end if;

      when ADD =>
      if (btn_sync = '1') then
        next_state <= SUB;
      end if;      

      when SUB =>
      if (btn_sync = '1') then
        next_state <= IN_A;
      end if;
    end case;
  end process; -- end next state logic

  -- input assignment and math
  inputs: process(in_sync)
  begin
    if (reset = '1') then
      in_a <= "00000000";
      in_b <= "00000000";
    elsif (pres_state = IN_A) then
      in_a <= in_sync;
    elsif (pres_state = IN_B) then
      in_b <= in_sync;
    end if;
  end process; -- end input assignment

  operation: process(pres_state)
  begin
    case pres_state is
      when IN_A =>
        res <= '0' & in_a;
      when IN_B =>
        res <= '0' & in_b
      when ADD =>
        res <= std_logic_vector(unsigned(in_a) + unsigned(in_b));
      when SUB =>
        res <= std_logic_vector(unsigned(in_a) - unsigned(in_b));
    end case;
  end process; -- end operations

  pad: process(res)
  begin
    res_padded <= "000" & res;
  end process; -- end result padding

  -- double double and seven segment display
  dd: double_dabble
  port map(
    result_padded   => res_padded,
    ones            => bin_ones,
    tens            => bin_tens,
    hundreds        => bin_hund
  );

  ssd_hund: seven_seg
  port map(
    bcd             => bin_hund,
    seven_seg_out   => ssd_hund
  );

  ssd_tens: seven_seg
  port map(
    bcd             => bin_tens,
    seven_seg_out   => ssd_tens
  );

  ssd_ones: seven_seg
  port map(
    bcd             => bin_ones,
    seven_seg_out   => ssd_ones
  );

  end beh;