----------------------------------------------------------------------
-- File Downloaded from http://www.nandland.com
----------------------------------------------------------------------
-- This file contains the UART Receiver.  This receiver is able to
-- receive 8 bits of serial data, one start bit, one stop bit,
-- and no parity bit.  When receive is complete rx_dv will be
-- driven high for one clock cycle.
-- 
-- Set Generic CLKS_PER_BIT as follows:
-- g_CLKS_PER_BIT = (Frequency of Clk)/(Frequency of UART)
-- Example: 25 MHz Clock, 115200 baud UART
-- (25000000)/(115200) = 217
-- Example 50 Mhz clock, 9600 baud UART
-- (50000000)/(9600) = 5208
--
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity UART_RX is
  generic (
    CLKS_PER_BIT : integer := 5208     -- Needs to be set correctly
    );
  port (
    Clk       : in  std_logic;
    RX_Serial : in  std_logic;
    RX_DV     : out std_logic;
    RX_Byte   : out std_logic_vector(7 downto 0)
    );
end UART_RX;


architecture RTL of UART_RX is

  type t_SM_Main is (Idle, RX_Start_Bit, RX_Data_Bits,
                     RX_Stop_Bit, Cleanup);
  signal SM_Main : t_SM_Main := Idle;

  signal Clk_Count : integer range 0 to CLKS_PER_BIT-1 := 0;
  signal Bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal s_RX_Byte   : std_logic_vector(7 downto 0) := (others => '0');
  signal s_RX_DV     : std_logic := '0';
  
begin

  -- Purpose: Control RX state machine
  p_UART_RX : process (Clk)
  begin
    if rising_edge(Clk) then
        
      case SM_Main is

        when Idle =>
          s_RX_DV     <= '0';
          Clk_Count <= 0;
          Bit_Index <= 0;

          if RX_Serial = '0' then       -- Start bit detected
            SM_Main <= RX_Start_Bit;
          else
            SM_Main <= Idle;
          end if;

          
        -- Check middle of start bit to make sure it's still low
        when RX_Start_Bit =>
          if Clk_Count = (CLKS_PER_BIT-1)/2 then
            if RX_Serial = '0' then
              Clk_Count <= 0;  -- reset counter since we found the middle
              SM_Main   <= RX_Data_Bits;
            else
              SM_Main   <= Idle;
            end if;
          else
            Clk_Count <= Clk_Count + 1;
            SM_Main   <= RX_Start_Bit;
          end if;

          
        -- Wait CLKS_PER_BIT-1 clock cycles to sample serial data
        when RX_Data_Bits =>
          if Clk_Count < CLKS_PER_BIT-1 then
            Clk_Count <= Clk_Count + 1;
            SM_Main   <= RX_Data_Bits;
          else
            Clk_Count            <= 0;
            s_RX_Byte(Bit_Index) <= RX_Serial;
            
            -- Check if we have sent out all bits
            if Bit_Index < 7 then
              Bit_Index <= Bit_Index + 1;
              SM_Main   <= RX_Data_Bits;
            else
              Bit_Index <= 0;
              SM_Main   <= RX_Stop_Bit;
            end if;
          end if;


        -- Receive Stop bit.  Stop bit = 1
        when RX_Stop_Bit =>
          -- Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if Clk_Count < CLKS_PER_BIT-1 then
            Clk_Count <= Clk_Count + 1;
            SM_Main   <= RX_Stop_Bit;
          else
            s_RX_DV     <= '1';
            Clk_Count <= 0;
            SM_Main   <= Cleanup;
          end if;

                  
        -- Stay here 1 clock
        when Cleanup =>
          SM_Main <= Idle;
          s_RX_DV   <= '0';

            
        when others =>
          SM_Main <= Idle;

      end case;
    end if;
  end process p_UART_RX;

  RX_DV   <= s_RX_DV;
  RX_Byte <= s_RX_Byte;
  
end RTL;