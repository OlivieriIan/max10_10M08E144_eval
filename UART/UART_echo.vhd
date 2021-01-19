library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;


entity uart_echo is
    port (
        i_CLK     : in std_logic; -- Main system clock
        i_RX      : in std_logic; -- Serial data read into the FPGA
        o_TX      : out std_logic; -- Serial data sent out from the FPGA
        o_LED     : out std_logic -- LED output
    );
end entity;

architecture behavioral of uart_echo is

    component uart_tx is
        generic (
            g_CLKS_PER_BIT : integer := 43   -- Needs to be set correctly
        );
        port (
            i_clk       : in  std_logic;
            i_tx_dv     : in  std_logic;
            i_tx_byte   : in  std_logic_vector(7 downto 0);
            o_tx_active : out std_logic;
            o_tx_serial : out std_logic;
            o_tx_done   : out std_logic
        );
    end component;
    
    component uart_rx is
        generic (
            g_CLKS_PER_BIT : integer := 43   -- Needs to be set correctly
        );
        port (
            i_clk       : in  std_logic;
            i_rx_serial : in  std_logic;
            o_rx_dv     : out std_logic;
            o_rx_byte   : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- CLKs per bit = FPGA_clk / bit_rate. In this case: 50MHz/115200baud
    constant c_CLKS_PER_BIT : integer := 434;    
    signal r_RX_ready : std_logic := '0'; 
    signal r_RX_byte : std_logic_vector(7 downto 0) := X"00";
    signal w_TX_send : std_logic := '0';
    signal r_TX_ready : std_logic := '0';
    signal w_LED_state : std_logic := '0';
begin
    
    -- Instantiate UART transmitter
    UART_TX_INST : uart_tx
        generic map (
            g_CLKS_PER_BIT => c_CLKS_PER_BIT
        )
        port map (
            i_clk       => i_CLK,
            i_tx_dv     => w_TX_send,
            i_tx_byte   => r_RX_byte,
            o_tx_active => open,
            o_tx_serial => o_TX,
            o_tx_done   => r_TX_ready
        );
    
    -- Instantiate UART Receiver
    UART_RX_INST : uart_rx
        generic map (
            g_CLKS_PER_BIT => c_CLKS_PER_BIT
        )
        port map (
            i_clk       => i_CLK,
            i_rx_serial => i_RX,
            o_rx_dv     => r_RX_ready,
            o_rx_byte   => r_RX_byte
        );
    
    echo: process(i_CLK)
        type t_states is (s_idle, s_sending);
        variable state : t_states := s_idle;
    begin
        if rising_edge(i_Clk) then
            case state is
                -- Wait until a byte is received
                when s_idle =>
                    if r_RX_ready = '1' then
                        w_LED_state <= not w_LED_state;
                        w_TX_send <= '1';
                        state := s_sending;
                    end if;
                when s_sending =>
                    w_TX_send <= '0';
                    state := s_idle;
            end case;
        end if;
    end process;

    o_LED <= w_LED_state;
        
end architecture;