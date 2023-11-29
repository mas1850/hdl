-------------------------------------------------------------------------------
-- M.A.Schneider
-- Components package
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mas_components is
  
  component synchronizer_8bit is 
    port (
      clk             : in  std_logic;
      reset_n         : in  std_logic;
      async_in        : in  std_logic_vector(7 downto 0);
      sync_out        : out std_logic_vector(7 downto 0)
    );
  end component;

  component synchronizer_2bit is 
    port (
      clk             : in  std_logic;
      reset_n         : in  std_logic;
      async_in        : in  std_logic_vector(1 downto 0);
      sync_out        : out std_logic_vector(1 downto 0)
    );
  end component;
  
  component rising_edge_synchronizer is 
    port (
      clk             : in  std_logic;
      reset_n         : in  std_logic;
      input           : in  std_logic;
      edge            : out std_logic
    );
  end component;

  component alu is
    port (
      clk             : in  std_logic;
      reset_n         : in  std_logic;
      a               : in  std_logic_vector(7 downto 0); 
      b               : in  std_logic_vector(7 downto 0);
      op              : in  std_logic_vector(1 downto 0); -- 00: add, 01: sub, 10: mult, 11: div
      result          : out std_logic_vector(7 downto 0)
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

  component memory is 
    generic (
      addr_width : integer := 2;
      data_width : integer := 4
    );
    port (
      clk             : in  std_logic;
      we              : in  std_logic;
      addr            : in  std_logic_vector(addr_width - 1 downto 0);
      din             : in  std_logic_vector(data_width - 1 downto 0);
      dout            : out std_logic_vector(data_width - 1 downto 0)
    );
  end component;
  
  component double_dabble is
    port (
      result_padded   : in  std_logic_vector(11 downto 0); 
      ones            : out std_logic_vector(3 downto 0);
      tens            : out std_logic_vector(3 downto 0);
      hundreds        : out std_logic_vector(3 downto 0)
    );  
  end component;  

  component seven_seg is
    port (
      bcd             : in  std_logic_vector(3 downto 0);
      seven_seg_out   : out std_logic_vector(6 downto 0)
    );  
  end component;

end mas_components;