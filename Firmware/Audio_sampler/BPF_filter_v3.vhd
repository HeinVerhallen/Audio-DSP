library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.fixed_pkg.all;
use IEEE.math_real.all;

entity BPF_filter_v3 is
    GENERIC(
        d_width     : integer := 24;         --data width of input and output
        freq_sample : integer := 192000;    --sample frequency
        freq_res    : integer := 1000);      --resonance frequency
    Port ( 
        mclk    : in std_logic;                             --master clock
        nrst    : in std_logic;                             --active-low reset
        d_in    : in  std_logic_vector(d_width-1 downto 0); --input data
        i_avail : in  std_logic;                            --input data available
        param   : in  std_logic_vector(5 downto 0);         --gain parameter
        d_out   : out std_logic_vector(d_width-1 downto 0); --output data
        o_avail : out std_logic                             --output data available
        ); 
end BPF_filter_v3;

architecture Behavioral of BPF_filter_v3 is
    --function compress (
    --    a       : in unsigned;  --Value to be compressed
    --    d_width : in integer    --The size where the input value needs to be compressed to
    --) return unsigned is
    --    constant max            : unsigned(d_width-1 downto 0) := (others => '1');  --minimal value for input value to be shifted

    --    variable temp_mirror    : unsigned(0 to a'length-1);        --mirrored temp value
    --    variable shiftVal       : unsigned(a'length-1 downto 0);    --value that the input needs to be shifted

    --    variable temp_result    : unsigned(a'length*2-1 downto 0);  --temporary result
    --    variable result         : unsigned(d_width-1 downto 0);     --final result
    --begin
    --    --Input is larger than maximum 
    --    if (a > max) then
    --        --Mirror input
    --        for i in 0 to a'length-1 loop
    --            temp_mirror(i) := a(i);
    --        end loop;

    --        --Compute amount of shifts for the value to line up correctly
    --        shiftVal := temp_mirror and not (temp_mirror - "1");

    --        --Shift input value by computed shift value
    --        temp_result := a * shiftVal;

    --        --Resize and set d_width amount of MSB to result
    --        result := resize(temp_result(a'length-1 downto a'length-d_width), d_width);
    --    else
    --        --Set d_width amount of input bits to result
    --        result := a(d_width-1 downto 0);
    --    end if;

    --    return result;
    --end compress;

    --function compress (
    --    a       : in signed;    --Value to be compressed
    --    d_width : in integer    --The size where the input value needs to be compressed to
    --) return signed is
    --    constant max_signed     : unsigned(d_width-2 downto 0) := (others => '1');  --minimal value for a negative valued input to be shifted
    --    constant max_unsigned   : unsigned(d_width-1 downto 0) := (others => '1');  --minimal value for a positive valued input to be shifted

    --    variable temp_a         : unsigned(a'length-1 downto 0);    --temporary input value
    --    variable temp_mirror    : unsigned(0 to a'length-1);        --mirrored temp value
    --    variable shiftVal       : unsigned(a'length-1 downto 0);    --value that the input needs to be shifted

    --    variable temp_result    : signed(a'length*2-1 downto 0);    --temporary result
    --    variable result         : signed(d_width-1 downto 0);       --final result
    --begin
    --    --Convert signed input to unsigned value
    --    temp_a := unsigned(a);

    --    --If signed make unsigned
    --    if (temp_a(a'left) = '1') then 
    --        temp_a := (not temp_a) + 1; 
    --    end if;

    --    if ((a(a'left) = '0' and temp_a > max_unsigned) or (a(a'left) = '1' and temp_a > max_signed)) then
    --        --Mirror temp
    --        for i in 0 to a'length-1 loop
    --            temp_mirror(i) := temp_a(i);
    --        end loop;

    --        --Compute amount of shifts for the value to line up correctly
    --        shiftVal := ((temp_mirror and not (temp_mirror - 1)) / 2);

    --        --Correct for zero value
    --        if (shiftVal < 1) then
    --            shiftVal := shiftVal + 1;
    --        end if;

    --        --Shift input value by computed shift value
    --        temp_result := a * signed(shiftVal);

    --        --Resize and set d_width amount of MSB to result
    --        result := resize(temp_result(a'length-1 downto a'length-d_width), d_width);
    --    --Input is signed
    --    elsif a(a'left) = '1' then
    --        --Set d_width amount of input bits to result
    --        result := a(d_width-1 downto 0);

    --    --Input is unsigned
    --    else
    --        --Set d_width amount of input bits minus sign position bit to result
    --        result := '0' & a(d_width-2 downto 0);
    --    end if;

    --    return result;
    --end compress;

    constant twoPI : sfixed(31 downto -32) := to_sfixed(6.283185, 31, -32);

    constant order : integer := 2;
    type matrix_A is array (0 to 2*order-1) of sfixed(31 downto -32);
    type matrix_B is array (0 to order-1) of sfixed(31 downto -32);

begin
    process(mclk, nrst)
        variable gain                   : sfixed(31 downto -32) := to_sfixed(2.0, 31, -32);
        variable unsigned_gain          : unsigned(param'length downto 0) := (param'length => '1', others => '0');  --make this 1 bit larger than param so it is never the same the first cycle!
        constant saturation_limit       : signed(d_width-1 downto 0) := (d_width-1 => '0', others => '1');
        constant fl_saturation_limit    : sfixed(31 downto -32) := to_sfixed(to_integer(unsigned(saturation_limit)), 31, -32);

        variable coef_A : matrix_A;
        variable coef_B : matrix_B;
        variable coef_C : matrix_B := (to_sfixed(0.0, 31, -32), to_sfixed(1.0, 31, -32)); --can use the same array size as B
        
        variable coef_A_pow      : matrix_A;
        variable coef_temp_A_pow : matrix_A;
        variable identity_matrix : matrix_A := (to_sfixed(1.0, 31, -32), to_sfixed(0.0, 31, -32), to_sfixed(0.0, 31, -32), to_sfixed(1.0, 31, -32));

        variable factorial          : sfixed(31 downto -32) := to_sfixed(1.0, 31, -32);
        variable sample_time        : sfixed(31 downto -32) := resize(to_sfixed(1.0, 31, -32)/to_sfixed(freq_sample, 31, -32), 31, -32);
        variable sample_time_pow    : sfixed(31 downto -32) := sample_time;

        variable fl_coef_Ad : matrix_A := identity_matrix;
        variable fl_coef_Bd : matrix_B := (resize(coef_B(0)*sample_time, 31, -32), resize(coef_B(1)*sample_time, 31, -32));

        variable state : matrix_B := (to_sfixed(0.0, 31, -32), to_sfixed(0.0, 31, -32));
        variable temp_state : matrix_B;

        variable finished : std_logic := '0';

        type t_lookup_gain is array (0 to 63) of sfixed(31 downto -32);
        variable lookup_gain : t_lookup_gain := (to_sfixed(0.050238, 31, -32), to_sfixed(0.056368, 31, -32), to_sfixed(0.063246, 31, -32), to_sfixed(0.070963, 31, -32), to_sfixed(0.079621, 31, -32), to_sfixed(0.089337, 31, -32), to_sfixed(0.100237, 31, -32), to_sfixed(0.112468, 31, -32), to_sfixed(0.126191, 31, -32), to_sfixed(0.141589, 31, -32), to_sfixed(0.158866, 31, -32), to_sfixed(0.178250, 31, -32), to_sfixed(0.200000, 31, -32), to_sfixed(0.224404, 31, -32), to_sfixed(0.251785, 31, -32), to_sfixed(0.282508, 31, -32), to_sfixed(0.316979, 31, -32), to_sfixed(0.355656, 31, -32), to_sfixed(0.399052, 31, -32), to_sfixed(0.447744, 31, -32), to_sfixed(0.502377, 31, -32), to_sfixed(0.563677, 31, -32), to_sfixed(0.632456, 31, -32), to_sfixed(0.709627, 31, -32), to_sfixed(0.796214, 31, -32), to_sfixed(0.893367, 31, -32), to_sfixed(1.002374, 31, -32), to_sfixed(1.124683, 31, -32), to_sfixed(1.261915, 31, -32), to_sfixed(1.415892, 31, -32), to_sfixed(1.588656, 31, -32), to_sfixed(1.782502, 31, -32), to_sfixed(2.000000, 31, -32), to_sfixed(2.244037, 31, -32), to_sfixed(2.517851, 31, -32), to_sfixed(2.825075, 31, -32), to_sfixed(3.169786, 31, -32), to_sfixed(3.556559, 31, -32), to_sfixed(3.990525, 31, -32), to_sfixed(4.477442, 31, -32), to_sfixed(5.023773, 31, -32), to_sfixed(5.636766, 31, -32), to_sfixed(6.324555, 31, -32), to_sfixed(7.096268, 31, -32), to_sfixed(7.962143, 31, -32), to_sfixed(8.933672, 31, -32), to_sfixed(10.023745, 31, -32), to_sfixed(11.246826, 31, -32), to_sfixed(12.619147, 31, -32), to_sfixed(14.158916, 31, -32), to_sfixed(15.886564, 31, -32), to_sfixed(17.825018, 31, -32), to_sfixed(20.000000, 31, -32), to_sfixed(22.440369, 31, -32), to_sfixed(25.178509, 31, -32), to_sfixed(28.250751, 31, -32), to_sfixed(31.697865, 31, -32), to_sfixed(35.565590, 31, -32), to_sfixed(39.905247, 31, -32), to_sfixed(44.774422, 31, -32), to_sfixed(50.237728, 31, -32), to_sfixed(56.367661, 31, -32), to_sfixed(63.245552, 31, -32), to_sfixed(70.962677, 31, -32));

    begin
        if nrst = '0' then
            --Compute new coefficients
            coef_A := (resize(-twoPI*to_sfixed(freq_res, 31, -32), 31, -32), to_sfixed(0.0, 31, -32), resize(-gain*twoPI*to_sfixed(freq_res, 31, -32), 31, -32), resize(-twoPI*to_sfixed(freq_res, 31, -32), 31, -32));
            coef_B := (resize(twoPI*to_sfixed(freq_res, 31, -32), 31, -32), resize(gain*twoPI*to_sfixed(freq_res, 31, -32), 31, -32));

            --Initialize discrete coefficient matrices
            factorial       := to_sfixed(1.0, 31, -32);
            sample_time     := resize(to_sfixed(1.0, 31, -32)/to_sfixed(freq_sample, 31, -32), 31, -32);
            sample_time_pow := sample_time;

            coef_A_pow      := coef_A;
            fl_coef_Ad      := identity_matrix;
            fl_coef_Bd      := (resize(coef_B(0)*sample_time, 31, -32), resize(coef_B(1)*sample_time, 31, -32));

            --reset state matrix
            for i in 0 to 1 loop
                state(i) := to_sfixed(0.0, 31, -32);
            end loop;

            --Compute AT + A^2*T^2/2 + ...
            compute_Ad_and_Bd_nrst : for i in 0 to 10 loop

                --Compute Resulting Ad and Bd
                for j in 0 to 1 loop
                    --Compute Bd
                    fl_coef_Bd(j) := resize(fl_coef_Bd(j) + (((coef_A_pow(j*2)*coef_B(0) + coef_A_pow(j*2+1)*coef_B(1))*sample_time_pow*sample_time)/(factorial * to_sfixed((i+2), 31, -32))), 31, -32);

                    for k in 0 to 1 loop
                        --Compute Ad
                        fl_coef_Ad(j*2+k) := resize(fl_coef_Ad(j*2+k) + ((coef_A_pow(j*2+k)*sample_time_pow)/factorial), 31, -32);
                    end loop;
                end loop;

                --Compute A to the power of n in temporary matrix 
                for j in 0 to 1 loop
                    for k in 0 to 1 loop
                        coef_temp_A_pow(j*2+k) := resize(coef_A_pow(j*2)*coef_A(k) + coef_A_pow(j*2+1)*coef_A(2+k), 31, -32);
                    end loop;
                end loop;

                --Copy temp to power of A matrix
                coef_A_pow := coef_temp_A_pow;

                --Compute T^n and n!
                sample_time_pow := resize(sample_time_pow*sample_time, 31, -32);
                factorial       := resize(factorial * to_sfixed((i+2), 31, -32), 31, -32);

            end loop compute_Ad_and_Bd_nrst;
        elsif rising_edge(mclk) then
            --Set output available low
            finished := '0';

            --if (unsigned_gain /= unsigned('0' & param)) then
            --    unsigned_gain := unsigned('0' & param);

            --    --Compute gain from dB input. Compensate the -6dB point at res_freq by multiplying by 2
            --    --gain := to_sfixed(2.0, 31, -32) * (to_sfixed(10.0, 31, -32) ** ((to_sfixed(to_integer(unsigned(param)), 31, -32) - to_sfixed(32.0, 31, -32)) / to_sfixed(20.0, 31, -32)));
            --    --gain := to_sfixed(2.0 * 10.0 ** ((real(to_integer(unsigned(param))) - 32.0) / 20.0), 31, -31);
            --    --gain := lookup_gain(to_integer(unsigned(param)));
            --    gain := to_sfixed(2.0, 31, -32);

            --    --Compute new coefficients
            --    coef_A := (resize(-twoPI*to_sfixed(freq_res, 31, -32), 31, -32), to_sfixed(0.0, 31, -32), resize(-gain*twoPI*to_sfixed(freq_res, 31, -32), 31, -32), resize(-twoPI*to_sfixed(freq_res, 31, -32), 31, -32));
            --    coef_B := (resize(twoPI*to_sfixed(freq_res, 31, -32), 31, -32), resize(gain*twoPI*to_sfixed(freq_res, 31, -32), 31, -32));

            --    --Initialize discrete coefficient matrices
            --    coef_A_pow      := coef_A;
            --    fl_coef_Ad      := identity_matrix;
            --    fl_coef_Bd      := (resize(coef_B(0)*sample_time, 31, -32), resize(coef_B(1)*sample_time, 31, -32));

            --    factorial       := to_sfixed(1.0, 31, -32);
            --    sample_time_pow := sample_time;

            --    --reset state matrix
            --    for i in 0 to 1 loop
            --        state(i) := to_sfixed(0.0, 31, -32);
            --    end loop;

            --    --Compute AT + A^2*T^2/2 + ...
            --    compute_Ad_and_Bd : for i in 0 to 10 loop

            --        --Compute Resulting Ad and Bd
            --        for j in 0 to 1 loop
            --            --Compute Bd
            --            fl_coef_Bd(j) := resize(fl_coef_Bd(j) + (((coef_A_pow(j*2)*coef_B(0) + coef_A_pow(j*2+1)*coef_B(1))*sample_time_pow*sample_time)/(factorial * to_sfixed((i+2), 31, -32))), 31, -32);

            --            for k in 0 to 1 loop
            --                --Compute Ad
            --                fl_coef_Ad(j*2+k) := resize(fl_coef_Ad(j*2+k) + ((coef_A_pow(j*2+k)*sample_time_pow)/factorial), 31, -32);
            --            end loop;
            --        end loop;

            --        --Compute A to the power of n in temporary matrix 
            --        for j in 0 to 1 loop
            --            for k in 0 to 1 loop
            --                coef_temp_A_pow(j*2+k) := resize(coef_A_pow(j*2)*coef_A(k) + coef_A_pow(j*2+1)*coef_A(2+k), 31, -32);
            --            end loop;
            --        end loop;

            --        --Copy temp to power of A matrix
            --        coef_A_pow := coef_temp_A_pow;

            --        --Compute T^n and n!
            --        sample_time_pow := resize(sample_time_pow*sample_time, 31, -32);
            --        factorial       := resize(factorial * to_sfixed((i+2), 31, -32), 31, -32);

            --    end loop compute_Ad_and_Bd;

            --sample is available and process is not currently active
            --elsif (i_avail = '1') then
            if (i_avail = '1') then
                for i in 0 to 1 loop
                    temp_state(i) := resize(resize(fl_coef_Ad(i*2)*state(0), 31, -32) + resize(fl_coef_Ad(i*2+1)*state(1), 31, -32) + resize(fl_coef_Bd(i)*to_sfixed(to_integer(signed(d_in)), 31, -32), 31, -32), 31, -32);
                end loop;
                
                for i in 0 to 1 loop
                    state(i) := temp_state(i);
                end loop;

                --Output is larger then integer maximum
                --if (to_signed(temp_state(1), 32) > saturation_limit) then
                --    --Clip at integer maximum
                --    d_out <= std_logic_vector(saturation_limit);
                ----Output is smaller then integer minimum
                --elsif (to_signed(temp_state(1), 32) < ((not saturation_limit) - "1")) then
                --    --Clip at integer minimum
                --    d_out <= std_logic_vector((not saturation_limit) - "1");
                ----Output within integer range
                --else 
                --    --Compress output correctly to fit d_out
                --    d_out <= std_logic_vector(compress(to_signed(temp_state(1), 32), d_width));
                --end if;

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
                    --d_out <= std_logic_vector(compress(to_signed(temp_state(1), 32), d_width));
                    d_out <= std_logic_vector(to_signed(temp_state(1), d_width));
                end if;
                
                --d_out <= d_in;

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