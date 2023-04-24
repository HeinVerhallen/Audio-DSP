library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2s_decoder is
    Port ( 
            nrst        : in  std_logic;                     -- active-low reset
            sck         : in std_logic;                      -- serial clock
            ws          : in std_logic;                      -- left right audio word select
            sd          : in std_logic;                      -- serial data
            data_left   : out  std_logic_vector(23 downto 0); -- left audio data
            data_right  : out  std_logic_vector(23 downto 0)  -- right audio data
        );                    
end i2s_decoder;

architecture Behavioral of i2s_decoder is
    --signal bit_cnt : integer range 0 to 23 := 0;
    signal dat_L : std_logic_vector(23 downto 0);
    signal dat_R : std_logic_vector(23 downto 0);

    type t_machine is (ready, rd_L, rd_R);
    signal machine : t_machine := ready;

begin
    process(sck, nrst)
        --variable bit_cnt : integer range 0 to 23 := 0;
    begin
        if nrst = '0' then 
            machine <= ready;
        elsif rising_edge(sck) then
            if ws = '0' then
                machine <= rd_L;    -- read left channel
            else
                machine <= rd_R;    -- read right channel
            end if;

            case machine is
                when rd_L =>
                    dat_L <= dat_L(dat_L'high - 1 downto 0) & sd;
                    data_right <= dat_R;
                when rd_R =>
                    dat_R <= dat_R(dat_R'high - 1 downto 0) & sd;
                    data_left <= dat_L;
                when others =>
                    null;
            end case;
        end if;
    end process;

end Behavioral;