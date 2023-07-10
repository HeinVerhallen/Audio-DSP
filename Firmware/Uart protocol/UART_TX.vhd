-- Set Generic CLKS_PER_BIT as follows:
-- CLKS_PER_BIT = (Frequency OF clk)/(Frequency OF UART)
-- Example: 25 MHz Clock, 115200 baud UART
-- (25000000)/(115200) = 217
-- Example 50 Mhz clock, 9600 baud UART
-- (50000000)/(9600) = 5208
-- 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY UART_TX IS
  GENERIC (
    CLKS_PER_BIT : integer := 5208     -- Needs TO be set correctly
    );
	PORT (
		Nrst			: IN	std_logic;
		clk       	: IN	std_logic;
		TX_DV     	: IN	std_logic;
		TX_Byte   	: IN	std_logic_vecTOr(7 DOWNTO 0);
		TX_Active 	: OUT std_logic;
		TX_Serial 	: OUT std_logic;
		TX_Done   	: OUT std_logic
   );
END UART_TX;

ARCHITECTURE RTL OF UART_TX IS
  TYPE t_SM_Main IS (IDLE, TX_START_BIT, TX_DATA_BITS,
                     TX_STOP_BIT, CLEANUP);
  SIGNAL SM_Main : t_SM_Main := IDLE;
  SIGNAL Clk_Count : integer RANGE 0 TO CLKS_PER_BIT-1 := 0;
  SIGNAL Bit_Index : integer RANGE 0 TO 7 := 0;  -- 8 Bits TOtal
  SIGNAL TX_Data   : std_logic_vecTOr(7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_TX_Done   : std_logic := '0';
  
BEGIN
	p_UART_TX : PROCESS (clk)
BEGIN
	IF Nrst = '0'THEN
		--reset outputs
		TX_Serial 	<= '1';
		TX_Active 	<= '0';
		TX_Done		<= '0';
		
		--reset signals
		SM_MAIN		<= IDLE;
		Clk_Count	<= 0;
		Bit_Index	<= 0;
		TX_Data		<= (OTHERS => '0');
		s_TX_Done	<= '0';
	ELSIF rising_edge(clk) THEN
		s_TX_Done   <= '0';  -- Default assignment
		CASE SM_Main IS
			WHEN IDLE =>
				TX_Active <= '0';
				TX_Serial <= '1';         -- Drive Line High for Idle
				Clk_Count <= 0;
				Bit_Index <= 0;

				IF TX_DV = '1' THEN
				TX_Data <= TX_Byte;
				SM_Main <= TX_START_BIT;
				ELSE
				SM_Main <= IDLE;
				END IF;
        
		  -- Send out Start Bit. Start bit = 0
			WHEN TX_START_BIT =>
				TX_Active <= '1';
				TX_Serial <= '0';

          -- Wait CLKS_PER_BIT-1 clock cycles for start bit TO finISh
				IF Clk_Count < CLKS_PER_BIT-1 THEN
					Clk_Count <= Clk_Count + 1;
					SM_Main   <= TX_START_BIT;
				ELSE
					Clk_Count <= 0;
					SM_Main   <= TX_DATA_BITS;
				END IF;

        -- Wait CLKS_PER_BIT-1 clock cycles for data bits TO finISh          
			WHEN TX_DATA_BITS =>
				TX_Serial <= TX_Data(Bit_Index);
				IF Clk_Count < CLKS_PER_BIT-1 THEN
					Clk_Count <= Clk_Count + 1;
					SM_Main   <= TX_DATA_BITS;
				ELSE
					Clk_Count <= 0;
            -- Check if we have sent out all bits
					IF Bit_Index < 7 THEN
						Bit_Index <= Bit_Index + 1;
						SM_Main   <= TX_DATA_BITS;
					ELSE
						Bit_Index <= 0;
						SM_Main   <= TX_STOP_BIT;
					END IF;
				END IF;

        -- Send out STOp bit.  STOp bit = 1
			WHEN TX_STOP_BIT =>
				TX_Serial <= '1';

				-- Wait CLKS_PER_BIT-1 clock cycles for STOp bit TO finISh
				IF Clk_Count < CLKS_PER_BIT-1 THEN
					Clk_Count <= Clk_Count + 1;
					SM_Main   <= TX_STOP_BIT;
				ELSE
					s_TX_Done   <= '1';
					Clk_Count <= 0;
					SM_Main   <= CLEANUP;
				END IF;
     
			-- Stay here 1 clock
			WHEN CLEANUP =>
				TX_Active <= '0';
				SM_Main   <= IDLE;
         
			WHEN OTHERS =>
				SM_Main <= IDLE;
		END CASE;
	END IF;
	TX_Done <= s_TX_Done;
END PROCESS p_UART_TX;
END RTL;