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

entity Blinky is
  port(
    CLOCK  : in std_logic;
    LED1   : out std_logic;
    LED2   : out std_logic;
    LED3   : out std_logic;
    LED4   : out std_logic;
    LED5   : out std_logic;
    SWITCH1 : in std_logic
  );
end entity;

architecture behavioral of Blinky is
	--- Components inclusion ---
	component Blinker is
     port(
       i_CLK  : in std_logic;
       o_OUT  : out std_logic_vector(4 downto 0)
     );
	end component;
  --- Signals definition ---
  signal s_led_out : std_logic_vector(4 downto 0) := "11111";
begin
  --- Processes definition ---

  --- IO mappings ---
  LED1 <= SWITCH1;
  LED2 <= s_led_out(1);
  LED3 <= s_led_out(2);
  LED4 <= s_led_out(3);
  LED5 <= s_led_out(4);
  
  --- Component Instantiation ---
  blinker_inst : Blinker
  port map(
    i_CLK => CLOCK,
    o_OUT => s_led_out
  );
end architecture;


