library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2s_encoder is
    generic (
        --constant f_mclk : integer := 12_288e3;  -- 50MHz
        constant div    : integer := 256        -- f_sample = 48kHz
    );
    Port ( 
            mclk        : in  std_logic;                     -- master clock
            nrst        : in  std_logic;                     -- active-low reset
            data_left   : in  std_logic_vector(23 downto 0); -- left audio data
            data_right  : in  std_logic_vector(23 downto 0); -- right audio data
            sck         : in std_logic;                      -- serial clock
            ws          : out std_logic;                     -- left right audio word select
            sd          : out std_logic                      -- serial data
        );                    
end i2s_encoder;

architecture Behavioral of i2s_encoder is
    --signal sck_cnt  : integer := 0;

    type t_machine is (wr_l, wr_r);
    signal machine : t_machine := wr_l;

    signal bit_cnt : integer range 0 to 23 := 0;
    signal dat_L : std_logic_vector(23 downto 0);
    signal dat_R : std_logic_vector(23 downto 0);

begin
    process(sck, nrst)
        variable bit_cnt : integer range 0 to 23 := 0;
    begin
        if nrst = '0' then 
            machine <= wr_l;
        elsif falling_edge(sck) then
            case machine is
                when wr_l =>
                    ws <= '0';

                    sd <= dat_L(dat_L'high - bit_cnt);

                    if (bit_cnt + 1 > 23) then
                        bit_cnt := 0;
                        ws <= '1';
                        machine <= wr_r;
                    else
                        bit_cnt := bit_cnt + 1;
                    end if;
                when wr_r =>
                    ws <= '1';

                    sd <= dat_R(dat_R'high - bit_cnt);

                    if (bit_cnt + 1 > 23) then
                        bit_cnt := 0;
                        ws <= '0';
                        machine <= wr_l;

                        --Load data
                        dat_L <= data_left;
                        dat_R <= data_right;
                    else
                        bit_cnt := bit_cnt + 1;
                    end if;
                when others =>
                    null;
            end case;
        end if;
    end process;

    --process(mclk, nrst)
    --begin
    --    if nrst = '0' then
    --        machine <= load;
    --    elsif rising_edge(mclk) then
    --        if machine = load then
    --            dat_L <= data_left;
    --            dat_R <= data_right;
    --            machine <= wr_l;
    --        end if;

            --case machine is
            --    when load =>
            --        dat_L <= data_left;
            --        dat_R <= data_right;
            --        machine <= wr_l;
            --    when wr_l =>
            --        ws <= '1';



            --        if bit_cnt + 1 > 23 then
            --            bit_cnt <= 0;
            --            machine <= wr_r;
            --        else
            --            bit_cnt <= bit_cnt + 1;
            --        end if;
            --    when wr_r =>
            --        ws <= '0';

            --        if bit_cnt + 1 > 23 then
            --            bit_cnt <= 0;
            --            machine <= load;
            --        else
            --            bit_cnt <= bit_cnt + 1;
            --        end if;
            --    when others =>
            --        null;
            --end case;
    --    end if;
    --end process;

end Behavioral;