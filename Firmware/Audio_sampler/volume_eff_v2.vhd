library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.fixed_pkg.all;
use IEEE.math_real.all;

entity volume_eff_v2 is
    GENERIC(
        d_width     : integer := 24);         --data width of input and output
    Port ( 
        d_in    : in  std_logic_vector(d_width-1 downto 0); --input data
        param   : in  std_logic_vector(6 downto 0);         --gain parameter
        d_out   : out std_logic_vector(d_width-1 downto 0) --output data
        ); 
end volume_eff_v2;

architecture Behavioral of volume_eff_v2 is
    signal gain : sfixed(31 downto -32) := to_sfixed(2.0, 31, -32);

begin
    process(d_in)
    begin
        d_out <= std_logic_vector(to_signed(resize(to_sfixed(signed(d_in), 31, -32) * gain, 31, -32), d_width));
    end process;

    process(param)
        type t_lookup_gain is array (0 to 127) of sfixed(31 downto -32);
        --Lookup gain ranging from -87dB to 40dB
        constant lookup_gain : t_lookup_gain := (to_sfixed(0.000045, 31, -32), to_sfixed(0.000050, 31, -32), to_sfixed(0.000056, 31, -32), to_sfixed(0.000063, 31, -32), to_sfixed(0.000071, 31, -32), to_sfixed(0.000079, 31, -32), to_sfixed(0.000089, 31, -32), to_sfixed(0.000100, 31, -32), to_sfixed(0.000112, 31, -32), to_sfixed(0.000126, 31, -32), to_sfixed(0.000141, 31, -32), to_sfixed(0.000158, 31, -32), to_sfixed(0.000178, 31, -32), to_sfixed(0.000200, 31, -32), to_sfixed(0.000224, 31, -32), to_sfixed(0.000251, 31, -32), to_sfixed(0.000282, 31, -32), to_sfixed(0.000316, 31, -32), to_sfixed(0.000355, 31, -32), to_sfixed(0.000398, 31, -32), to_sfixed(0.000447, 31, -32), to_sfixed(0.000501, 31, -32), to_sfixed(0.000562, 31, -32), to_sfixed(0.000631, 31, -32), to_sfixed(0.000708, 31, -32), to_sfixed(0.000794, 31, -32), to_sfixed(0.000891, 31, -32), to_sfixed(0.001000, 31, -32), to_sfixed(0.001122, 31, -32), to_sfixed(0.001259, 31, -32), to_sfixed(0.001413, 31, -32), to_sfixed(0.001585, 31, -32), to_sfixed(0.001778, 31, -32), to_sfixed(0.001995, 31, -32), to_sfixed(0.002239, 31, -32), to_sfixed(0.002512, 31, -32), to_sfixed(0.002818, 31, -32), to_sfixed(0.003162, 31, -32), to_sfixed(0.003548, 31, -32), to_sfixed(0.003981, 31, -32), to_sfixed(0.004467, 31, -32), to_sfixed(0.005012, 31, -32), to_sfixed(0.005623, 31, -32), to_sfixed(0.006310, 31, -32), to_sfixed(0.007079, 31, -32), to_sfixed(0.007943, 31, -32), to_sfixed(0.008913, 31, -32), to_sfixed(0.010000, 31, -32), to_sfixed(0.011220, 31, -32), to_sfixed(0.012589, 31, -32), to_sfixed(0.014125, 31, -32), to_sfixed(0.015849, 31, -32), to_sfixed(0.017783, 31, -32), to_sfixed(0.019953, 31, -32), to_sfixed(0.022387, 31, -32), to_sfixed(0.025119, 31, -32), to_sfixed(0.028184, 31, -32), to_sfixed(0.031623, 31, -32), to_sfixed(0.035481, 31, -32), to_sfixed(0.039811, 31, -32), to_sfixed(0.044668, 31, -32), to_sfixed(0.050119, 31, -32), to_sfixed(0.056234, 31, -32), to_sfixed(0.063096, 31, -32), to_sfixed(0.070795, 31, -32), to_sfixed(0.079433, 31, -32), to_sfixed(0.089125, 31, -32), to_sfixed(0.100000, 31, -32), to_sfixed(0.112202, 31, -32), to_sfixed(0.125893, 31, -32), to_sfixed(0.141254, 31, -32), to_sfixed(0.158489, 31, -32), to_sfixed(0.177828, 31, -32), to_sfixed(0.199526, 31, -32), to_sfixed(0.223872, 31, -32), to_sfixed(0.251189, 31, -32), to_sfixed(0.281838, 31, -32), to_sfixed(0.316228, 31, -32), to_sfixed(0.354813, 31, -32), to_sfixed(0.398107, 31, -32), to_sfixed(0.446684, 31, -32), to_sfixed(0.501187, 31, -32), to_sfixed(0.562341, 31, -32), to_sfixed(0.630957, 31, -32), to_sfixed(0.707946, 31, -32), to_sfixed(0.794328, 31, -32), to_sfixed(0.891251, 31, -32), to_sfixed(1.000000, 31, -32), to_sfixed(1.122018, 31, -32), to_sfixed(1.258925, 31, -32), to_sfixed(1.412538, 31, -32), to_sfixed(1.584893, 31, -32), to_sfixed(1.778279, 31, -32), to_sfixed(1.995262, 31, -32), to_sfixed(2.238721, 31, -32), to_sfixed(2.511886, 31, -32), to_sfixed(2.818383, 31, -32), to_sfixed(3.162278, 31, -32), to_sfixed(3.548134, 31, -32), to_sfixed(3.981072, 31, -32), to_sfixed(4.466836, 31, -32), to_sfixed(5.011872, 31, -32), to_sfixed(5.623413, 31, -32), to_sfixed(6.309574, 31, -32), to_sfixed(7.079458, 31, -32), to_sfixed(7.943282, 31, -32), to_sfixed(8.912509, 31, -32), to_sfixed(10.000000, 31, -32), to_sfixed(11.220184, 31, -32), to_sfixed(12.589254, 31, -32), to_sfixed(14.125376, 31, -32), to_sfixed(15.848932, 31, -32), to_sfixed(17.782795, 31, -32), to_sfixed(19.952623, 31, -32), to_sfixed(22.387211, 31, -32), to_sfixed(25.118864, 31, -32), to_sfixed(28.183830, 31, -32), to_sfixed(31.622776, 31, -32), to_sfixed(35.481339, 31, -32), to_sfixed(39.810719, 31, -32), to_sfixed(44.668358, 31, -32), to_sfixed(50.118725, 31, -32), to_sfixed(56.234131, 31, -32), to_sfixed(63.095734, 31, -32), to_sfixed(70.794579, 31, -32), to_sfixed(79.432823, 31, -32), to_sfixed(89.125092, 31, -32), to_sfixed(100.000000, 31, -32));
    begin
        gain <= lookup_gain(to_integer(unsigned(param)));
    end process;
end Behavioral;