library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.fixed_pkg.all;
use IEEE.math_real.all;

entity BPF_filter_v2 is
    GENERIC(
        d_width     : integer := 24;         --data width of input and output
        freq_sample : integer := 192000;    --sample frequency
        freq_res    : integer := 1000);      --resonance frequency
    Port ( 
        mclk    : in std_logic;                             --master clock
        d_in    : in  std_logic_vector(d_width-1 downto 0); --input data
        i_avail : in  std_logic;                            --input data available
        param   : in  std_logic_vector(5 downto 0);         --gain parameter
        d_out   : out std_logic_vector(d_width-1 downto 0); --output data
        o_avail : out std_logic                             --output data available
        ); 
end BPF_filter_v2;

architecture Behavioral of BPF_filter_v2 is
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

    constant twoPI : real := 6.283185;

    constant order : integer := 2;
    type matrix_A is array (0 to 2*order-1) of real;
    type matrix_B is array (0 to order-1) of real;

    signal state : matrix_B := (0.0, 0.0);

begin
    process(mclk)
        variable gain                   : real := 0.0;
        variable unsigned_gain          : unsigned(param'length-1 downto 0) := (others => '0');
        constant saturation_limit       : signed(d_width-1 downto 0) := (d_width-1 => '0', others => '1');
        constant fl_saturation_limit    : real := real(to_integer(unsigned(saturation_limit)));

        variable coef_A : matrix_A;
        variable coef_B : matrix_B;
        variable coef_C : matrix_B := (0.0, 1.0); --can use the same array size as B
        
        variable coef_A_pow      : matrix_A;
        variable coef_temp_A_pow : matrix_A;
        variable identity_matrix : matrix_A := (1.0, 0.0, 0.0, 1.0);

        variable factorial          : real := 1.0;
        variable sample_time        : real := 1.0/real(freq_sample);
        variable sample_time_pow    : real := sample_time;

        variable fl_coef_Ad : matrix_A := identity_matrix;
        variable fl_coef_Bd : matrix_B := (coef_B(0)*sample_time, coef_B(1)*sample_time);

        variable temp_state : matrix_B;

        variable finished : std_logic := '0';

    begin
        if rising_edge(mclk) then
            --Set output available low
            finished := '0';

            if (unsigned_gain /= unsigned(param)) then
                unsigned_gain := unsigned(param);

                --Compute gain from dB input. Compensate the -6dB point at res_freq by multiplying by 2
                gain := 2.0 * (10.0 ** ((real(to_integer(unsigned(param))) - 32.0) / 20.0));

                --Compute new coefficients
                coef_A := (-twoPI*real(freq_res), 0.0, -gain*twoPI*real(freq_res), -twoPI*real(freq_res));
                coef_B := (twoPI*real(freq_res), gain*twoPI*real(freq_res));

                --Initialize discrete coefficient matrices
                coef_A_pow      := coef_A;
                fl_coef_Ad      := identity_matrix;
                fl_coef_Bd      := (coef_B(0)*sample_time, coef_B(1)*sample_time);

                factorial       := 1.0;
                sample_time_pow := sample_time;

                --Compute AT + A^2*T^2/2 + ...
                compute_Ad_and_Bd : for i in 0 to 10 loop

                    --Compute Resulting Ad and Bd
                    for j in 0 to 1 loop
                        --Compute Bd
                        fl_coef_Bd(j) := fl_coef_Bd(j) + (((coef_A_pow(j*2)*coef_B(0) + coef_A_pow(j*2+1)*coef_B(1))*sample_time_pow*sample_time)/(factorial * real(i+2)));

                        for k in 0 to 1 loop
                            --Compute Ad
                            fl_coef_Ad(j*2+k) := fl_coef_Ad(j*2+k) + ((coef_A_pow(j*2+k)*sample_time_pow)/factorial);
                        end loop;
                    end loop;

                    --Compute A to the power of n in temporary matrix 
                    for j in 0 to 1 loop
                        for k in 0 to 1 loop
                            coef_temp_A_pow(j*2+k) := coef_A_pow(j*2)*coef_A(k) + coef_A_pow(j*2+1)*coef_A(2+k);
                        end loop;
                    end loop;

                    --Copy temp to power of A matrix
                    coef_A_pow := coef_temp_A_pow;

                    --Compute T^n and n!
                    sample_time_pow := sample_time_pow*sample_time;
                    factorial       := factorial * real(i+2);

                end loop compute_Ad_and_Bd;

            --sample is available and process is not currently active
            elsif (i_avail = '1') then
                for i in 0 to 1 loop
                    temp_state(i) := fl_coef_Ad(i*2)*state(0) + fl_coef_Ad(i*2+1)*state(1) + fl_coef_Bd(i)*real(to_integer(signed(d_in)));
                    
                    state(i) <= temp_state(i);
                end loop;

                --Output is larger then integer maximum
                if (temp_state(1) > fl_saturation_limit) then
                    --Clip at integer maximum
                    d_out <= std_logic_vector(saturation_limit);
                --Output is smaller then integer minimum
                elsif (temp_state(1) < -fl_saturation_limit) then
                    --Clip at integer minimum
                    d_out <= std_logic_vector((not saturation_limit) - "1");
                --Output within integer range
                else 
                    --Compress output correctly to fit d_out
                    d_out <= std_logic_vector(compress(to_signed(integer(temp_state(1)), 32), d_width));
                end if;

                --Computation is finished
                finished := '1';
            end if;
        elsif falling_edge(mclk) then
            if (finished = '1') then
                --Set output available
                o_avail <= '1';
            else
                --Disable output available
                o_avail <= '0';
            end if;
        end if;
    end process;
end Behavioral;