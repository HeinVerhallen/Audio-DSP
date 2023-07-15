library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity i2s_encoder is
  port (
    clk : in std_logic;
    data_left : in std_logic_vector(23 downto 0);
    data_right : in std_logic_vector(23 downto 0);
    ws : out std_logic;
    sck : out std_logic;
    sd : out std_logic);
end i2s_encoder;

architecture Behavioral of i2s_encoder is

<<<<<<< Updated upstream
    signal bit_cnt : integer range 0 to 47 := 0;
    signal data    : std_logic_vector(47 downto 0) := (others => '0');
    signal bck     : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if bit_cnt = 47 then
                bit_cnt <= 0;
            else
                bit_cnt <= bit_cnt + 1;
            end if;
            if bit_cnt < 24 then
                data(bit_cnt) <= data_left(bit_cnt);
            else
                data(bit_cnt) <= data_right(bit_cnt-24);
            end if;
            if bit_cnt = 39 then
                ws <= '1';
            else
                ws <= '0';
            end if;
            bck <= not bck;
            sck <= bck;
            sd <= data(47);
            data <= data(46 downto 0) & '0';
        end if;
    end process;
=======
  signal bit_cnt : integer range 0 to 47 := 0;
  signal data : std_logic_vector(47 downto 0) := (others => '0');

begin

  process (clk)
  begin
    if rising_edge(clk) then
      if bit_cnt = 47 then
        bit_cnt <= 0;
      else
        bit_cnt <= bit_cnt + 1;
      end if;
      if bit_cnt < 24 then
        data(bit_cnt) <= data_left(bit_cnt);
      else
        data(bit_cnt) <= data_right(bit_cnt - 24);
      end if;
      if bit_cnt = 39 then
        ws <= '1';
      else
        ws <= '0';
      end if;
      sck <= not sck;
      sd <= data(47);
      data <= data(46 downto 0) & '0';
    end if;
  end process;
>>>>>>> Stashed changes

end Behavioral;