library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
entity DE0_CV is
  port (
     CLOCK_50 : in  std_logic; --clock input
     GPIO     : inout std_logic_vector(35 downto 1) --IO ports
     );  
end DE0_CV;

architecture behave of DE0_CV is
    signal WS : std_logic; --word select for I2S --word select
    signal data_left : std_logic_vector(15 downto 0); --data for I2S
    signal data_right : std_logic_vector(15 downto 0); --data for I2S

    signal CHANNEL : std_logic; -- input from ADC, used for WS

    signal clk_div_4 : std_logic;   --6.25 MHz clock
    signal clk_div_8 : std_logic := '0'; --***changed by BD_CE***  --3.125 MHz clock
begin
    CHANNEL <= GPIO(24); -- input from ADC
    GPIO(34) <= CHANNEL; -- output to DAC
    WS <=  NOT CHANNEL;

    process(clock_50)
        variable cnt_4 : integer range 0 to 3 := 0;
        variable cnt_8 : integer range 0 to 7 := 0;
        begin
        if RISING_EDGE(CLOCK_50) then
            if cnt_8 = 7 then
                clk_div_8 <= NOT clk_div_8;
                cnt_8 := 0;
            else
                cnt_8 := cnt_8 + 1;
            end if;
            if cnt_4 = 3    then
                clk_div_4 <= NOT clk_div_4;
                cnt_4 := 0;
            else
                cnt_4 := cnt_4 + 1;
            end if;
        end if;
    end process;

    data_right <= "1111111111111111"; --test data for right channel
    data_left  <= "1110111011111111"; --***changed by BD_CE***  --test data for right channel
    GPIO(32) <= clk_div_8; --clk for DAC

    process (clk_div_8) --***changed by BD_CE***
        variable out_bit : integer range 0 to 16 := 0; --***changed by BD_CE***
        variable WS_state : std_logic;
        begin   
            if RISING_EDGE(clk_div_8) then
                if WS_state /= WS then --if WS changes state
                   WS_state := WS;
                   out_bit := 0; --reset out bit
                else 
                  out_bit := out_bit + 1; --change data bit
                  if out_bit = 16 then --***added by BD_CE***
                    out_bit := 0;
                  end if;
                end if;
                if WS = '1' then  --***changed by BD_CE***
                        GPIO(30) <= data_right(out_bit); --set data for DAC
                elsif WS = '0' then
                        GPIO(30) <= data_left(out_bit); --set data for DAC
                end if;
            end if;
    end process;

end behave;