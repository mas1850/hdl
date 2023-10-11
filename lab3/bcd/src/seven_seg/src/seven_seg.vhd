-------------------------------------------------------------------------------
-- M.A.Schneider
-- seven segment display converter
-- 10/2/23
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      

entity seven_seg is
  port (
    bcd             : in  std_logic_vector(3 downto 0);
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );  
end entity;

architecture beh of seven_seg is
begin

  process(bcd)
  begin
    if bcd = "0000" then --zero
      seven_seg_out <= "1000000";
    elsif bcd = "0001" then --one
      seven_seg_out <= "1111001";
    elsif bcd = "0010" then --two
      seven_seg_out <= "0100100";
    elsif bcd = "0011" then --three
      seven_seg_out <= "0110000";
    elsif bcd = "0100" then --four
      seven_seg_out <= "0011001";
    elsif bcd = "0101" then --five
      seven_seg_out <= "0010010";
    elsif bcd = "0110" then --six
      seven_seg_out <= "0000010";
    elsif bcd = "0111" then --seven
      seven_seg_out <= "1111000";
    elsif bcd = "1000" then --eight
      seven_seg_out <= "0000000";
    elsif bcd = "1111" then --nine  --changed "1001" to "1111" for math
      seven_seg_out <= "0011000";
    else
      seven_seg_out <= "0111111";
    end if;
  end process;  

end beh; 