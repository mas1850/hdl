-------------------------------------------------------------------------------
-- M.A.Schneider
-- top level for lab 6 calculator3
-- last modified 11/6/23
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator3 is
  port (
    in_switches       : in  std_logic_vector(7 downto 0);
    op_switches       : in  std_logic_vector(1 downto 0);
    ms_btn            : in  std_logic;
    mr_btn            : in  std_logic;
    exe_btn           : in  std_logic;
    clk               : in  std_logic; 
    reset             : in  std_logic;
    state_led         : out std_logic_vector(4 downto 0);
    ssd_hund          : out std_logic_vector(6 downto 0);
    ssd_tens          : out std_logic_vector(6 downto 0);
    ssd_ones          : out std_logic_vector(6 downto 0)
  );
end calculator3;

architecture beh of calculator3 is

  component synchronizer_8bit is 
    port (
      clk             : in  std_logic;
      reset           : in  std_logic;
      async_in        : in  std_logic_vector(7 downto 0);
      sync_out        : out std_logic_vector(7 downto 0)
    );
  end component;

  component synchronizer_2bit is 
    port (
      clk             : in  std_logic;
      reset           : in  std_logic;
      async_in        : in  std_logic_vector(1 downto 0);
      sync_out        : out std_logic_vector(1 downto 0)
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
  signal ms_sync      : std_logic;
  signal mr_sync      : std_logic;
  signal exe_sync     : std_logic;

  signal alu_out      : std_logic_vector(7 downto 0);
  signal write_en     : std_logic_vector;
  signal address      : std_logic_vector(1 downto 0);
  signal directory    : std_logic_vector(7 downto 0);

  signal res          : std_logic_vector(8 downto 0);
  signal res_padded   : std_logic_vector(11 downto 0);
  signal bin_hund     : std_logic_vector(3 downto 0);
  signal bin_tens     : std_logic_vector(3 downto 0);
  signal bin_ones     : std_logic_vector(3 downto 0);

  type calc_state     is (READ_W, WRITE_W_NO_OP, WRITE_W, WRITE_S, READ_S);
  signal pres_state   :  calc_state;
  signal next_state   :  calc_state;

begin

  -- synchronize all inputs
  sync_input: synchronizer_8bit
  port map(
    clk             => clk,
    reset           => reset,
    async_in        => in_switches,
    sync_out        => in_sync
  );

  sync_op: synchronizer_2bit
  port map(
    clk             => clk,
    reset           => reset,
    async_in        => op_switches,
    sync_out        => op_sync
  );

  sync_ms: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset           => reset,
    input           => ms_btn,
    edge            => ms_sync
  );

  sync_mr: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset           => reset,
    input           => mr_btn,
    edge            => mr_sync
  );

  sync_exe: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset           => reset,
    input           => exe_btn,
    edge            => exe_sync
  );

  --next state logic and state register
  state_reg: process(reset, clk)
  begin
    if (reset = '1') then
      pres_state <= READ_W;
      write_en <= "0";
      address <= "00";
    elsif(rising_edge(clk)) then
      pres_state <= next_state;
    end if;
  end process; -- end state register

  next_state_logic: process(pres_state, btn_sync)
  begin
    next_state <= pres_state;
    case pres_state is
      when READ_W =>
        if (exe_sync = "1") then
          next_state <= WRITE_W_NO_OP;
        end if;
        if (ms_sync = "1") then
          next_state <= WRITE_S;
        end if;
        if (mr_sync = "1") then
          next_state <= READ_S;
        end if;

      when WRITE_W_NO_OP =>
        next_state <= WRITE_W;
      
      when WRITE_W =>
        next_state <= READ_W;
      
      when WRITE_S =>
        next_state <= READ_W;
      
      when READ_S =>
        if (exe_sync = "1") then
          next_state <= WRITE_W_NO_OP;
        end if;
    end case;
  end process; -- end next state logic

  -- input assignment and math
  -- inputs: process(reset, clk)
  -- begin
  --   if (reset = '1') then
  --     in_a <= "00000000";
  --     in_b <= "00000000";
  --   elsif ((pres_state = INPUT_A) and rising_edge(clk)) then
  --     in_a <= in_sync;
  --   elsif ((pres_state = INPUT_B) and rising_edge(clk)) then
  --     in_b <= in_sync;
  --   end if;
  -- end process; -- end input assignment

--   operation: process(clk, pres_state)
--   begin
--     if(rising_edge(clk)) then
--       case pres_state is
--         when INPUT_A =>
--           res <= '0' & in_a;
--           --state_led <= "1000";
--         when INPUT_B =>
--           res <= '0' & in_b;
--           --state_led <= "0100";
--         when SUM =>
--           res <= std_logic_vector(unsigned('0' & in_a) + unsigned('0' & in_b));
--           --state_led <= "0010";
--         when DIFF =>
--           res <= std_logic_vector(unsigned('0' & in_a) - unsigned('0' & in_b));
--           --state_led <= "0001";
--       end case;
--     end if;
--   end process; -- end operations
  
--   state_display: process(clk, pres_state)
--   begin
--     if(rising_edge(clk)) then
--       case pres_state is
--         when INPUT_A =>
--           --res <= '0' & in_a;
--           state_led <= "1000";
--         when INPUT_B =>
--           --res <= '0' & in_b;
--           state_led <= "0100";
--         when SUM =>
--           --res <= std_logic_vector(unsigned('0' & in_a) + unsigned('0' & in_b));
--           state_led <= "0010";
--         when DIFF =>
--           --res <= std_logic_vector(unsigned('0' & in_a) - unsigned('0' & in_b));
--           state_led <= "0001";
--       end case;
--     end if;
--   end process; -- end state_display

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

  display_hundreds: seven_seg
  port map(
    bcd             => bin_hund,
    seven_seg_out   => ssd_hund
  );

  display_tens: seven_seg
  port map(
    bcd             => bin_tens,
    seven_seg_out   => ssd_tens
  );

  display_ones: seven_seg
  port map(
    bcd             => bin_ones,
    seven_seg_out   => ssd_ones
  );

end beh;