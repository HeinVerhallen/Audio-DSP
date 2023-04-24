library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2s_encoder is
    Port ( 
            nrst        : in  std_logic;                     -- active-low reset
            sck         : in std_logic;                      -- serial clock
            ws          : in std_logic;                      -- left right audio word select
            data_left   : in  std_logic_vector(23 downto 0); -- left audio data
            data_right  : in  std_logic_vector(23 downto 0); -- right audio data
            sd          : out std_logic                      -- serial data
        );                    
end i2s_encoder;

architecture Behavioral of i2s_encoder is
    type t_machine is (ready, wr_l, wr_r);
    signal machine : t_machine := ready;

    signal dat_L : std_logic_vector(23 downto 0);
    signal dat_R : std_logic_vector(23 downto 0);

begin
    process(sck, nrst)
        --variable bit_cnt : integer range 0 to 23 := 0;
    begin
        if nrst = '0' then 
            machine <= ready;
            --bit_cnt := 0;
        elsif falling_edge(sck) then
            if ws = '0' then
                machine <= wr_l;    -- write left channel
                dat_R <= data_right;
            else
                machine <= wr_r;    -- write right channel
                dat_L <= data_left;
            end if;

            case machine is
                when wr_l =>
                    sd <= dat_L(dat_L'high);-- - bit_cnt);
                    dat_L <= dat_L(23 - 1 downto 0) & '0';

                    --if (bit_cnt + 1 > 23) then
                    --    bit_cnt := 0;

                    --    --Load data
                    --    --dat_L <= data_left;
                    --    --dat_R <= data_right;
                    --else
                    --    bit_cnt := bit_cnt + 1;
                    --end if;
                when wr_r =>
                    sd <= dat_R(dat_R'high);-- - bit_cnt);
                    dat_R <= dat_R(23 - 1 downto 0) & '0';

                    --if (bit_cnt + 1 > 23) then
                    --    bit_cnt := 0;

                    --    --Load data
                    --    --dat_L <= data_left;
                    --    --dat_R <= data_right;
                    --else
                    --    bit_cnt := bit_cnt + 1;
                    --end if;
                when others =>
                    null;
            end case;
        end if;
    end process;
end Behavioral;