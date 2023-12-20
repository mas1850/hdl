-------------------------------------------------------------------------------
-- M.A.Schneider
-- Lab 8: DJ Roomba 3000
-- last modified 12/19/23
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dj_roomba_3000 is 
  port(
    clk                 : in std_logic;
    reset               : in std_logic;
    execute_btn         : in std_logic;
    sync                : in std_logic;
    led                 : out std_logic_vector(7 downto 0);
    audio_out           : out std_logic_vector(15 downto 0)
  );
end dj_roomba_3000;

architecture beh of dj_roomba_3000 is

  -- instruction memory
  component rom_instructions
    port(
      address    : in std_logic_vector (4 downto 0);
      clock      : in std_logic  := '1';
      q          : out std_logic_vector (7 downto 0)
    );
  end component;
  
  -- data memory
  component rom_data
    port(
      address  : in std_logic_vector (13 downto 0);
      clock    : in std_logic  := '1';
      q        : out std_logic_vector (15 downto 0)
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
  
  signal data_address  : std_logic_vector(13 downto 0);
  signal sel_addr      : std_logic_vector(13 downto 0);

  signal inst_address  : std_logic_vector(4 downto 0);
  signal instruction   : std_logic_vector(7 downto 0);
  signal operation     : std_logic_vector(1 downto 0);
  signal repeat        : std_logic;
  signal seek_field    : std_logic_vector(13 downto 0);

  signal execute_sync  : std_logic;
  signal decode_flag   : std_logic := '0';
  signal execute_flag  : std_logic := '0';



  type audio_state     is (IDLE, FETCH, DECODE, EXECUTE, DECODE_ERROR);
  signal pres_state    : audio_state;
  signal next_state    : audio_state;

begin

  -- synchronize execute button
  sync_execute_btn: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset           => reset,
    input           => execute_btn,
    edge            => execute_sync
  );

  -- next state logic and state register
  state_reg: process(reset, clk)
  begin
    if (reset = '1') then
      pres_state <= IDLE;
    elsif(rising_edge(clk)) then
      pres_state <= next_state;
    end if;

    if(rising_edge(clk)) then
      case pres_state is
      
        when IDLE =>
          -- nothing
          decode_flag <= '0';
          execute_flag <= '0';

        when FETCH =>
          -- increment program counter (which will pull a new instruction from memory)
          inst_address <= std_logic_vector(unsigned(inst_address) + 1);
          execute_flag <= '0';

        when DECODE =>
          -- somehow determine inst type and validity
          decode_flag <= '1';

        when EXECUTE =>
          -- run command
          decode_flag <= '0';
          execute_flag <= '1';

        when DECODE_ERROR =>
          -- nothing?
          decode_flag <= '0';

      end case;
    end if;
  end process; -- end state register

  next_state_logic: process(pres_state, execute_sync, sync)
  begin
    next_state <= pres_state;
    case pres_state is

      when IDLE =>
        if (execute_sync = '1') then
          next_state <= FETCH; 
        end if;

      when FETCH =>
        next_state <= DECODE;

      when DECODE =>
        if (operation = "10" and seek_field = "00000") then
          next_state <= DECODE_ERROR;
        else
          next_state <= EXECUTE;
        end if;

      when EXECUTE =>
        if (execute_sync = '1') then
          next_state <= FETCH; 
        end if;

      when DECODE_ERROR =>
        next_state <= IDLE;

    end case;
  end process; -- end next state logic

  -- instruction instantiation and led output
  rom_instructions_inst : rom_instructions
    port map (
      address    => inst_address,
      clock      => clk,
      q          => instruction
    );
  led <= instruction;

  -- decode inst
  decode_inst: process(clk, decode_flag)
  begin
    --if (decode_flag = '1') then
      operation <= instruction(7 downto 6);
      repeat <= instruction(5);
      seek_field <= instruction(4 downto 0) & "000000000" ;
    --end if;
  end process;

  -- determines sel_addr
  mux: process(sel_addr, operation, clk)
  begin
    case operation is
      when "00" => -- play
        if not (data_address = "00000000000000" and repeat = '0') then
          sel_addr <= std_logic_vector(unsigned(data_address) + 1);
        else
          sel_addr <= data_address;
        end if;
      when "01" => -- pause
        sel_addr <= data_address;
      when "10" => -- seek
        sel_addr <= seek_field;
      when others => -- stop and default
        sel_addr <= (others => '0');
    end case;
  end process;

  -- defines data
  data_reg: process(clk, pres_state, data_address, execute_flag)
  begin
    -- recieves addr_sel and pres_state
    -- releases addr
    -- addr is audio_out?
    data_address <= sel_addr;
  end process;

  -- data instantiation
  rom_data_inst : rom_data
    port map (
      address    => data_address,
      clock      => clk,
      q          => audio_out
    );

  -- -- loop audio file
  -- process(clk,reset)
  -- begin 
  --   if (reset = '1') then 
  --     data_address <= (others => '0');
  --   elsif (clk'event and clk = '1') then
  --     if (sync = '1') then    
  --       data_address <= std_logic_vector(unsigned(data_address) + 1 );
  --     end if;
  --   end if;
  -- end process;
end beh;