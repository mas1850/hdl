-------------------------------------------------------------------------------
-- M.A.Schneider
-- single bit full adder [structural]
-- completed architecture
-- 9/16/2023
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder_single_bit_beh is  -- structural
  port (
    a       : in std_logic;
    b       : in std_logic;
    cin     : in std_logic;
    sum     : out std_logic;
    cout    : out std_logic
  );
end full_adder_single_bit_beh;

architecture beh of full_adder_single_bit_beh is

component alu_and
  port (
    a       : in std_logic;
    b       : in std_logic;
    c       : out std_logic;
  );
end component;  

component alu_or
  port (
    a       : in std_logic;
    b       : in std_logic;
    c       : out std_logic;
  );
end component;  

component alu_xor
  port (
    a       : in std_logic;
    b       : in std_logic;
    c       : out std_logic;
  );
end component;      

signal temp1   : std_logic;
signal temp2   : std_logic;
signal temp3   : std_logic;
signal temp4   : std_logic;
signal temp5   : std_logic;

begin 
  and1_inst: alu_and
  --inputs a+b -> temp1 -> or1
    port map(
      a     => a,
      b     => b,
      c     => temp1
    );

  and2_inst: alu_and
  --inputs a+cin -> temp2 -> or1
    port map(
      a     => a,
      b     => cin,
      c     => temp2
);

  and3_inst: alu_and
  --inputs cin+b -> temp4 -> or2
    port map(
      a     => cin,
      b     => b,
      c     => temp4
);

  or1_inst: alu_or
  --temp1|temp2 -> temp4 -> or2
    port map(
      a     => temp1,
      b     => temp2,
      c     => temp4
);

  or2_inst: alu_or
  --temp3|temp4 -> cout
    port map(
      a     => temp3,
      b     => temp4,
      c     => cout
);

  xor1_inst: alu_xor
  --inputs a^b -> temp5 -> xor2
    port map(
      a     => a,
      b     => b,
      c     => temp5
);

  xor2_inst: alu_xor
  --input cin|temp5 -> sum
    port map(
      a     => temp5,
      b     => cin,
      c     => sum
);