LIBRARY ieee;
USE ieee.std_logic_1164.all;


--  Entity Declaration

ENTITY toseg IS
	PORT(
		bcd : IN STD_LOGIC_VECTOR(3 downto 0);
		seg : OUT STD_LOGIC_VECTOR(6 downto 0)
	);
END toseg;


--  Architecture Body

ARCHITECTURE toseg_architecture OF toseg IS


BEGIN
	process (bcd)
	begin
		case  bcd is
			when "0000"=> seg <="1000000" after 5 ns;  -- '0'
			when "0001"=> seg <="1111001" after 5 ns;  -- '1'
			when "0010"=> seg <="0100100" after 5 ns;  -- '2'
			when "0011"=> seg <="0110000" after 5 ns;  -- '3'
			when "0100"=> seg <="0011001" after 5 ns;  -- '4'
			when "0101"=> seg <="0010010" after 5 ns;  -- '5'
			when "0110"=> seg <="0000010" after 5 ns;  -- '6'
			when "0111"=> seg <="1111000" after 5 ns;  -- '7'
			when "1000"=> seg <="0000000" after 5 ns;  -- '8'
			when "1001"=> seg <="0010000" after 5 ns;  -- '9'
			when "1010"=> seg <="0001000" after 5 ns;  -- 'a'
			when "1011"=> seg <="0000011" after 5 ns;  -- 'b'
			when "1100"=> seg <="1000110" after 5 ns;  -- 'c'
			when "1101"=> seg <="0100001" after 5 ns;  -- 'd'
			when "1110"=> seg <="0000110" after 5 ns;  -- 'e'
			when "1111"=> seg <="0001110" after 5 ns;  -- 'f'
			when others=> seg <="1111111" after 5 ns; 
		end case;
	end process;
END toseg_architecture;