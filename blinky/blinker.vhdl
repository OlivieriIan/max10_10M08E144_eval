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

entity Blinker is
  port(
    i_CLK  : in std_logic; -- Input clock
    -- 
    o_OUT  : out std_logic_vector(4 downto 0)
  );
end entity;

architecture behavioral of Blinker is
  --- Signals definition ---
  signal s_out : unsigned(4 downto 0) := "00000";
begin
  --- Processes definition ---
  toggle_led : process (i_CLK) is
    -- counts for a blink freq: CLK freq / blink freq * Duty cycle
    -- if i_CLK = 50MHz, period = 5e6 will result in 0.2Hz blink
    constant c_period : integer := 5000000;
    variable cnt: integer range 0 to c_period := 0;
  begin
    if rising_edge(i_CLK) then
      cnt := cnt + 1;
      if (cnt = c_period) then
        cnt := 0;
        s_out <= s_out + 1; -- toggle led output
      end if;
    end if;
  end process;

  --- IO mappings ---
  o_OUT <= std_logic_vector(s_out);
end architecture;


