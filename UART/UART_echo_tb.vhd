library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;


entity uart_echo_tb is
end entity;

architecture testbench of uart_echo_tb is

    component uart_echo is
        port (
            i_CLK : in std_logic; -- Main system clock
            i_RX : in std_logic; -- Serial data received from outside the FPGA
            o_TX : out std_logic -- Serial data to be sent outside the FPGA
        );
    end component;
    

    constant c_BIT_PERIOD : time := 8680 ns; -- @115200 baud
    signal s_clk : std_logic := '0';
    signal r_recepcion_line : std_logic := '0';
    signal w_transmission_line : std_logic := '1';

    -- Low-level byte-write
    procedure UART_WRITE_BYTE (
        i_data_in       : in  std_logic_vector(7 downto 0);
        signal o_serial : out std_logic) is
    begin
        -- Send Start Bit
        o_serial <= '0';
        wait for c_BIT_PERIOD;

        -- Send Data Byte
        for ii in 0 to 7 loop
            o_serial <= i_data_in(ii);
            wait for c_BIT_PERIOD;
        end loop;  -- ii

        -- Send Stop Bit
        o_serial <= '1';
        wait for c_BIT_PERIOD;
    end procedure;

    function to_string ( a: std_logic_vector) return string is
        variable b : string (1 to a'length) := (others => NUL);
        variable stri : integer := 1; 
    begin
            for i in a'range loop
                b(stri) := std_logic'image(a((i)))(2);
            stri := stri+1;
            end loop;
        return b;
    end function;
begin
    
    s_clk <= not s_clk after 10 ns;

    UART_echo_inst : uart_echo
        port map (
            i_CLK   => s_clk, -- Main system clock
            i_RX    => w_transmission_line, -- Serial data received from outside the FPGA
            o_TX    => r_recepcion_line -- Serial data to be sent outside the FPGA
        );
    
    dut_stimuli : process
        constant c_A : std_logic_vector(7 downto 0) := "01000001";
        variable dataByte : std_logic_vector(7 downto 0) := "00000000";
    begin
        wait for 100 us;
        report "Starting UART echo test";
        wait until rising_edge(s_clk);
        wait until rising_edge(s_clk);
        for i in 0 to 4 loop
            wait until rising_edge(s_clk);
            dataByte  := std_logic_vector(unsigned(c_A) + (to_unsigned(i, 8)));
            report "Sending '0b" & to_string(dataByte) & "'";
            UART_WRITE_BYTE(dataByte, w_transmission_line);
        end loop;
        
        wait for 1 ms;
        assert false report "Tests Complete" severity failure;

    end process;
        
end architecture;