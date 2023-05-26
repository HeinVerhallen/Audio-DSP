LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;    
ENTITY ToHex IS                     
   PORT(                                   
	bin : IN std_logic_vector(3 downto 0);
	seg : OUT std_logic_vector(6 downto 0)
   );
-- Declarations
END ToHex ;       
ARCHITECTURE arch OF ToHex IS
	alias Bin3 is bin(3);
	alias Bin2 is bin(2);
	alias Bin1 is bin(1);
	alias Bin0 is bin(0);
	alias g is seg(6);
	alias f is seg(5);
	alias e is seg(4);
	alias d is seg(3);
	alias c is seg(2);
	alias b is seg(1);
	alias a is seg(0);
BEGIN
	PROCESS ( Bin3, Bin2, Bin1, Bin0 )
	BEGIN
		g <= ( NOT Bin3 AND Bin2 AND Bin1 AND Bin0) OR (Bin3 AND Bin2 AND  NOT Bin1 AND  NOT Bin0) OR ( NOT Bin3 AND  NOT Bin2 AND  NOT Bin1) after 5 ns;
		f <= ( NOT Bin3 AND  NOT Bin2 AND Bin1 AND  NOT Bin0) OR (Bin3 AND Bin2 AND  NOT Bin1 AND Bin0) OR ( NOT Bin3 AND  NOT Bin2 AND  NOT Bin1 AND Bin0) OR ( NOT Bin3 AND Bin1 AND Bin0) after 5 ns;
		e <= ( NOT Bin3 AND Bin2 AND  NOT Bin1 AND Bin0) OR ( NOT Bin3 AND Bin2 AND  NOT Bin1 AND  NOT Bin0) OR ( NOT Bin2 AND  NOT Bin1 AND Bin0) OR ( NOT Bin3 AND Bin1 AND Bin0) after 5 ns;
		d <= (Bin3 AND  NOT Bin2 AND Bin1 AND  NOT Bin0) OR ( NOT Bin3 AND Bin2 AND  NOT Bin1 AND  NOT Bin0) OR ( NOT Bin3 AND  NOT Bin2 AND  NOT Bin1 AND Bin0) OR (Bin2 AND Bin1 AND Bin0) after 5 ns;
		c <= ( NOT Bin3 AND  NOT Bin2 AND Bin1 AND  NOT Bin0) OR (Bin3 AND Bin2 AND  NOT Bin1 AND  NOT Bin0) OR (Bin3 AND Bin2 AND Bin1) after 5 ns;
		b <= (Bin3 AND Bin2 AND  NOT Bin1 AND  NOT Bin0) OR (Bin3 AND  NOT Bin2 AND Bin1 AND Bin0) OR ( NOT Bin3 AND Bin2 AND  NOT Bin1 AND Bin0) OR (Bin2 AND Bin1 AND  NOT Bin0) OR (Bin3 AND Bin2 AND Bin1) after 5 ns;
		a <= (Bin3 AND Bin2 AND  NOT Bin1 AND Bin0) OR (Bin3 AND  NOT Bin2 AND Bin1 AND Bin0) OR ( NOT Bin3 AND Bin2 AND  NOT Bin1 AND  NOT Bin0) OR ( NOT Bin3 AND  NOT Bin2 AND  NOT Bin1 AND Bin0) after 5 ns;
		
	END PROCESS; 
END ARCHITECTURE arch;
