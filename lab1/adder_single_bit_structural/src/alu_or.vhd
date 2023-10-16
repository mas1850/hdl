-------------------------------------------------------------------------------
-- M.A.Schneider
-- alu_or.vhd
-- 9/16/2023
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164;

entity alu_or is
  port (
    a       : in std_logic;
    b       : in std_logic;
    c       : out std_logic;
  );
end alu_or;

architecture beh of alu_or is
begin
  c <= a or b;
end beh;