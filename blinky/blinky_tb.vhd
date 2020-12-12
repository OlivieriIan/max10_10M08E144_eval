--------------------------------------------------------------------------------
-- Entity: blinky_tb
--------------------------------------------------------------------------------
-- Filename     : blinky_tb.vhd
-- Creation date: 15-09-2020
-- Author(s)    : Ian Olivieri
-- Version      : 1.00
-- Description  : 
--------------------------------------------------------------------------------
-- File History:
-- Date       Version   Author            Comment
-- 15-09-2020 1.00      Ian Olivieri      Creation of File
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Entity: Blinky
--------------------------------------------------------------------------------
-- Filename     : blinky.vhd
-- Creation date: 15-09-2020
-- Author(s)    : Ian Olivieri
-- Version      : 1.00
-- Description  : 
--------------------------------------------------------------------------------
-- File History:
-- Date       Version   Author            Comment
-- 15-09-2020 1.00      Ian Olivieri      Creation of File
--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity Blinky_tb is
end entity;

architecture testbench of Blinky_tb is
  --- Components declaration ---
  component Blinky is
    port(
      CLOCK  : in std_logic;
      LED1   : out std_logic;
      LED2   : out std_logic;
      LED3   : out std_logic;
      LED4   : out std_logic;
      LED5   : out std_logic
    );
  end component;
  --- Signals definition ---
  constant C_clk_half_period : time := 10 ns; -- = 50MHz
  signal s_clk_50            : std_logic := '0';

begin
  --- Processes definition ---
  dut_stimuli : process
  begin
    report ">> Starting tests <<";
    wait for 1000 ms;
    report ">> Test ended.  <<";
  end process;

  --- IO mappings ---
  s_clk_50 <= not s_clk_50 after C_clk_half_period;

  --- Component Instantiation ---
  dut : Blinky
  port map(
    CLOCK   => s_clk_50
  );


end architecture;
