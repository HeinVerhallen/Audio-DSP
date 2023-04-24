library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2s_decoder is
    GENERIC(
        d_width     : integer := 24);                               --data width
    Port ( 
        nrst        : in  std_logic;                                --active-low reset
        sck         : in std_logic;                                 --serial clock
        ws          : in std_logic;                                 --left right audio word select
        sd          : in std_logic;                                 --serial data
        data_left   : out  std_logic_vector(d_width-1 downto 0);    --left audio data
        data_right  : out  std_logic_vector(d_width-1 downto 0)     --right audio data
        );                    
end i2s_decoder;

architecture Behavioral of i2s_decoder is
    signal l_data_int : std_logic_vector(d_width-1 downto 0);
    signal r_data_int : std_logic_vector(d_width-1 downto 0);

    type t_machine is (ready, rd_l, rd_r);
    signal machine : t_machine := ready;

    signal bit_cnt : integer := 0;

begin
    process(sck, nrst)
    begin
        if nrst = '0' then 
            machine <= ready;
            bit_cnt <= 0;
        elsif rising_edge(sck) then
            case machine is
                when rd_l =>
                    if bit_cnt < d_width then
                        bit_cnt     <= bit_cnt + 1;
                        l_data_int  <= l_data_int(l_data_int'high - 1 downto 0) & sd;
                        data_right  <= r_data_int;
                    end if;
                when rd_r =>
                    if bit_cnt < d_width then
                        bit_cnt     <= bit_cnt + 1;
                        r_data_int  <= r_data_int(r_data_int'high - 1 downto 0) & sd;
                        data_left   <= l_data_int;
                    end if;
                when others =>
                    null;
            end case;

            if ws = '0' and machine /= rd_l then
                bit_cnt     <= 0;
                machine     <= rd_l;        -- read left channel
            elsif ws = '1' and machine /= rd_r then
                bit_cnt     <= 0;
                machine     <= rd_r;        -- read right channel
            end if;
        end if;
    end process;

end Behavioral;