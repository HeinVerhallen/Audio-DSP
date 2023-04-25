library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2s_encoder is
    GENERIC(
        d_width     : integer := 24);                           --data width
    Port ( 
        nrst        : in  std_logic;                            --active-low reset
        sck         : in std_logic;                             --serial clock
        ws          : in std_logic;                             --left right audio word select
        data_left   : in  std_logic_vector(d_width-1 downto 0); --left audio data
        data_right  : in  std_logic_vector(d_width-1 downto 0); --right audio data
        sd          : out std_logic                             --serial data
        );                    
end i2s_encoder;

architecture Behavioral of i2s_encoder is
    type t_machine is (ready, wr_l, wr_r);
    signal machine : t_machine := ready;

    signal l_data_int : std_logic_vector(d_width-1 downto 0);
    signal r_data_int : std_logic_vector(d_width-1 downto 0);

    signal bit_cnt : integer := 0;

begin
    process(sck, nrst)
    begin
        if nrst = '0' then 
            machine <= ready;
            bit_cnt <= 0;
        elsif falling_edge(sck) then
            case machine is
                when wr_l =>
                    if bit_cnt < d_width then
                        bit_cnt     <= bit_cnt + 1;
                        l_data_int  <= l_data_int(r_data_int'high - 1 downto 0) & '0'; 
                        sd          <= l_data_int(l_data_int'high);
                    end if;
                    r_data_int  <= data_right;
                when wr_r =>
                    if bit_cnt < d_width then
                        bit_cnt     <= bit_cnt + 1;
                        r_data_int  <= r_data_int(r_data_int'high - 1 downto 0) & '0';
                        sd          <= r_data_int(r_data_int'high);
                    end if;
                    l_data_int  <= data_left;
                when others =>
                    null;
            end case;
            
            if ws = '0' and machine /= wr_l then
                bit_cnt     <= 0;
                machine     <= wr_l;    -- write left channel
            elsif ws = '1' and machine /= wr_r then
                bit_cnt     <= 0;
                machine     <= wr_r;    -- write right channel
            end if;
        end if;
    end process;
end Behavioral;