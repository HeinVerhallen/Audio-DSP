library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier_rounder is
    GENERIC(
        d_width : integer := 4);
    Port ( 
        a       : in  std_logic_vector(d_width-1 downto 0); 
        b       : in  std_logic_vector(d_width downto 0);                          
        output  : out std_logic_vector(d_width-1 downto 0)
        ); 
end multiplier_rounder;

architecture Behavioral of multiplier_rounder is
    function multiply (
        a : in unsigned;
        b : in unsigned
    ) return unsigned is
        variable result         : unsigned(a'length*4-1 downto 0);
        variable temp           : unsigned(a'length*2-1 downto 0);
        variable temp_mirror    : unsigned(0 to a'length*2-1);
    begin
        temp := a * b;

        for i in 0 to a'length*2-1 loop
            temp_mirror(i) := temp(i);
        end loop;

        result := temp * (temp_mirror and not (temp_mirror - "1"));

        return result(a'length*2-1 downto a'length);
    end multiply;

    function multiply (
        a : in std_logic_vector;
        b : in std_logic_vector
    ) return std_logic_vector is
        variable result         : std_logic_vector((a'length + b'length)*2-1 downto 0);
        variable temp           : unsigned((a'length+b'length)-1 downto 0);
        variable temp_mirror    : unsigned(0 to (a'length+b'length)-1);
    begin
        temp := unsigned(a) * unsigned(b);

        for i in 0 to (a'length+b'length)-1 loop
            temp_mirror(i) := temp(i);
        end loop;

        result := std_logic_vector(temp * (temp_mirror and not (temp_mirror - "1")));

        return result((a'length+b'length)-1 downto a'length);
    end multiply;
    
begin
    process(a, b)
    begin
        output <= multiply(a,b);
    end process;
end Behavioral;

