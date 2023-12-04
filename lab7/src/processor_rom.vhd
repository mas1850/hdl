-------------------------------------------------------------------------------
-- M.A.Schneider
-- ROM for lab 7
-- last modified 11/29/23
-------------------------------------------------------------------------------

entity processor_rom is
  port (
    execute            : in  std_logic;
    clk                : in  std_logic;
    output             : out std_logic;
  )
end processor_rom;

architecture structure of processor_rom is

  type processor_instructions is array(0 to 6) of std_logic_vector(12 downto 0);
  signal 


  --this file may not actually be necessary bc i copy stuff from the blink?