LIBRARY ieee;
USE ieee.std_logic_1164.all;

use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Entity Declaration
ENTITY ALU3 IS
	PORT
	(
		input : IN STD_LOGIC_VECTOR(3 downto 0);
		en : IN STD_LOGIC_VECTOR(3 downto 0);
		nrst : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END ALU3;


--  Architecture Body
ARCHITECTURE arch OF ALU3 IS
	signal nextstate,presentstate : string(1 to 2);
	signal temp : STD_LOGIC_VECTOR(3 downto 0);
	signal res : STD_LOGIC_VECTOR(3 downto 0);

BEGIN
	NSdec: process(presentstate,input)
		variable n_s : string(1 to 2);
		
	begin
		case presentstate is
			when "S0" => 
				if en(0) = '1' then
					temp <= input + "0010";
				else
					temp <= input;
				end if;
				n_s := "S1";
			when "S1" =>
				if en(1) = '1' then
					temp <= res(2 downto 0) & '0';
				end if;
				n_s := "S2";
			when "S2" =>
				if en(2) = '1' then
					temp <= res - "0010";
				end if;
				n_s := "S3";
			when "S3" =>
				if en(3) = '1' then
					temp <= '0' & res(3 downto 1);
				end if;
				n_s := "S0";
			when others => n_s := "Sx";
		end case;
		nextstate <= n_s after 1 ns;
	end process;
	
	Mem: process(nrst,clk)
	begin
		if nrst='0' then
			presentstate <= "S0" after 1 ns;
		elsif rising_edge(Clk) then
			presentstate <= nextstate after 1 ns;
			res <= temp after 1 ns;
		end if;
	end process;
	
	OutDec: process(presentstate)
	begin
		if presentstate = "S0" then 
			output <= res after 1 ns; 
		end if;
		
	end process;
END arch;