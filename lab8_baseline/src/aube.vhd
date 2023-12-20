-- .....................................................................
-- So along with my code for dj_roomba_3000.vhd, I've also included code 
-- for falling_edge_synchronizer.vhd. Just trust me and use my synchronizer,
-- I don't really remember what I changed but it's different from Kaputa's.
-- Also^2 I included my code for compile.tcl, it just has an extra line 
-- including falling_edge_synchronizer.vhd. 


-- ==================  start dj_roomba_3000.vhd  =====s=============

-- Aube L 
-- Code for CPET.343 Hardware Description Language Lab 8

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
  
  -- opcode memory
  component rom_instructions
    port(
      address    : in std_logic_vector (4 DOWNTO 0);
      clock      : in std_logic  := '1';
      q          : out std_logic_vector (7 DOWNTO 0)
    );
  end component;
  
  -- data memory
  component rom_data
    port(
      address  : in std_logic_vector (13 DOWNTO 0);
      clock    : in std_logic  := '1';
      q        : out std_logic_vector (15 DOWNTO 0)
    );
  end component;
  
  -- negative edge synchronizer
  component falling_edge_synchronizer is 
    port (
      clk               : in std_logic;
      reset             : in std_logic;
      input             : in std_logic;
      edge              : out std_logic
    );
  end component;

  -- declaring constants for state encoding
  constant idle_state        : std_logic_vector(4 downto 0) := "00001";
  constant fetch_state       : std_logic_vector(4 downto 0) := "00010";
  constant error_check_state : std_logic_vector(4 downto 0) := "00100";
  constant decode_state      : std_logic_vector(4 downto 0) := "01000";
  constant execute_state     : std_logic_vector(4 downto 0) := "10000";

  constant max_data_address  : std_logic_vector(13 downto 0) := (others => '1');

  -- declaring constant to keep track of instruction
  constant play  : std_logic_vector(1 downto 0) := "00";
  constant pause : std_logic_vector(1 downto 0) := "01";
  constant seek  : std_logic_vector(1 downto 0) := "10";
  constant stop  : std_logic_vector(1 downto 0) := "11";

  -- declaring signals for fsm
  signal state_reg           : std_logic_vector(4 downto 0) := idle_state;
  signal state_next          : std_logic_vector(4 downto 0) := idle_state;
  signal error               : std_logic := '0';
  signal execute_signal      : std_logic := '0';
  signal sync_signal         : std_logic := '0';

  -- declaring signals for ROM
  signal data_address        : std_logic_vector(13 downto 0) := (others => '0');
  signal data_address_next   : std_logic_vector(13 downto 0) := (others => '0');
  signal instruction_address : std_logic_vector(4 downto 0) := (others => '0');
  signal opcode              : std_logic_vector(7 downto 0) := (others => '0');
  alias  instruction         : std_logic_vector(1 downto 0) is opcode(7 downto 6);
  alias  seek_address        : std_logic_vector(4 downto 0) is opcode(4 downto 0);
  alias  repeat              : std_logic is opcode(5);
  signal instruction_enable  : std_logic := '0';
  signal seek_enable         : std_logic := '0';
  signal instruction_signal  : std_logic_vector(1 downto 0) := (others => '0');
  signal repeat_signal       : std_logic := '0';
  signal seek_address_signal : std_logic_vector(4 downto 0) := (others => '0');
  signal led_signal          : std_logic_vector(7 downto 0) := (others => '0');

begin

  -- data instantiation
  rom_data_inst : rom_data
    port map (
      address    => data_address,
      clock      => clk,
      q          => audio_out
  );
      
  -- opcode instantiation
  rom_instructions_inst : rom_instructions
    port map (
      address  => instruction_address,
      clock    => clk, 
      q        => opcode
  );

  sync_execute_btn : falling_edge_synchronizer
    port map (
      clk => clk,
      reset => reset,
      input => execute_btn,
      edge => execute_signal
  );

  -- loop audio file
  -- signals edited in this process:
  --   data_address
  get_audio_sample : process(clk,reset)
  begin 
    if (reset = '1' or instruction = stop) then 
      data_address <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (sync = '1' and instruction_enable = '1') then    
        data_address <= std_logic_vector(unsigned(data_address) + 1);
      elsif (sync = '1' and seek_enable = '1') then
        data_address <= seek_address & "000000000";
      end if;
    end if;
  end process;

  -- fetch_state next instrction
  -- signals edited in this process:
  --   instruction_address
  fetch_instruction: process(clk,reset,state_reg)
  begin 
    if (reset = '1') then 
      instruction_address <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (execute_signal = '1') then 
        instruction_address <= std_logic_vector(unsigned(instruction_address) + 1);
      end if;
    end if;
  end process;

  instruction_register : process(state_reg)
  begin
    led_signal <= instruction_signal & repeat_signal & seek_address_signal;
    if (reset = '1') then
      instruction_signal <= (others => '0');
      seek_address_signal <= (others => '0');
      repeat_signal <= '0';
    elsif (clk'event and clk = '1') then
      if (state_reg = fetch_state) then
        instruction_signal <= instruction;
        seek_address_signal <= seek_address;
        repeat_signal <= repeat;
      end if;
      led_signal <= instruction_signal & repeat_signal & seek_address_signal;
    end if;
  end process;

  instruction_logic : process(instruction_signal)
  begin
    instruction_enable <= '0';
    seek_enable <= '0';
    if (instruction = play) then
      instruction_enable <= '1';
      if (data_address = max_data_address and repeat = '0') then
        instruction_enable <= '0';
      end if;
    end if; 
    if (instruction = seek) then
      instruction_enable <= '0';
      seek_enable <= '1';
    end if;
    if (instruction = stop) then
      instruction_enable <= '0';
    end if;
  end process;


  led <= opcode;

  -- state machine stuff
  -- signals edited in this process:
  --   state_reg
  state_register : process(reset,clk,state_next)
  begin
    if (reset = '1') then
      state_reg  <= idle_state;
    elsif (clk'event and clk = '1') then
      state_reg  <= state_next;
    end if;
  end process;

  -- signals edited in this process:
  --   state_next
  next_state_logic : process(execute_signal)
  begin
    state_next <= state_reg; -- prevents a latch
    case (state_reg) is
      when idle_state =>
        if (execute_signal = '1') then
          state_next <= fetch_state;
        else 
          state_next <= idle_state;
        end if;
      when fetch_state =>
        state_next <= error_check_state;
      when error_check_state =>
          state_next <= decode_state;
      when decode_state =>
        state_next <= execute_state;
      when execute_state =>
        state_next <= idle_state;
      when others =>
        state_next <= idle_state;
    end case;
  end process;

end beh;

===================  end dj_roomba_3000.vhd  ===================




==================  start falling_edge_synchronizer.vhd  ==================
-------------------------------------------------------------------------------
-- Dr. Kaputa, Edited by Aube L
-- falling edge synchronizer
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      

entity falling_edge_synchronizer is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
end falling_edge_synchronizer;

architecture beh of falling_edge_synchronizer is
-- signal declarations
signal input_z     : std_logic := '1';
signal input_zz    : std_logic := '1';
signal input_zzz   : std_logic := '1';

begin 
synchronizer: process(reset,clk,input)
  begin
    if reset = '1' then
      input_z     <= '1';
      input_zz    <= '1';
    elsif rising_edge(clk) then
      input_z   <= input;
      input_zz  <= input_z;
    end if;
end process;  

falling_edge_detector: process(reset,clk,input_zz)
  begin
    if reset = '1' then
      edge        <= '0';
      input_zzz   <= '1';
    elsif rising_edge(clk) then
      input_zzz   <= input_zz;
      edge <= (input_zz xor input_zzz) and (not input_zz);
    end if;
end process;  
end beh; 
===================  end falling_edge_synchronizer.vhd  ===================









==================  start compile.tcl  ==================

# Dr. Kaputa
# Quartus II compile script for DE1-SoC board

# 1] name your project here
set project_name "dj_roomba"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE 5CSEMA5F31C6 
set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
set_global_assignment -name QIP_FILE ../../src/rom_data/rom_data.qip
set_global_assignment -name QIP_FILE ../../src/rom_instructions/rom_instructions.qip
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_Audio_Bit_Counter.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_Audio_In_Deserializer.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_Audio_Out_Serializer.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_Clock_Edge.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_I2C.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_I2C_AV_Auto_Initialize.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_I2C_DC_Auto_Initialize.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_I2C_LCM_Auto_Initialize.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_Slow_Clock_Generator.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_SYNC_FIFO.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/audio_and_video_config.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/audio_codec.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/clock_generator.v
set_global_assignment -name VHDL_FILE ../../src/falling_edge_synchronizer.vhd
set_global_assignment -name VHDL_FILE ../../src/rising_edge_synchronizer.vhd
set_global_assignment -name VHDL_FILE ../../src/generic_counter.vhd
set_global_assignment -name VHDL_FILE ../../src/dj_roomba_3000.vhd
set_global_assignment -name VHDL_FILE ../../src/top.vhd

^
|
|
Everything after this point is the same as the compile.tcl downloaded from mycourses.

===================  end compile.tcl  ===================
to_mas.txt
Displaying to_mas.txt.