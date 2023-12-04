-------------------------------------------------------------------------------
-- M.A.Schneider
-- top level for lab 7 simple processor
-- last modified 11/29/23
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mas_components.all

entity processor is
  port (
    execute_btn       : in  std_logic;
    clk               : in  std_logic; 
    reset_n           : in  std_logic;
    state_led         : out std_logic_vector(4 downto 0);
    ssd_hund          : out std_logic_vector(6 downto 0);
    ssd_tens          : out std_logic_vector(6 downto 0);
    ssd_ones          : out std_logic_vector(6 downto 0)
  );
end processor;

architecture beh of processor is

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

  signal execute_sync     : std_logic;
  signal instruction      : std_logic_vector(12 downto 0);

  signal ms_btn           : std_logic;
  signal mr_btn           : std_logic;
  signal exe_btn          : std_logic;
  signal op_switches      : std_logic_vector(1 downto 0);
  signal in_switches      : std_logic_vector(7 downto 0);

begin

  -- sync top-level execute button
  sync_exe: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset_n         => reset_n,
    input           => exe_btn,
    edge            => exe_sync
  );

  -- instruction rom

  -- instruction breaker

  -- calculator component
  calculator: calculator3
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







  -- synchronize all inputs
  sync_input: synchronizer_8bit
  port map(
    clk             => clk,
    reset_n         => reset_n,
    async_in        => in_switches,
    sync_out        => in_sync
  );

  sync_op: synchronizer_2bit
  port map(
    clk             => clk,
    reset_n         => reset_n,
    async_in        => op_switches,
    sync_out        => op_sync
  );

  sync_ms: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset_n         => reset_n,
    input           => ms_btn,
    edge            => ms_sync
  );

  sync_mr: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset_n         => reset_n,
    input           => mr_btn,
    edge            => mr_sync
  );

  sync_exe: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset_n         => reset_n,
    input           => exe_btn,
    edge            => exe_sync
  );

 -- arithmetic logic unit
 logic_unit: alu
 port map (
   clk           => clk,
   reset_n       => reset_n,
   a             => in_sync,
   b             => directory,
   op            => op_sync,
   result        => alu_out
 );

  -- next state logic and state register
  state_reg: process(reset_n, clk)
  begin
    if (reset_n = '0') then
      pres_state <= READ_W;
    elsif(rising_edge(clk)) then
      pres_state <= next_state;
    end if;

    if(rising_edge(clk)) then
      case pres_state is
        when READ_W =>
          write_en <= '0';
          address <= "00";
          res <= alu_out;

        when WRITE_W_NO_OP =>
          if (address="00") then
            res <= alu_out;
          elsif (address="01") then
            res <= directory;
          end if;

        when WRITE_W =>
          write_en <= '1';
          address <= "00";

        when WRITE_S =>
          write_en <= '1';
          address <= "01";

        when READ_S =>
          write_en <= '0';
          address <= "01";
          res <= directory;

      end case;
    end if;
  end process; -- end state register

  next_state_logic: process(pres_state, exe_sync, ms_sync, mr_sync)
  begin
    next_state <= pres_state;
    case pres_state is
      when READ_W =>
        if (exe_sync = '1') then
          next_state <= WRITE_W_NO_OP;
        end if;
        if (ms_sync = '1') then
          next_state <= WRITE_S;
        end if;
        if (mr_sync = '1') then
          next_state <= READ_S;
        end if;

      when WRITE_W_NO_OP =>
        next_state <= WRITE_W;
      
      when WRITE_W =>
        next_state <= READ_W;
      
      when WRITE_S =>
        next_state <= READ_W;
      
      when READ_S =>
        if (exe_sync = '1') then
          next_state <= WRITE_W_NO_OP;
        end if;
    end case;
  end process; -- end next state logic

  -- memory and state led
  ram: memory
  generic map (
    addr_width      => 2,
    data_width      => 8     
  )
  port map (
    clk             => clk,
    we              => write_en,
    addr            => address,
    din             => res,
    dout            => directory      
  );

  state_display: process(pres_state)
  begin
    case pres_state is
      when READ_W =>
        state_led <= "10000";

      when WRITE_W_NO_OP =>
        state_led <= "01000";
      
      when WRITE_W =>
        state_led <= "00100";
      
      when WRITE_S =>
        state_led <= "00010";
      
      when READ_S =>
        state_led <= "00001";

    end case;
  end process; -- end next state logic

  pad: process(res)
  begin
    res_padded <= "0000" & res;
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