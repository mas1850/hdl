-------------------------------------------------------------------------------
-- M.A.Schneider
-- alu_and.vhd
-- 9/16/2023
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164;

entity alu_and is
  port (
    a       : in std_logic;
    b       : in std_logic;
    c       : out std_logic;
  );
end alu_and;

architecture beh of alu_and is
begin
  c <= a and b;
end beh;