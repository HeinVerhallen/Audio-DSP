library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.fixed_pkg.all;
use IEEE.math_real.all;

entity fixedPointTest is
    Port ( 
        d_in    : in  std_logic_vector(23 downto 0); --input data
        d_out   : out std_logic_vector(23 downto 0) --output data
        ); 
end fixedPointTest;

architecture Behavioral of fixedPointTest is
    function compress (
        a       : in unsigned;  --Value to be compressed
        d_width : in integer    --The size where the input value needs to be compressed to
    ) return unsigned is
        constant max            : unsigned(d_width-1 downto 0) := (others => '1');  --minimal value for input value to be shifted

        variable temp_mirror    : unsigned(0 to a'length-1);        --mirrored temp value
        variable shiftVal       : unsigned(a'length-1 downto 0);    --value that the input needs to be shifted

        variable temp_result    : unsigned(a'length*2-1 downto 0);  --temporary result
        variable result         : unsigned(d_width-1 downto 0);     --final result
    begin
        --Input is larger than maximum 
        if (a > max) then
            --Mirror input
            for i in 0 to a'length-1 loop
                temp_mirror(i) := a(i);
            end loop;

            --Compute amount of shifts for the value to line up correctly
            shiftVal := temp_mirror and not (temp_mirror - "1");

            --Shift input value by computed shift value
            temp_result := a * shiftVal;

            --Resize and set d_width amount of MSB to result
            result := resize(temp_result(a'length-1 downto a'length-d_width), d_width);
        else
            --Set d_width amount of input bits to result
            result := a(d_width-1 downto 0);
        end if;

        return result;
    end compress;

    function compress (
        a       : in signed;    --Value to be compressed
        d_width : in integer    --The size where the input value needs to be compressed to
    ) return signed is
        constant max_signed     : unsigned(d_width-2 downto 0) := (others => '1');  --minimal value for a negative valued input to be shifted
        constant max_unsigned   : unsigned(d_width-1 downto 0) := (others => '1');  --minimal value for a positive valued input to be shifted

        variable temp_a         : unsigned(a'length-1 downto 0);    --temporary input value
        variable temp_mirror    : unsigned(0 to a'length-1);        --mirrored temp value
        variable shiftVal       : unsigned(a'length-1 downto 0);    --value that the input needs to be shifted

        variable temp_result    : signed(a'length*2-1 downto 0);    --temporary result
        variable result         : signed(d_width-1 downto 0);       --final result
    begin
        --Convert signed input to unsigned value
        temp_a := unsigned(a);

        --If signed make unsigned
        if (temp_a(a'left) = '1') then 
            temp_a := (not temp_a) + 1; 
        end if;

        if ((a(a'left) = '0' and temp_a > max_unsigned) or (a(a'left) = '1' and temp_a > max_signed)) then
            --Mirror temp
            for i in 0 to a'length-1 loop
                temp_mirror(i) := temp_a(i);
            end loop;

            --Compute amount of shifts for the value to line up correctly
            shiftVal := ((temp_mirror and not (temp_mirror - 1)) / 2);

            --Correct for zero value
            if (shiftVal < 1) then
                shiftVal := shiftVal + 1;
            end if;

            --Shift input value by computed shift value
            temp_result := a * signed(shiftVal);

            --Resize and set d_width amount of MSB to result
            result := resize(temp_result(a'length-1 downto a'length-d_width), d_width);
        --Input is signed
        elsif a(a'left) = '1' then
            --Set d_width amount of input bits to result
            result := a(d_width-1 downto 0);

        --Input is unsigned
        else
            --Set d_width amount of input bits minus sign position bit to result
            result := '0' & a(d_width-2 downto 0);
        end if;

        return result;
    end compress;

    --constant int_a : real := 3.14;
    --constant int_b : real := 15.95;

    signal a : ufixed(15 downto -16) := to_ufixed(3.14, 15, -16);
    signal b : ufixed(15 downto -16) := to_ufixed(15.95, 15, -16);
    signal c : ufixed(15 downto -16);

    --constant int_d : real := 6.28;
    --constant int_e : real := -15.95;

    signal d : sfixed(15 downto -16) := to_sfixed(6.28, 15, -16);
    signal e : sfixed(15 downto -16) := to_sfixed(-15.95, 15, -16);
    signal f : sfixed(15 downto -16);

    type matrix_B is array (0 to 1) of sfixed(31 downto -32);

    signal Bd : matrix_B := (to_sfixed(-150994944.543, 31, -32), to_sfixed(-1024.9543, 31, -32));

    signal signedVal1 : signed(23 downto 0) := compress(to_signed(Bd(0), 32), 24);
    signal signedVal2 : signed(23 downto 0) := compress(to_signed(Bd(1), 32), 24);

begin
    process(d_in)
        
    begin
        c <= resize(a * b, 15, -16);
        f <= resize(d * e, 15, -16);
    end process;
end Behavioral;
