-------------------------------------------------------------------------------
-- M.A.Schneider
-- top level for lab 7 simple processor
-- last modified 11/29/23
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

  component rising_edge_synchronizer is 
    port (
      clk             : in  std_logic;
      reset_n         : in  std_logic;
      input           : in  std_logic;
      edge            : out std_logic
    );
  end component;

  component calculator3 is
    port (
      in_switches     : in  std_logic_vector(7 downto 0);
      op_switches     : in  std_logic_vector(1 downto 0);
      ms_btn          : in  std_logic;
      mr_btn          : in  std_logic;
      exe_btn         : in  std_logic;
      clk             : in  std_logic; 
      reset_n         : in  std_logic;
      state_led       : out std_logic_vector(4 downto 0);
      ssd_hund        : out std_logic_vector(6 downto 0);
      ssd_tens        : out std_logic_vector(6 downto 0);
      ssd_ones        : out std_logic_vector(6 downto 0)
    );
  end component;

  component blink_rom
    PORT(
      address         : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      clock           : IN STD_LOGIC  := '1';
      q               : OUT STD_LOGIC_VECTOR (12 DOWNTO 0)
    );
  end component;

  signal execute_sync    : std_logic;
  signal address_sig     : std_logic_vector(3 downto 0) := "0000";
  signal instruction     : std_logic_vector(12 downto 0) := "0000000000000";

  alias op_switches      : std_logic_vector(12 downto 11) IS instruction(12 downto 11);
  alias exe_btn          : std_logic IS instruction(10);
  alias ms_btn           : std_logic IS instruction(9);
  alias mr_btn           : std_logic IS instruction(8);
  alias in_switches      : std_logic_vector(7 downto 0) IS instruction(7 downto 0);

begin

  -- sync top-level execute button
  sync_exe: rising_edge_synchronizer
  port map(
    clk             => clk,
    reset_n         => reset_n,
    input           => execute_btn,
    edge            => execute_sync
  );

  -- update address upon execute button press
  update_address: process(clk,reset_n,address_sig)
  begin
    if reset_n = '0' then
      address_sig <= (others => '0');
    elsif clk'event and clk = '1' then
      if execute_sync = '1' then
        address_sig <= std_logic_vector(unsigned(address_sig) + 1 );
      end if;
    end if;
  end process;

  -- instruction rom
  rom_inst : blink_rom 
  port map (
    address     => address_sig,
    clock       => clk,
    q           => instruction
  );

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
    state_led         => state_led,
    ssd_hund          => ssd_hund,
    ssd_tens          => ssd_tens,
    ssd_ones          => ssd_ones
  );

end beh;