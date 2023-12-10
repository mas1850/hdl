-------------------------------------------------------------------------------
-- Dr. Kaputa
-- pipeline example
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;     

entity pipeline is
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    result        : out std_logic_vector(15 downto 0)
  );  
end pipeline;  

architecture beh of pipeline  is

component generic_counter is
  generic (
    max_count        : integer range 0 to 10000 := 3
  );
  port (
    clk              : in  std_logic; 
    reset            : in  std_logic;
    output           : out std_logic
  );  
end component;  

constant PIPELINE_FLAG   : boolean := true; -- changed from false to true 
signal enable            : std_logic;
signal a                 : std_logic_vector(7 downto 0) := "00000001";
signal result_temp       : std_logic_vector(15 downto 0);
signal result_async      : std_logic_vector(15 downto 0);

begin

uut: generic_counter  
  generic map (
    max_count => 4   
  )
  port map(
    clk       => clk,
    reset     => reset,
    output    => enable
  );

process(clk,reset)
  begin
    if (reset = '1') then 
      a <= (others => '0');
    elsif (clk'event and clk = '1') then
      if enable = '1' then
        a  <= std_logic_vector(unsigned(a) + 1);
      end if;
    end if;
  end process;

-- operation without pipelining
pipeline_off: if not PIPELINE_FLAG generate
  result_temp  <= std_logic_vector(unsigned(a) * unsigned(a));
  result_async <= std_logic_vector(unsigned(result_temp(7 downto 0)) * unsigned(a));
    
  process(clk,reset)
    begin
      if (reset = '1') then 
        result <= (others => '0');
      elsif (clk'event and clk = '1') then
        result <= result_async;
      end if;
    end process;
end generate pipeline_off;

-- operation with pipelining
pipeline_on: if PIPELINE_FLAG generate
  process(clk,reset)
    begin
      if (reset = '1') then 
        result <= (others => '0');
        result_temp <= (others => '0');
      elsif (clk'event and clk = '1') then
        result_temp  <= std_logic_vector(unsigned(a) * unsigned(a));
        result <= std_logic_vector(unsigned(result_temp(7 downto 0)) * unsigned(a)); 
      end if;
    end process;
end generate pipeline_on;  
end beh;