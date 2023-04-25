LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY initializer IS
  PORT(
    clk       : IN     STD_LOGIC;                    --system clock
    nrst      : IN     STD_LOGIC;                    --active low reset
    busy      : IN     STD_LOGIC;                    --indicates transaction in progress
    ena       : OUT    STD_LOGIC;                    --latch in command
    addr      : OUT    STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : OUT    STD_LOGIC;                    --'0' is write, '1' is read
    data      : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0) --data to write to slave
  );
END initializer;


Architecture arch of initializer is
    constant address : std_logic_vector(6 downto 0) := "0011010";
    --TYPE machine IS(ready, start, command, slv_ack1, wr, slv_ack2, mstr_ack, stop); --needed states
    type machine is (ready, dat1, dat2, disable, stop, idle);
    signal state : machine;

    constant reg_LIN            : std_logic_vector(15 downto 0) := x"011f"; --x"011f"; -- +12dB
    constant reg_RIN            : std_logic_vector(15 downto 0) := x"011f"; --x"031f"; -- +12dB
    constant reg_LOUT           : std_logic_vector(15 downto 0) := x"0465"; --x"0465"; -- -20dB
    constant reg_ROUT           : std_logic_vector(15 downto 0) := x"0665"; --x"0665"; -- -20dB
    constant reg_ADC_path       : std_logic_vector(15 downto 0) := x"0850";
    constant reg_DAC_path       : std_logic_vector(15 downto 0) := x"0a06";
    constant reg_data_format    : std_logic_vector(15 downto 0) := x"0e4a"; --x"0e4a";
    constant reg_sample_ctrl    : std_logic_vector(15 downto 0) := x"101c"; --x"1000";
    constant reg_activate       : std_logic_vector(15 downto 0) := x"1201";
    constant reg_power_init     : std_logic_vector(15 downto 0) := x"0c10";
    constant reg_power_on       : std_logic_vector(15 downto 0) := x"0c00";
    
    constant regLength : integer := 10;
    type t_registerData is array (0 to regLength) of std_logic_vector(15 downto 0);
    constant regData : t_registerData := (reg_power_init, reg_LIN, reg_RIN, reg_LOUT, reg_ROUT, reg_ADC_path, reg_DAC_path, reg_data_format, reg_sample_ctrl, reg_activate, reg_power_on);
Begin
    process(clk, nrst)
        variable index : integer := 0;
    begin
        if nrst = '0' then
            ena   <= '0';
            state <= ready;
        elsif rising_edge(clk) then
            rw   <= '0';
            addr <= address;

            case (state) is
                when ready =>
                    if busy = '0' then
                        state <= dat1;
                    end if;
                when dat1 =>
                    data <= regData(index)(15 downto 8);
                    ena  <= '1';

                    if busy = '1' then
                        state <= dat2;
                    end if;
                when dat2 =>
                    data <= regData(index)(7 downto 0);

                    if busy = '0' then
                        state <= disable;
                    end if;
                when disable =>
                    ena <= '0';

                    if busy = '1' then
                        state <= stop;
                    end if;
                when stop =>
                    if busy = '0' then
                        state <= ready;

                        index := index + 1;
                        if index > regLength then
                            state <= idle;
                        end if;
                    end if;
                when idle =>
                    --Finished
                when others =>
                    null;
            end case;
        end if;
    end process;

End arch;