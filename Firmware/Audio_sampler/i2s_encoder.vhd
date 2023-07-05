library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2s_encoder is
    GENERIC(
        d_width     : integer := 24); --data width
    Port ( 
        mclk            : in std_logic;
        nrst            : in std_logic;                             --active-low reset
        sck             : in std_logic;                             --serial clock
        ws              : in std_logic;                             --left right audio word select
        data_left       : in std_logic_vector(d_width-1 downto 0);  --left audio data
        data_right      : in std_logic_vector(d_width-1 downto 0);  --right audio data
        i_avail_left    : in std_logic;                             --left audio available
        i_avail_right   : in std_logic;                             --right audio available
        sd              : out std_logic                             --serial data
        );                    
end i2s_encoder;

architecture Behavioral of i2s_encoder is
    signal l_data_int : std_logic_vector(d_width-1 downto 0);   --internal left audio data
    signal r_data_int : std_logic_vector(d_width-1 downto 0);   --internal right audio data

    type t_machine is (ready, wr_l, wr_r);
    signal machine : t_machine := ready;    --state machine

    signal bit_cnt : integer := 0;          --bit counter

    signal load_l : std_logic := '0';
    signal load_r : std_logic := '0';
    signal ack_l  : std_logic := '0';
    signal ack_r  : std_logic := '0';

begin
    --process(mclk, sck, nrst)
    process(sck, nrst, load_l, load_r)
    begin
        if nrst = '0' then 
            --Reset state machine and bit counter
            machine <= ready;
            bit_cnt <= 0;
            l_data_int <= (others => '0');
            r_data_int <= (others => '0');
        elsif falling_edge(sck) then
            case machine is
                --Write left audio
                when wr_l =>
                    --Have all bits been written
                    if bit_cnt < d_width then
                        bit_cnt     <= bit_cnt + 1;                                     --increment bit counter
                        l_data_int  <= l_data_int(l_data_int'high - 1 downto 0) & '0';  --shift internal left audio data to the left
                        sd          <= l_data_int(l_data_int'high);                     --output MSB of internal left audio data to serial data output
                    end if;

                    --If right data is available
                    --if (i_avail_right = '1') then
                    --    r_data_int  <= data_right;
                    --end if;

                --Write right audio
                when wr_r =>
                    --Have all bits been written
                    if bit_cnt < d_width then
                        bit_cnt     <= bit_cnt + 1;                                     --increment bit counter
                        r_data_int  <= r_data_int(r_data_int'high - 1 downto 0) & '0';  --shift internal right audio data to the left
                        sd          <= r_data_int(r_data_int'high);                     --output MSB of internal right audio data to serial data output
                    end if;

                    --If left data is available
                    --if (i_avail_left = '1') then
                    --    l_data_int  <= data_left;
                    --end if;

                when others =>
                    null;
            end case;
            
            --Left audio data is selected and not already writing left audio data
            if ws = '0' and machine /= wr_l then
                bit_cnt     <= 0;       --reset bit counter
                machine     <= wr_l;    --set state to write left channel
            --Right audio data is selected and not already writing right audio data
            elsif ws = '1' and machine /= wr_r then
                bit_cnt     <= 0;       --reset bit counter
                machine     <= wr_r;    --set state to write right channel
            end if;
        --elsif (rising_edge(mclk)) then
        --    --If left data is available and not currently writing left data
        --    if (i_avail_left = '1' and machine /= wr_l) then
        --        l_data_int  <= data_left;
        --    end if;

        --    --If right data is available and not currently writing right data
        --    if (i_avail_right = '1' and machine /= wr_r) then
        --        r_data_int  <= data_right;
        --    end if;
        end if;

        if (load_l = '1') then
            ack_l <= '1';

            l_data_int <= data_left;
        else
            ack_l <= '0';
        end if;

        if (load_r = '1') then
            ack_r <= '1';

            r_data_int <= data_right;
        else
            ack_r <= '0';
        end if;
    end process;

    process (mclk)
    begin
        if (rising_edge(mclk)) then
            --If left data is available and not currently writing left data
            if (i_avail_left = '1' and machine /= wr_l and ack_l = '0') then
                --l_data_int  <= data_left;
                --if (ack_l = '1') then
                --    load_l <= '0';
                --else
                --    load_l <= '1';
                --end if;
                load_l <= '1';
            else
                load_l <= '0';
            end if;

            --If right data is available and not currently writing right data
            if (i_avail_right = '1' and machine /= wr_r and ack_r = '0') then
                --r_data_int  <= data_right;
                --if (ack_r = '1') then
                --    load_r <= '0';
                --else
                --    load_r <= '1';
                --end if;
                load_r <= '1';
            else
                load_r <= '0';
            end if;
        end if;
    end process;
end Behavioral;