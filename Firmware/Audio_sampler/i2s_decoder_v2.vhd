library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2s_decoder_v2 is
    GENERIC(
        d_width     : integer := 24);                           --data width
    Port ( 
        nrst        : in  std_logic;                            --active-low reset
        sck         : in  std_logic;                            --serial clock
        ws          : in  std_logic;                            --left right audio word select
        sd          : in  std_logic;                            --serial data
        data_left   : out std_logic_vector(d_width-1 downto 0); --left audio data
        data_right  : out std_logic_vector(d_width-1 downto 0); --right audio data
        o_avail_left  : out std_logic;                          --left audio available
        o_avail_right : out std_logic                           --right audio available
        );                    
end i2s_decoder_v2;

architecture Behavioral of i2s_decoder_v2 is
    signal l_data_int : std_logic_vector(d_width-1 downto 0);   --internal left audio data
    signal r_data_int : std_logic_vector(d_width-1 downto 0);   --internal right audio data

    type t_machine is (ready, rd_l, rd_r);
    signal machine : t_machine := ready;    --state machine

    signal bit_cnt : integer := 0;          --bit counter

begin
    process(sck, nrst)
    begin
        if nrst = '0' then 
            --Reset state machine and bit counter
            machine <= ready;
            bit_cnt <= 0;
        elsif rising_edge(sck) then
            case machine is
                --Read left audio
                when rd_l =>
                    --Have all bits been read
                    if bit_cnt < d_width then
                        bit_cnt     <= bit_cnt + 1;                                     --increment bit counter
                        l_data_int  <= l_data_int(l_data_int'high - 1 downto 0) & sd;   --shift serial data in internal left audio data
                        data_right  <= r_data_int;                                      --output right audio data
                    end if;

                    --Write available bits
                    o_avail_left  <= '0';
                    o_avail_right <= '1';
                --Read right audio
                when rd_r =>
                    --Have all bits been read
                    if bit_cnt < d_width then
                        bit_cnt     <= bit_cnt + 1;                                     --increment bit counter
                        r_data_int  <= r_data_int(r_data_int'high - 1 downto 0) & sd;   --shift serial data in internal right audio data
                        data_left   <= l_data_int;                                      --output left audio data
                    end if;

                    --Write available bits
                    o_avail_left  <= '1';
                    o_avail_right <= '0';
                when others =>
                    null;
            end case;

            --Left audio data is selected and not already reading left audio data
            if ws = '0' and machine /= rd_l then
                bit_cnt     <= 0;       --reset bit counter    
                machine     <= rd_l;    --set state to read left channel
            --Right audio data is selected and not already reading right audio data
            elsif ws = '1' and machine /= rd_r then
                bit_cnt     <= 0;       --reset bit counter
                machine     <= rd_r;    --set state to read right channel
            end if;
        end if;
    end process;

end Behavioral;