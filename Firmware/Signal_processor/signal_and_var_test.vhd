LIBRARY ieee;
USE ieee.std_logic_1164.all;

use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

ENTITY T06_signal IS
    port 
    (
        inp : in integer
    );
END T06_signal;

ARCHITECTURE ARCH OF T06_signal IS
    signal mysignal : integer := 0;
BEGIN
    process is
        variable myvariable : integer := 0;
    begin 
        report "*** Process begins ***";
        report "myvariable=" & integer'image(myvariable) & ", mysignal=" & integer'image(mysignal);
        
        mysignal    <= myvariable;
        report "myvariable=" & integer'image(myvariable) & ", mysignal=" & integer'image(mysignal);

        myvariable  := inp;
        report "myvariable=" & integer'image(myvariable) & ", mysignal=" & integer'image(mysignal);

        myvariable  := myvariable * 2;
        report "myvariable=" & integer'image(myvariable) & ", mysignal=" & integer'image(mysignal);

        wait for 10 ns;

        report "myvariable=" & integer'image(myvariable) & ", mysignal=" & integer'image(mysignal);

    end process;
END ARCH;