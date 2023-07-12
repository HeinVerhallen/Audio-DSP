library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.fixed_pkg.all;

entity pow10_generator is
    Port (
        mclk            : in  std_logic
        ); 
end pow10_generator;

architecture Behavioral of pow10_generator is
    function pow10 (
        coef : in sfixed(31 downto -32)
    ) return sfixed is
        variable factorial  : sfixed(127 downto -128);
        variable ln10       : sfixed(31 downto -32) := to_sfixed(2.302585, 31, -32);

        variable result : sfixed(127 downto -128);
    begin
        report "computing";

        --Initialize discrete coefficient matrices
        factorial   := to_sfixed(1.0, 127, -128);

        for i in 1 to 34 loop 
            --compute largest factorial possible with 128 bits: 34!
            factorial := resize(factorial * to_sfixed((i), 5, 0), 127, -128);
            report "making factorial: " & integer'image(to_integer(factorial));
        end loop;

        result := resize((to_sfixed(1.0, 1, 0) / factorial), 127, -128);

        --Compute 10^x
        for i in 33 downto 0 loop
            --Compute n!
            factorial := resize(factorial / to_sfixed((i), 5, 0), 127, -128);

            result := resize((to_sfixed(1.0, 1, 0) / factorial) + ln10 * result, 127, -128);
        end loop;

        return resize(result, 31, -32);
    end function pow10;
begin
    process(mclk)

        --type t_factorials is array (0 to 10) of real;
        --constant factorials : t_factorials := (1.0/6.0, 1.0/120.0, 1.0/5040.0, 1.0/362880.0, 1.0/39916800.0, 1.0/6227020800.0, 1.0/1307674368000.0, 1.0/355687428100000.0, 1.0/121645100400000000.0, 1.0/51090942170000000000.0, 1.0/25852016740000000000000.0);


        variable output : sfixed(31 downto -32);
    begin
        if rising_edge(mclk) then

            output := pow10(to_sfixed(1.0, 31, -32));


            --tick_counter := tick_counter + 1;

            --if (tick_counter >= divider) then
            --    tick_counter := 0;

            --    z := index * index;

            --    temp_sine := -index*(1.0+z*(-factorials(0)+z*(factorials(1)+z*(-factorials(2)+z*(factorials(3)+z*(-factorials(4)+z*(factorials(5)+z*(-factorials(6)+z*(factorials(7)+z*(-factorials(8)+z*(factorials(9))))))))))));

            --    resized_sine    := temp_sine * real(to_integer(shifter));
            --    unsigned_sine   := to_signed(integer(temp_sine * real(to_integer(shifter))), d_width);

            --    sinewave    <= std_logic_vector(unsigned_sine);
            --    finished    := '1';

            --    index := index + (step * real(to_integer(unsigned(desired_freq))));
            --    if (index >= limit) then
            --        index := -PI;
            --    end if;
            --else
            --    finished := '0';
            --end if;
        end if;
    end process;
end Behavioral;

