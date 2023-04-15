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

    constant reg_LIN            : std_logic_vector(15 downto 0) := x"011f";
    constant reg_RIN            : std_logic_vector(15 downto 0) := x"031f";
    constant reg_ADC_path       : std_logic_vector(15 downto 0) := x"0850";
    constant reg_DAC_path       : std_logic_vector(15 downto 0) := x"0a06";
    constant reg_power          : std_logic_vector(15 downto 0) := x"0c00";
    constant reg_data_format    : std_logic_vector(15 downto 0) := x"0e4a";
    constant reg_sample_ctrl    : std_logic_vector(15 downto 0) := x"1000";
    constant reg_activate       : std_logic_vector(15 downto 0) := x"1201";

    type t_registerData is array (0 to 7) of std_logic_vector(15 downto 0);
    constant regData : t_registerData := (reg_LIN, reg_RIN, reg_ADC_path, reg_DAC_path, reg_power, reg_data_format, reg_sample_ctrl, reg_activate);
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
                        if index > 7 then
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