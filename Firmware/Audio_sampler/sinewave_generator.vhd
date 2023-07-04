library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sinewave_generator is
    GENERIC(
        d_width         : integer := 24;
        mclk_freq       : integer := 50000000;
        sample_freq     : integer := 192000);
    Port (
        mclk            : in  std_logic;
        desired_freq    : in std_logic_vector(31 downto 0);
        sinewave        : out std_logic_vector(d_width-1 downto 0);
        o_avail         : out std_logic
        ); 
end sinewave_generator;

architecture Behavioral of sinewave_generator is

begin
    process(mclk)
        constant PI     : real := 3.14159265;
        constant limit  : real := PI - (2.0*PI/real(sample_freq));
        constant step   : real := 2.0*PI/real(sample_freq);
        variable index  : real := -PI;
        variable z      : real;

        type t_factorials is array (0 to 10) of real;
        constant factorials : t_factorials := (1.0/6.0, 1.0/120.0, 1.0/5040.0, 1.0/362880.0, 1.0/39916800.0, 1.0/6227020800.0, 1.0/1307674368000.0, 1.0/355687428100000.0, 1.0/121645100400000000.0, 1.0/51090942170000000000.0, 1.0/25852016740000000000000.0);

        variable temp_sine      : real := 0.0;
        variable resized_sine   : real := 0.0;
        variable unsigned_sine  : signed(d_width-1 downto 0) := (others => '0');
        variable shifter        : unsigned(d_width-1 downto 0) := (d_width-1 => '0', others => '1');

        constant divider        : integer := mclk_freq/sample_freq;
        variable tick_counter   : integer := 0;

        variable finished : std_logic := '0';

    begin
        if rising_edge(mclk) then
            tick_counter := tick_counter + 1;

            if (tick_counter >= divider) then
                tick_counter := 0;

                z := index * index;

                temp_sine := -index*(1.0+z*(-factorials(0)+z*(factorials(1)+z*(-factorials(2)+z*(factorials(3)+z*(-factorials(4)+z*(factorials(5)+z*(-factorials(6)+z*(factorials(7)+z*(-factorials(8)+z*(factorials(9))))))))))));

                resized_sine    := temp_sine * real(to_integer(shifter));
                unsigned_sine   := to_signed(integer(temp_sine * real(to_integer(shifter))), d_width);

                sinewave    <= std_logic_vector(unsigned_sine);
                finished    := '1';

                index := index + (step * real(to_integer(unsigned(desired_freq))));
                if (index >= limit) then
                    index := -PI;
                end if;
            else
                finished := '0';
            end if;
        elsif falling_edge(mclk) then
            if (finished = '1') then
                o_avail <= '1';
            else
                o_avail <= '0';
            end if;
        end if;
    end process;
end Behavioral;

