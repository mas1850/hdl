-------------------------------------------------------------------------------
-- M.A.Schneider
-- Lab 8: DJ Roomba 3000
-- last modified 12/14/23
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
  
  signal data_address  : std_logic_vector(13 downto 0);
  signal audio_out     : std_logic_vector(15 downto 0);

  signal inst_address  : std_logic_vector(4 downto 0);
  signal instruction   : std_logic_vector(7 downto 0);
  alias operation      : std_logic_vector(1 downto 0) is instruction(7 downto 6);
  alias repeat         : std_logic is instruction(5);
  alias seek_field     : std_logic_vector(4 downto 0) is instruction(4 downto 0);

  signal execute_sync  : std_logic;

  type audio_state    is (IDLE, FETCH, DECODE, EXECUTE, DECODE_ERROR);
  signal pres_state   : audio_state;
  signal next_state   : audio_state;

begin

  -- data instantiation
  u_rom_data_inst : rom_data
    port map (
      address    => data_address,
      clock      => clk,
      q          => audio_out
    );

  -- instruction instantiation and led output
  u_rom_instruction_inst : rom_instruction
    port map (
      address    => inst_address,
      clock      => clk,
      q          => instruction
    );
  led <= instruction;

  -- synchronize execute button
  sync_execute_btn: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset           => reset,
    input           => execute_btn,
    edge            => execute_sync
  );

  -- next state logic and state register
  state_reg: process(reset_n, clk)
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
        when FETCH =>
          -- increment program counter (which will pull a new instruction from memory)
          inst_address <= inst_address + 1;
        when DECODE =>
          -- somehow determine inst type and validity
        when EXECUTE =>
          -- run command
        when DECODE_ERROR =>
          -- nothing?
      

      --   when READ_W =>
      --     write_en <= '0';
      --     address <= "00";

      --   when WRITE_W_NO_OP =>        
      --     write_en <= '1';
      --     address <= "00";

      --   when WRITE_W =>
      --     if (address="00") then
      --       res <= alu_out;
      --     elsif (address="01") then
      --       res <= directory;
      --     end if;
              
      --   when WRITE_S =>
      --     write_en <= '1';
      --     address <= "01";

      --   when READ_S =>
      --     write_en <= '0';
      --     address <= "01";
      --     res <= directory;
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

  digital_mux: process()
  begin
    --connects to clouds signals or sumn
    -- recieves pres_state
    -- releases addr_sel to data_reg
    -- play
      -- w repeat
      -- w/o repeat
    -- pause
    -- stop
  end process;

  data_reg: process(clk, pres_state, addr_sel)
  begin
    -- recieves addr_sel and pres_state
    -- releases addr
    -- addr is audio_out?
  end process;



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