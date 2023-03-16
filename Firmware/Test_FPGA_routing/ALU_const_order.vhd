LIBRARY ieee;
USE ieee.std_logic_1164.all;

use ieee.std_logic_signed.all;

--  Entity Declaration
ENTITY ALU IS
	PORT
	(
		Input : IN STD_LOGIC_VECTOR(3 downto 0);
		En : IN STD_LOGIC_VECTOR(3 downto 0);
		Clk : IN STD_LOGIC;
		Output : OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END ALU;


--  Architecture Body
ARCHITECTURE arch OF ALU IS
	signal state : STD_LOGIC_VECTOR(1 downto 0);

BEGIN
	process (Clk)
		variable temp : STD_LOGIC_VECTOR(3 downto 0);

	begin
		if rising_edge(Clk) then
			case state is
				when "00" =>	-- add 2
					temp := Input + "10";
				when "01" =>    -- mult by 2
					temp := temp(2 downto 0) & '0';
				when "10" =>	-- sub 2
					temp := temp - "10";
				when "11" => 	-- div by 2
					temp := '0' & temp(3 downto 1);
					Output <= temp after 1 ns;
					temp := "0000";
					state <= "00";
				when others =>
					temp := "0000";
					state <= "00";
			end case;

			state <= state + "01";
		end if;
	end process;
END arch;