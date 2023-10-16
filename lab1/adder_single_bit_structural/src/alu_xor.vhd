-------------------------------------------------------------------------------
-- M.A.Schneider
-- alu_xor.vhd
-- 9/16/2023
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164;

entity alu_xor is
  port (
    a       : in std_logic;
    b       : in std_logic;
    c       : out std_logic;
  );
end alu_xor;

architecture beh of alu_xor is
begin
  c <= a xor b;
end beh;