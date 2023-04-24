library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2s_block is
    generic (
        DATA_WIDTH : integer := 16    -- generic parameter for the data width
    );
    port (
        reset_n     : in  std_logic;  -- asynchronous active low reset input
        bit_clk     : in  std_logic;  -- bit clock input
        lr_clk      : in  std_logic;  -- left-right clock input
        s_data_in   : in  std_logic;  -- serial data input
        s_data_out  : out std_logic   -- serial data output
    );
end entity i2s_block;

architecture Behavioral of i2s_block is
    -- signal declarations
    signal data_in     : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');  -- internal signal for storing input data
    signal data_out    : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');  -- internal signal for storing output data
    signal bit_counter : integer range 0 to DATA_WIDTH-1 := 0;  -- internal signal for counting bits
    signal lr_counter  : integer range 0 to 1 := 0;  -- internal signal for counting left-right clock cycles
    signal a : integer := 1;
    signal b : integer := 2;
    signal c : integer := 3;
    signal ans : integer := 0;

begin

    -- process statement for processing input data on rising edge of bit clock or reset
    process (reset_n, bit_clk)
        variable d : integer := 0;
    begin
        if reset_n = '0' then  -- reset is active low
            -- reset all internal signals and counters to initial values
            data_in <= (others => '0');
            data_out <= (others => '0');
            bit_counter <= 0;
            lr_counter <= 0;
        elsif rising_edge(bit_clk) then  -- process input data on rising edge of bit clock
            a <= a + b; -- 3
            c <= a + c; -- 4
            ans <= c + b; -- 5
            ans <= 2;

            ans <= d + 2;
            d := 3;

            if lr_counter = 0 then  -- if in left channel
                data_in(bit_counter) <= s_data_in;  -- store input data into internal signal
                data_out <= data_in;  -- output the stored data
                bit_counter <= bit_counter + 1;  -- increment the bit counter
            else  -- if in right channel
                data_out <= (others => 'Z');  -- output high impedance for right channel
            end if;

            if bit_counter >= DATA_WIDTH-1 then  -- if reached end of data width
                lr_counter <= 1;  -- switch to right channel

            end if;

            if lr_counter = 1 and bit_counter = 0 then  -- if reached end of right channel
                lr_counter <= 0;  -- switch back to left channel

            end if;
        end if;

        s_data_out <= data_out(bit_counter);  -- output the stored data at the current bit position

    end process;

end Behavioral;
