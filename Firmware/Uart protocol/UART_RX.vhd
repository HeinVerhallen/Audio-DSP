-- Set Generic CLKS_PER_BIT as follows:
-- g_CLKS_PER_BIT = (Frequency of Clk)/(Frequency of UART)
-- Example: 25 MHz Clock, 115200 baud UART
-- (25000000)/(115200) = 217
-- Example 50 Mhz clock, 9600 baud UART
-- (50000000)/(9600) = 5208
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY UART_RX IS
	GENERIC (
		CLKS_PER_BIT : integer := 5208     -- Needs to be set correctly
	);
	PORT (
		Nrst			: IN	std_logic;
		Clk       	: IN  std_logic;
		RX_Serial 	: IN  std_logic;
		RX_DV     	: OUT std_logic;
		RX_Byte   	: OUT std_logic_vector(7 DOWNTO 0)
	);
END UART_RX;

ARCHITECTURE RTL OF UART_RX IS
	TYPE t_SM_Main IS (Idle, RX_Start_Bit, RX_Data_Bits,
                     RX_Stop_Bit, Cleanup);
	SIGNAL SM_Main : t_SM_Main := Idle;
	SIGNAL Clk_Count : integer RANGE 0 TO CLKS_PER_BIT-1 := 0;
	SIGNAL Bit_Index : integer RANGE 0 TO 7 := 0;  -- 8 Bits Total
	SIGNAL s_RX_Byte   : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL s_RX_DV     : std_logic := '0';
  
BEGIN
	-- Purpose: Control RX state machine
	p_UART_RX : PROCESS (Clk, Nrst)
BEGIN
	IF Nrst = '0' THEN
		--reset outputs
		
		--reset signals
		SM_Main	<= IDLE;
		Clk_Count<= 0;
		Bit_Index<= 0;
		s_RX_Byte<= (OTHERS => '0');
		s_RX_DV	<= '0';
		
	ELSIF rising_edge(Clk) THEN     
      CASE SM_Main IS
			WHEN Idle =>
				s_RX_DV		<= '0';
				Clk_Count	<= 0;
				Bit_Index	<= 0;

				IF RX_Serial = '0' THEN       -- Start bit detected
					SM_Main <= RX_Start_Bit;
				ELSE
					SM_Main <= Idle;
				END IF;
          
			-- Check middle of start bit to make sure it's still low
			WHEN RX_Start_Bit =>
				IF Clk_Count = (CLKS_PER_BIT-1)/2 THEN
					IF RX_Serial = '0' THEN
						Clk_Count <= 0;  -- reset counter since we found the middle
						SM_Main   <= RX_Data_Bits;
					ELSE
						SM_Main   <= Idle;
					END IF;
				ELSE
					Clk_Count <= Clk_Count + 1;
					SM_Main   <= RX_Start_Bit;
				END IF;
          
        -- Wait CLKS_PER_BIT-1 clock cycles to sample serial data
			WHEN RX_Data_Bits =>
				IF Clk_Count < CLKS_PER_BIT-1 THEN
					Clk_Count <= Clk_Count + 1;
					SM_Main   <= RX_Data_Bits;
				ELSE
					Clk_Count            <= 0;
					s_RX_Byte(Bit_Index) <= RX_Serial;
            
            -- Check if we have sent out all bits
					IF Bit_Index < 7 THEN
						Bit_Index <= Bit_Index + 1;
						SM_Main   <= RX_Data_Bits;
					ELSE
						Bit_Index <= 0;
						SM_Main   <= RX_Stop_Bit;
					END IF;
				END IF;

			-- Receive Stop bit.  Stop bit = 1
			WHEN RX_Stop_Bit =>
				-- Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
				IF Clk_Count < CLKS_PER_BIT - 1 THEN
					Clk_Count <= Clk_Count + 1;
					SM_Main   <= RX_Stop_Bit;
				ELSE
					s_RX_DV     <= '1';
					Clk_Count <= 0;
					SM_Main   <= Cleanup;
				END IF;

                  
			-- Stay here 1 clock
			WHEN Cleanup =>
				SM_Main <= Idle;
				s_RX_DV   <= '0';

            
			WHEN OTHERS =>
				SM_Main <= Idle;

		END CASE;
	END IF;
END PROCESS p_UART_RX;
  RX_DV   <= s_RX_DV;
  RX_Byte <= s_RX_Byte;
END RTL;