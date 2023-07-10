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
        param   : in  std_logic_vector(5 downto 0);         --gain parameter
        d_out   : out std_logic_vector(d_width-1 downto 0) --output data
        ); 
end volume_eff_v2;

architecture Behavioral of volume_eff_v2 is
    signal gain : sfixed(31 downto -32) := to_sfixed(2.0, 31, -32);

begin
    process(d_in)
        --type t_lookup_gain is array (0 to 63) of sfixed(31 downto -32);
        --variable lookup_gain : t_lookup_gain := (to_sfixed(0.050238, 31, -32), to_sfixed(0.056368, 31, -32), to_sfixed(0.063246, 31, -32), to_sfixed(0.070963, 31, -32), to_sfixed(0.079621, 31, -32), to_sfixed(0.089337, 31, -32), to_sfixed(0.100237, 31, -32), to_sfixed(0.112468, 31, -32), to_sfixed(0.126191, 31, -32), to_sfixed(0.141589, 31, -32), to_sfixed(0.158866, 31, -32), to_sfixed(0.178250, 31, -32), to_sfixed(0.200000, 31, -32), to_sfixed(0.224404, 31, -32), to_sfixed(0.251785, 31, -32), to_sfixed(0.282508, 31, -32), to_sfixed(0.316979, 31, -32), to_sfixed(0.355656, 31, -32), to_sfixed(0.399052, 31, -32), to_sfixed(0.447744, 31, -32), to_sfixed(0.502377, 31, -32), to_sfixed(0.563677, 31, -32), to_sfixed(0.632456, 31, -32), to_sfixed(0.709627, 31, -32), to_sfixed(0.796214, 31, -32), to_sfixed(0.893367, 31, -32), to_sfixed(1.002374, 31, -32), to_sfixed(1.124683, 31, -32), to_sfixed(1.261915, 31, -32), to_sfixed(1.415892, 31, -32), to_sfixed(1.588656, 31, -32), to_sfixed(1.782502, 31, -32), to_sfixed(2.000000, 31, -32), to_sfixed(2.244037, 31, -32), to_sfixed(2.517851, 31, -32), to_sfixed(2.825075, 31, -32), to_sfixed(3.169786, 31, -32), to_sfixed(3.556559, 31, -32), to_sfixed(3.990525, 31, -32), to_sfixed(4.477442, 31, -32), to_sfixed(5.023773, 31, -32), to_sfixed(5.636766, 31, -32), to_sfixed(6.324555, 31, -32), to_sfixed(7.096268, 31, -32), to_sfixed(7.962143, 31, -32), to_sfixed(8.933672, 31, -32), to_sfixed(10.023745, 31, -32), to_sfixed(11.246826, 31, -32), to_sfixed(12.619147, 31, -32), to_sfixed(14.158916, 31, -32), to_sfixed(15.886564, 31, -32), to_sfixed(17.825018, 31, -32), to_sfixed(20.000000, 31, -32), to_sfixed(22.440369, 31, -32), to_sfixed(25.178509, 31, -32), to_sfixed(28.250751, 31, -32), to_sfixed(31.697865, 31, -32), to_sfixed(35.565590, 31, -32), to_sfixed(39.905247, 31, -32), to_sfixed(44.774422, 31, -32), to_sfixed(50.237728, 31, -32), to_sfixed(56.367661, 31, -32), to_sfixed(63.245552, 31, -32), to_sfixed(70.962677, 31, -32));
        
        --variable gain       : sfixed(31 downto -32) := to_sfixed(0.1, 31, -32);
        --variable temp_out   : sfixed(31 downto -32);
    begin
        --gain := lookup_gain(to_integer(unsigned(param)));

        --temp_out := resize(to_sfixed(signed(d_in), 31, -32) * gain, 31, -32);

        ----d_out <= std_logic_vector(to_signed(temp_out, d_width));
        --d_out <= to_slv(resize(temp_out, d_width-1, 0));

        d_out <= std_logic_vector(to_signed(resize(to_sfixed(signed(d_in), 31, -32) * gain, 31, -32), d_width));
    end process;

    process(param)
        type t_lookup_gain is array (0 to 63) of sfixed(31 downto -32);
        --constant lookup_gain : t_lookup_gain := (to_sfixed(0.050, 31, -32), to_sfixed(0.056, 31, -32), to_sfixed(0.063, 31, -32), to_sfixed(0.070, 31, -32), to_sfixed(0.079, 31, -32), to_sfixed(0.089, 31, -32), to_sfixed(0.100, 31, -32), to_sfixed(0.112, 31, -32), to_sfixed(0.126, 31, -32), to_sfixed(0.141, 31, -32), to_sfixed(0.158, 31, -32), to_sfixed(0.178, 31, -32), to_sfixed(0.200, 31, -32), to_sfixed(0.224, 31, -32), to_sfixed(0.251, 31, -32), to_sfixed(0.282, 31, -32), to_sfixed(0.316, 31, -32), to_sfixed(0.355, 31, -32), to_sfixed(0.399, 31, -32), to_sfixed(0.447, 31, -32), to_sfixed(0.502, 31, -32), to_sfixed(0.563, 31, -32), to_sfixed(0.632, 31, -32), to_sfixed(0.709, 31, -32), to_sfixed(0.796, 31, -32), to_sfixed(0.893, 31, -32), to_sfixed(1.002, 31, -32), to_sfixed(1.124, 31, -32), to_sfixed(1.261, 31, -32), to_sfixed(1.415, 31, -32), to_sfixed(1.588, 31, -32), to_sfixed(1.782, 31, -32), to_sfixed(2.000, 31, -32), to_sfixed(2.244, 31, -32), to_sfixed(2.517, 31, -32), to_sfixed(2.825, 31, -32), to_sfixed(3.169, 31, -32), to_sfixed(3.556, 31, -32), to_sfixed(3.990, 31, -32), to_sfixed(4.477, 31, -32), to_sfixed(5.023, 31, -32), to_sfixed(5.636, 31, -32), to_sfixed(6.324, 31, -32), to_sfixed(7.096, 31, -32), to_sfixed(7.962, 31, -32), to_sfixed(8.933, 31, -32), to_sfixed(10.023, 31, -32), to_sfixed(11.246, 31, -32), to_sfixed(12.619, 31, -32), to_sfixed(14.158, 31, -32), to_sfixed(15.886, 31, -32), to_sfixed(17.825, 31, -32), to_sfixed(20.000, 31, -32), to_sfixed(22.440, 31, -32), to_sfixed(25.178, 31, -32), to_sfixed(28.250, 31, -32), to_sfixed(31.697, 31, -32), to_sfixed(35.565, 31, -32), to_sfixed(39.905, 31, -32), to_sfixed(44.774, 31, -32), to_sfixed(50.237, 31, -32), to_sfixed(56.367, 31, -32), to_sfixed(63.245, 31, -32), to_sfixed(70.962, 31, -32));
        constant lookup_gain : t_lookup_gain := (to_sfixed(0.050238, 31, -32), to_sfixed(0.056368, 31, -32), to_sfixed(0.063246, 31, -32), to_sfixed(0.070963, 31, -32), to_sfixed(0.079621, 31, -32), to_sfixed(0.089337, 31, -32), to_sfixed(0.100237, 31, -32), to_sfixed(0.112468, 31, -32), to_sfixed(0.126191, 31, -32), to_sfixed(0.141589, 31, -32), to_sfixed(0.158866, 31, -32), to_sfixed(0.178250, 31, -32), to_sfixed(0.200000, 31, -32), to_sfixed(0.224404, 31, -32), to_sfixed(0.251785, 31, -32), to_sfixed(0.282508, 31, -32), to_sfixed(0.316979, 31, -32), to_sfixed(0.355656, 31, -32), to_sfixed(0.399052, 31, -32), to_sfixed(0.447744, 31, -32), to_sfixed(0.502377, 31, -32), to_sfixed(0.563677, 31, -32), to_sfixed(0.632456, 31, -32), to_sfixed(0.709627, 31, -32), to_sfixed(0.796214, 31, -32), to_sfixed(0.893367, 31, -32), to_sfixed(1.002374, 31, -32), to_sfixed(1.124683, 31, -32), to_sfixed(1.261915, 31, -32), to_sfixed(1.415892, 31, -32), to_sfixed(1.588656, 31, -32), to_sfixed(1.782502, 31, -32), to_sfixed(2.000000, 31, -32), to_sfixed(2.244037, 31, -32), to_sfixed(2.517851, 31, -32), to_sfixed(2.825075, 31, -32), to_sfixed(3.169786, 31, -32), to_sfixed(3.556559, 31, -32), to_sfixed(3.990525, 31, -32), to_sfixed(4.477442, 31, -32), to_sfixed(5.023773, 31, -32), to_sfixed(5.636766, 31, -32), to_sfixed(6.324555, 31, -32), to_sfixed(7.096268, 31, -32), to_sfixed(7.962143, 31, -32), to_sfixed(8.933672, 31, -32), to_sfixed(10.023745, 31, -32), to_sfixed(11.246826, 31, -32), to_sfixed(12.619147, 31, -32), to_sfixed(14.158916, 31, -32), to_sfixed(15.886564, 31, -32), to_sfixed(17.825018, 31, -32), to_sfixed(20.000000, 31, -32), to_sfixed(22.440369, 31, -32), to_sfixed(25.178509, 31, -32), to_sfixed(28.250751, 31, -32), to_sfixed(31.697865, 31, -32), to_sfixed(35.565590, 31, -32), to_sfixed(39.905247, 31, -32), to_sfixed(44.774422, 31, -32), to_sfixed(50.237728, 31, -32), to_sfixed(56.367661, 31, -32), to_sfixed(63.245552, 31, -32), to_sfixed(70.962677, 31, -32));
        
    begin
        gain <= lookup_gain(to_integer(unsigned(param)));
    end process;
end Behavioral;