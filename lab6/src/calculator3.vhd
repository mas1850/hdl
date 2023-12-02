-------------------------------------------------------------------------------
-- M.A.Schneider
-- top level for lab6 calculator3
-- last modified 11/20/23
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
    reset_n           : in  std_logic;
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
      reset_n         : in  std_logic;
      async_in        : in  std_logic_vector(7 downto 0);
      sync_out        : out std_logic_vector(7 downto 0)
    );
  end component;

  component synchronizer_2bit is 
    port (
      clk             : in  std_logic;
      reset_n         : in  std_logic;
      async_in        : in  std_logic_vector(1 downto 0);
      sync_out        : out std_logic_vector(1 downto 0)
    );
  end component;
  
  component rising_edge_synchronizer is 
    port (
      clk             : in  std_logic;
      reset_n         : in  std_logic;
      input           : in  std_logic;
      edge            : out std_logic
    );
  end component;

  component alu is
    port (
      clk             : in  std_logic;
      reset_n         : in  std_logic;
      a               : in  std_logic_vector(7 downto 0); 
      b               : in  std_logic_vector(7 downto 0);
      op              : in  std_logic_vector(1 downto 0); -- 00: add, 01: sub, 10: mult, 11: div
      result          : out std_logic_vector(7 downto 0)
    );
  end component;

  component memory is 
    generic (
      addr_width : integer := 2;
      data_width : integer := 4
    );
    port (
      clk             : in  std_logic;
      we              : in  std_logic;
      addr            : in  std_logic_vector(addr_width - 1 downto 0);
      din             : in  std_logic_vector(data_width - 1 downto 0);
      dout            : out std_logic_vector(data_width - 1 downto 0)
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
  signal op_sync      : std_logic_vector(1 downto 0);
  signal ms_sync      : std_logic;
  signal mr_sync      : std_logic;
  signal exe_sync     : std_logic;

  signal alu_out      : std_logic_vector(7 downto 0);
  signal write_en     : std_logic;
  signal address      : std_logic_vector(1 downto 0);
  signal directory    : std_logic_vector(7 downto 0) ;

  signal res          : std_logic_vector(7 downto 0) := "00000000";
  signal res_padded   : std_logic_vector(11 downto 0);
  signal bin_hund     : std_logic_vector(3 downto 0);
  signal bin_tens     : std_logic_vector(3 downto 0);
  signal bin_ones     : std_logic_vector(3 downto 0);

  type calc_state     is (READ_W, WRITE_W_NO_OP, WRITE_W, WRITE_S, READ_S);
  signal pres_state   : calc_state;
  signal next_state   : calc_state;

begin

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
   a             => directory,
   b             => in_sync,
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

        when WRITE_W_NO_OP =>        
          write_en <= '1';
          address <= "00";

        when WRITE_W =>
          if (address="00") then
            res <= alu_out;
          elsif (address="01") then
            res <= directory;
          end if;
              
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