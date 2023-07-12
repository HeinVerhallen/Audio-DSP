library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity encoder is
    port(
        number  : IN std_logic_vector(3 downto 0);
        led     : OUT std_logic
    );
end entity;

architecture rtl of encoder is
    procedure checkled (temp : in std_logic_vector(3 downto 0); output : out std_logic) IS
    begin
        if temp >= "1000" then
            output := '1';
        else
            output := '0';
        end if;
    end procedure checkled;
begin
    main : process( number )
	 
	 variable test : std_logic;
	 
    begin
		  checkled(number, test);
		  led <= test;
    end process ; -- main
end architecture rtl;