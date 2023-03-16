LIBRARY ieee;
USE ieee.std_logic_1164.all;

use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Entity Declaration
ENTITY ALU2 IS
	PORT
	(
		Input : IN STD_LOGIC_VECTOR(3 downto 0);
		nrst : IN STD_LOGIC;
		Clk : IN STD_LOGIC;
		Output : OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END ALU2;


--  Architecture Body
ARCHITECTURE arch OF ALU2 IS
	signal nextstate,presentstate : string(1 to 2);
	signal temp : STD_LOGIC_VECTOR(3 downto 0);

BEGIN
	NSdec: process(presentstate,Input)
		variable n_s : string(1 to 2);
		
	begin
		case presentstate is
			when "S0" => temp <= Input + "0010"; 		 n_s := "S1";
			when "S1" => temp <= temp(2 downto 0) & '0'; n_s := "S2";
			when "S2" => temp <= temp - "0010"; 		 n_s := "S3";
			when "S3" => temp <= '0' & temp(3 downto 1); n_s := "S0";
			when others => n_s := "S0";
		end case;
		nextstate <= n_s after 1 ns;
	end process;
	
	Mem: process(nrst,Clk)
	begin
		if nrst='0' then
			presentstate <= "S0" after 1 ns;
		elsif rising_edge(Clk) then
			presentstate <= nextstate after 1 ns;
		end if;
	end process;
	
	OutDec: process(presentstate)
	begin
		if presentstate = "S3" then 
			Output <= temp after 1 ns; 
		end if;
		
	end process;
END arch;