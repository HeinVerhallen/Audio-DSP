----------------------------------------------------------------------
-- File Downloaded from http://www.nandland.com
----------------------------------------------------------------------
-- This file contains the UART Transmitter.  This transmitter is able
-- to transmit 8 bits of serial data, one start bit, one stop bit,
-- and no parity bit.  When transmit is complete TX_Done will be
-- driven high for one clock cycle.
--
-- Set Generic CLKS_PER_BIT as follows:
-- CLKS_PER_BIT = (Frequency of clk)/(Frequency of UART)
-- Example: 25 MHz Clock, 115200 baud UART
-- (25000000)/(115200) = 217
-- Example 50 Mhz clock, 9600 baud UART
-- (50000000)/(9600) = 5208
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_TX is
  generic (
    CLKS_PER_BIT : integer := 5208     -- Needs to be set correctly
    );
  port (
    clk       : in  std_logic;
    TX_DV     : in  std_logic;
    TX_Byte   : in  std_logic_vector(7 downto 0);
    TX_Active : out std_logic;
    TX_Serial : out std_logic;
    TX_Done   : out std_logic
    );
end UART_TX;


architecture RTL of UART_TX is

  type t_SM_Main is (IDLE, TX_START_BIT, TX_DATA_BITS,
                     TX_STOP_BIT, CLEANUP);
  signal SM_Main : t_SM_Main := IDLE;

  signal Clk_Count : integer range 0 to CLKS_PER_BIT-1 := 0;
  signal Bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
  signal s_TX_Done   : std_logic := '0';
  
begin

  
  p_UART_TX : process (clk)
  begin
    if rising_edge(clk) then
        
      s_TX_Done   <= '0';  -- Default assignment

      case SM_Main is

        when IDLE =>
          TX_Active <= '0';
          TX_Serial <= '1';         -- Drive Line High for Idle
          Clk_Count <= 0;
          Bit_Index <= 0;

          if TX_DV = '1' then
            TX_Data <= TX_Byte;
            SM_Main <= TX_START_BIT;
          else
            SM_Main <= IDLE;
          end if;

          
        -- Send out Start Bit. Start bit = 0
        when TX_START_BIT =>
          TX_Active <= '1';
          TX_Serial <= '0';

          -- Wait CLKS_PER_BIT-1 clock cycles for start bit to finish
          if Clk_Count < CLKS_PER_BIT-1 then
            Clk_Count <= Clk_Count + 1;
            SM_Main   <= TX_START_BIT;
          else
            Clk_Count <= 0;
            SM_Main   <= TX_DATA_BITS;
          end if;

          
        -- Wait CLKS_PER_BIT-1 clock cycles for data bits to finish          
        when TX_DATA_BITS =>
          TX_Serial <= TX_Data(Bit_Index);
          
          if Clk_Count < CLKS_PER_BIT-1 then
            Clk_Count <= Clk_Count + 1;
            SM_Main   <= TX_DATA_BITS;
          else
            Clk_Count <= 0;
            
            -- Check if we have sent out all bits
            if Bit_Index < 7 then
              Bit_Index <= Bit_Index + 1;
              SM_Main   <= TX_DATA_BITS;
            else
              Bit_Index <= 0;
              SM_Main   <= TX_STOP_BIT;
            end if;
          end if;


        -- Send out Stop bit.  Stop bit = 1
        when TX_STOP_BIT =>
          TX_Serial <= '1';

          -- Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if Clk_Count < CLKS_PER_BIT-1 then
            Clk_Count <= Clk_Count + 1;
            SM_Main   <= TX_STOP_BIT;
          else
            s_TX_Done   <= '1';
            Clk_Count <= 0;
            SM_Main   <= CLEANUP;
          end if;

                  
        -- Stay here 1 clock
	  when CLEANUP =>
          TX_Active <= '0';
          SM_Main   <= IDLE;
          
            
        when others =>
          SM_Main <= IDLE;

      end case;
    end if;
  end process p_UART_TX;

  TX_Done <= s_TX_Done;
  
end RTL;