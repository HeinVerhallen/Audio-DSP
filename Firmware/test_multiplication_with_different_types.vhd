library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplication_with_different_types is
    GENERIC(
        d_width : integer := 8);
    Port ( 
        a       : in  std_logic_vector(d_width-1 downto 0); 
        b       : in  std_logic_vector(d_width-1 downto 0);                          
        c       : out std_logic_vector(d_width*2-1 downto 0);
        d       : in  unsigned(d_width-1 downto 0); 
        e       : in  unsigned(d_width-1 downto 0);                          
        f       : out unsigned(d_width*2-1 downto 0)
        ); 
end multiplication_with_different_types;

architecture Behavioral of multiplication_with_different_types is
    signal realVal1 : real := -11.0;
    signal realVal2 : real := 11.0;

    signal unsignedVal1 : unsigned(d_width-1 downto 0);
    signal unsignedVal2 : unsigned(d_width-1 downto 0);
    signal signedVal1   : signed(d_width-1 downto 0);
    signal signedVal2   : signed(d_width-1 downto 0);

    signal unsigned_to_signed1 : signed(d_width-1 downto 0);
    signal signed_to_unsigned1 : unsigned(d_width-1 downto 0);
    signal unsigned_to_signed2 : signed(d_width-1 downto 0);
    signal signed_to_unsigned2 : unsigned(d_width-1 downto 0);

    signal mult_signed1 : signed(d_width*2-1 downto 0);
    signal mult_signed2 : signed(d_width*2-1 downto 0);
    signal mult_unsigned1 : unsigned(d_width*2-1 downto 0);
    signal mult_unsigned2 : unsigned(d_width*2-1 downto 0);

begin
    process(a, b, d, e)
    begin
        unsignedVal1 <= to_unsigned(integer(realVal1), d_width);
        unsignedVal2 <= to_unsigned(integer(realVal2), d_width);
        signedVal1 <= to_signed(integer(realVal1), d_width);
        signedVal2 <= to_signed(integer(realVal2), d_width);

        --Converted binary numbers stay the same. Doesnt matter if you convert it to signed or unsigned vica versa.
        unsigned_to_signed1 <= signed(unsignedVal1);
        signed_to_unsigned1 <= unsigned(signedVal1);
        unsigned_to_signed2 <= signed(unsignedVal2);
        signed_to_unsigned2 <= unsigned(signedVal2);

        --Signed and unsigned only make a difference when multiplying or dividing.
        mult_signed1 <= signed(unsignedVal1)*signedVal1;
        mult_signed2 <= signed(unsignedVal2)*signedVal2;
        mult_unsigned1 <= unsignedVal1*unsigned(signedVal1);
        mult_unsigned2 <= unsignedVal2*unsigned(signedVal2);
    end process;
end Behavioral;

