library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier_rounder is
    GENERIC(
        d_width : integer := 8);
    Port ( 
        a               : in  std_logic_vector(d_width-1 downto 0); 
        b               : in  std_logic_vector(d_width-1 downto 0);                          
        unsigned_output : out std_logic_vector(d_width-1 downto 0);
        signed_output   : out std_logic_vector(d_width-1 downto 0)
        ); 
end multiplier_rounder;

architecture Behavioral of multiplier_rounder is
    function multiply (
        a : in signed;
        b : in signed
    ) return signed is
        variable result         : signed(a'length*4-1 downto 0);
        variable temp_a         : unsigned(a'length-1 downto 0);
        variable temp_b         : unsigned(b'length-1 downto 0);
        variable temp           : unsigned(a'length*2-1 downto 0);
        variable temp_mirror    : unsigned(0 to a'length*2-1);
        variable max            : unsigned(a'length-1 downto 0) := (others => '1');
        --variable shifter        : unsigned(a'length*2-1 downto 0);
        --variable invert         : unsigned(a'length*2-1 downto 0);
        --variable andGate        : unsigned(a'length*2-1 downto 0);
    begin
        temp_a := unsigned(a);
        temp_b := unsigned(b);

        --report "temp_a: " & integer'image(to_integer(temp_a));
        --report "temp_b: " & integer'image(to_integer(temp_b));

        if (temp_a(a'left) = '1') then  --if signed
            temp_a := (not temp_a) + "1";   --make unsigned
        end if;

        if (temp_b(b'left) = '1') then  --if signed
            temp_b := (not temp_b) + "1";   --make unsigned
        end if;

        --report "temp_a: " & integer'image(to_integer(temp_a));
        --report "temp_b: " & integer'image(to_integer(temp_b));

        temp := temp_a * temp_b;
        --report "temp: " & integer'image(to_integer(temp));

        for i in 0 to a'length*2-1 loop
            temp_mirror(i) := temp(i);
        end loop;

        --report "temp_mirror: " & integer'image(to_integer(temp_mirror));

        --report "lsb of a: " & boolean'image(a(a'left)='1');

        if (a(a'left) = '1' xor b(b'left) = '1') then   --if result is negative
            --report "was true";
            temp := (not temp) + "1";           --make signed
        end if;

        --report "temp: " & integer'image(to_integer(temp));

        --invert := not (unsigned(temp_mirror) - "1");
        --report "invert: " & integer'image(to_integer(invert));
        --andGate := unsigned(temp_mirror) and invert;
        --report "andGate: " & integer'image(to_integer(andGate));
        --shifter := (unsigned(temp_mirror) and (not (unsigned(temp_mirror) - "1"))) / 2;

        --report "shifter: " & integer'image(to_integer(shifter));

        --result := signed(temp * shifter);
        if ((temp(temp'left) = '0' and temp > max) or (temp(temp'left) = '1' and (not temp > max))) then
            report "Is larger!";
            result := signed(temp * ((temp_mirror and not (temp_mirror - "1")) / 2));
        else
            report "Is smaller!";
            result(a'length*3-1 downto a'length) := signed(temp);
            --result := ZERO(a'length-1 downto 0) & temp & ZERO(a'length-1 downto 0);
        end if;

        report "result: " & integer'image(to_integer(result(a'length*2-1 downto a'length)));
        report "result signed: " & integer'image(to_integer(result(a'length*2-1 downto a'length)));

        return result(a'length*2-1 downto a'length);
    end multiply;

    function multiply (
        a : in unsigned;
        b : in unsigned
    ) return unsigned is
        variable result         : unsigned(a'length*4-1 downto 0);
        variable temp           : unsigned(a'length*2-1 downto 0);
        variable temp_mirror    : unsigned(0 to a'length*2-1);
        variable max            : unsigned(a'length-1 downto 0) := (others => '1');
    begin
        temp := a * b;
        report "temp: " & integer'image(to_integer(temp));

        for i in 0 to a'length*2-1 loop
            temp_mirror(i) := temp(i);
        end loop;

        if (temp > max) then
            report "Is larger!";
            result := temp * (temp_mirror and not (temp_mirror - "1"));
        else
            report "Is smaller!";
            result(a'length*3-1 downto a'length) := temp;
            --result := ZERO(a'length-1 downto 0) & temp & ZERO(a'length-1 downto 0);
        end if;
        
        report "result: " & integer'image(to_integer(result(a'length*2-1 downto a'length)));

        return result(a'length*2-1 downto a'length);
    end multiply;

    function multiply (
        a : in std_logic_vector;
        b : in std_logic_vector
    ) return std_logic_vector is
        variable result         : std_logic_vector(a'length*4-1 downto 0);
        variable temp           : unsigned(a'length*2-1 downto 0);
        variable temp_mirror    : unsigned(0 to a'length*2-1);
        variable max            : unsigned(a'length-1 downto 0) := (others => '1');
    begin
        temp := unsigned(a) * unsigned(b);

        for i in 0 to a'length*2-1 loop
            temp_mirror(i) := temp(i);
        end loop;

        if (temp > max) then
            report "Is larger!!!";
            result := std_logic_vector(temp * (temp_mirror and not (temp_mirror - "1")));
        else
            report "Is smaller!!!";
            result(a'length*3-1 downto a'length) := std_logic_vector(temp);
            --result := ZERO(a'length-1 downto 0) & temp & ZERO(a'length-1 downto 0);
        end if;

        return result(a'length*2-1 downto a'length);
    end multiply;

    --signal c : unsigned(d_width-1 downto 0);-- := multiply("1010","0101"); -- dit werkt!
    --signal p : signed(d_width-1 downto 0) := to_signed(-1, d_width);
    --signal q : signed(d_width-1 downto 0) := to_signed(13, d_width);
    --signal s : signed(d_width-1 downto 0);

begin
    process(a, b)
    begin
        --c       <= multiply(unsigned(a),unsigned(b));
        unsigned_output  <= multiply(a,b);
        --s <= multiply(p,q);
        signed_output <= std_logic_vector(multiply(signed(a), signed(b)));

        --report "p: " & integer'image(to_integer(p));
    end process;
end Behavioral;

