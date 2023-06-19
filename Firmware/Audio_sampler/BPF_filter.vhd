library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.fixed_pkg.all;
use IEEE.math_real.all;

entity BPF_filter is
    GENERIC(
        d_width     : integer := 24;
        freq_sample : integer := 192000;
        freq_res    : integer := 400;                         --resonance frequency
        gain        : integer := 1);
    Port ( 
        d_in    : in  std_logic_vector(d_width-1 downto 0); --input data
        nrst    : in  std_logic;                            --active-low reset
--        sys_clk : in  std_logic;                            --system clock
        ready   : in  std_logic;                            --input data valid check
        d_out   : out std_logic_vector(d_width-1 downto 0) --output data
--        valid   : out std_logic                             --output data valid check
        ); 
end BPF_filter;

architecture Behavioral of BPF_filter is
    constant twoPI : real := 6.283185;

    constant order : integer := 2;
    type matrix_A is array (0 to 2*order-1) of real;
    type matrix_B is array (0 to order-1) of real;

    type matrix_Ad is array (0 to 2*order-1) of signed(31 downto 0);
    type matrix_Bd is array (0 to order-1) of signed(31 downto 0);

    type m_temp_state is array (0 to order-1) of signed(63 downto 0);

    signal state : matrix_Bd := (to_signed(0, 32), to_signed(0, 32));
    signal output : unsigned(63 downto 0);

    --signal test_output  : unsigned(31 downto 0);
    signal test_output  : integer;
    signal test_real    : real := -20480.5364;

    function compress (
        a       : in unsigned;
        d_width : in integer
    ) return unsigned is
        variable result         : unsigned(a'length-1 downto 0);
        variable temp_mirror    : unsigned(0 to a'length-1);
        variable max            : unsigned(d_width-1 downto 0) := (others => '1');
    begin
        if (a > max) then
            report "Is larger!";

            for i in 0 to a'length-1 loop
                temp_mirror(i) := a(i);
            end loop;

            result := resize(a * (temp_mirror and not (temp_mirror - "1")), a'length);
            report "result: " & integer'image(to_integer(result));
        else
            report "Is smaller!";
            result(a'length-1 downto a'length-d_width) := a(d_width-1 downto 0);
        end if;

        return result(a'length-1 downto a'length-d_width);
    end compress;

begin
    process(ready, nrst)                       
        variable coef_A : matrix_A := (-twoPI*real(freq_res), 0.0, -real(gain)*twoPI*real(freq_res), -twoPI*real(freq_res));
        variable coef_B : matrix_B := (twoPI*real(freq_res), real(gain)*twoPI*real(freq_res));
        variable coef_C : matrix_B := (0.0, 1.0); --can use the same array size as B
        
        variable coef_A_pow      : matrix_A;
        variable coef_temp_A_pow : matrix_A;
        variable identity_matrix : matrix_A := (1.0, 0.0, 0.0, 1.0);

        variable factorial          : real := 1.0;
        variable sample_time        : real := 1.0/real(freq_sample);
        variable sample_time_pow    : real := sample_time;

        variable fl_coef_Ad : matrix_A := identity_matrix;
        variable fl_coef_Bd : matrix_B := (coef_B(0)*sample_time, coef_B(0)*sample_time);

        variable coef_Ad    : matrix_Ad;
        variable coef_Bd    : matrix_Bd;

        variable temp_state : m_temp_state;
        variable temp_input : unsigned(7 downto 0) := "00011101";
        
    begin
        --Initialize discrete coefficient matrices
        coef_A_pow  := coef_A;
        fl_coef_Ad     := identity_matrix;
        fl_coef_Bd     := (coef_B(0)*sample_time, coef_B(0)*sample_time);

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

        --Convert float coefficients to fixed point
        for j in 0 to 1 loop
            fl_coef_Bd(j)   := fl_coef_Bd(j)*131072.0;
            fl_coef_Bd(j)   := fl_coef_Bd(j) / 2.0 + (fl_coef_Bd(j) - ((fl_coef_Bd(j)/2.0) * 2.0));
            coef_Bd(j)      := to_signed(integer(fl_coef_Bd(j)), 32);
            --coef_Bd(j) := to_signed(integer(fl_coef_Bd(j)*131072.0), 32);
            --coef_Bd(j) := coef_Bd(j)/"10" + coef_Bd(j)(0);
            for k in 0 to 1 loop 
                fl_coef_Ad(j)   := fl_coef_Ad(j)*131072.0;
                fl_coef_Ad(j)   := fl_coef_Ad(j) / 2.0 + (fl_coef_Ad(j) - ((fl_coef_Ad(j)/2.0) * 2.0));
                coef_Ad(j)      := to_signed(integer(fl_coef_Ad(j)), 32);
                --coef_Ad(j*2+k) := to_signed(integer(fl_coef_Ad(j*2+k)*131072.0), 32);
                --coef_Ad(j*2+k) := coef_Ad(j*2+k)/"10" + coef_Ad(j*2+k)(0);
            end loop;
        end loop;

        --temp_state(0) := coef_Ad(0)*state(0) + coef_Ad(1)*state(1) + coef_Bd(0)*d_in;
        --temp_state(1) := coef_Ad(2)*state(0) + coef_Ad(3)*state(1) + coef_Bd(1)*d_in;

        for i in 0 to 1 loop
            temp_state(i) := coef_Ad(i*2)*state(0) + coef_Ad(i*2+1)*state(1) ;--+ coef_Bd(i)*signed(d_in);
            temp_state(i) := temp_state(i) / 32768;
            --temp_state(i) := temp_state(i)/2 + (temp_state(i) - ((temp_state(i)/2) * 2));-- temp_state(i)(0);
            state(i) <= signed(compress(unsigned(temp_state(i)), 32));
        end loop;

        --output <= std_logic_vector(compress(unsigned(temp_state(1)), d_width));
        --output <= to_unsigned(natural(temp_state(1)), 64);
        --output <= to_unsigned(natural(test_real), 64);

        --test_output <= signed(to_sfixed(test_real,15,-16)) after 5 ns;
        --test_output <= to_unsigned(integer(test_real*65536.0), 32) after 5 ns;          --Hier gebleven!
        --test_output <= integer(test_real*65536.0) after 5 ns;

        report "input: " & integer'image(to_integer(unsigned(d_in)));
        report "Compressed input: " & integer'image(to_integer(compress(unsigned(d_in), 4)));

        --float a = -16.1746;
    
        --int64_t c = a * (1<<16);
        
        --int32_t input = 2048;
        
        --int64_t tempOut = c*input;
        --int output = tempOut / (1<<15);
        --output = output/2 + output%2;
        
        --printf("a: %f\nc: %ld\ntemp: %ld\nout: %d\n", a, c, tempOut, output);
            
    end process;
end Behavioral;