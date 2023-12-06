-------------------------------------------------------------------------------
-- M.A.Schneider
-- synchronizer 2 bit
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      

entity synchronizer_2bit is 
  port (
    clk               : in std_logic;
    reset_n           : in std_logic;
    async_in          : in std_logic_vector(1 downto 0);
    sync_out          : out std_logic_vector(1 downto 0)
  );
end synchronizer_2bit;

architecture beh of synchronizer_2bit is
-- signal declarations
signal flop1     : std_logic_vector(1 downto 0);
signal flop2     : std_logic_vector(1 downto 0);

begin 

  double_flop :process(reset_n,clk,async_in)
  begin
    if reset_n = '0' then
      flop1 <= "00";   
      flop2 <= "00";	
    elsif rising_edge(clk) then
      flop1 <= async_in;
      flop2 <= flop1;
    end if;
  end process;
  sync_out <= flop2;
  
end beh; 