LIBRARY ieee;
USE ieee.std_logic_1164.all;

use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

--  Entity Declaration
ENTITY SIGNAL_PROC IS
	PORT
	(
		sample_clk 	: IN STD_LOGIC;						--sample clock
		sys_clk		: IN STD_LOGIC;						--system clock
		nrst 		: IN STD_LOGIC;						--active low reset

		input 	: IN STD_LOGIC_VECTOR(23 downto 0);		--audio input
		output 	: OUT STD_LOGIC_VECTOR(23 downto 0);	--audio output

		data 	: INOUT STD_LOGIC_VECTOR(24 downto 0);	--register data
		regSel 	: IN STD_LOGIC_VECTOR(4 downto 0);		--register select
		enData 	: IN STD_LOGIC;							--enable register data transfer
		rw 		: IN STD_LOGIC 							--read/write identifier, 0 = write, 1 = read
	);
END SIGNAL_PROC;


--  Architecture Body
ARCHITECTURE ARCH OF SIGNAL_PROC IS
	constant reg_amount : integer := 13;	--specify amount of registers in memory
	constant eff_num 	: integer := 20;		--specify amount of effects

	subtype t_eff is STD_LOGIC_VECTOR(4 downto 0);

	--Effect addresses
	constant wire 			: t_eff := ('0' & x"0");
	constant distortion 	: t_eff := ('0' & x"1");
	constant reverb 		: t_eff := ('0' & x"2");
	constant delay 			: t_eff := ('0' & x"3");
	constant phaser 		: t_eff := ('0' & x"4");
	constant tremelo 		: t_eff := ('0' & x"5");
	constant flanger 		: t_eff := ('0' & x"6");
	constant fuzz 			: t_eff := ('0' & x"7");
	constant overdrive 		: t_eff := ('0' & x"8");
	constant chorus 		: t_eff := ('0' & x"9");
	constant compressor 	: t_eff := ('0' & x"a");
	constant wah 			: t_eff := ('0' & x"b");
	constant looper 		: t_eff := ('0' & x"c");
	constant wow_flutter 	: t_eff := ('0' & x"d");
	constant modulator  	: t_eff := ('0' & x"e");
	constant echo 			: t_eff := ('0' & x"f");
	constant fade 			: t_eff := ('1' & x"0");
	constant noise_gate 	: t_eff := ('1' & x"1");
	constant equalizer 		: t_eff := ('1' & x"2");
	constant volume 		: t_eff := ('1' & x"3");

	subtype t_param is STD_LOGIC_VECTOR(24 downto 0);

	--Effect position registers
	constant pos_1 : t_param := (phaser & delay & reverb & distortion & wah);
	constant pos_2 : t_param := (others => '0');
	constant pos_3 : t_param := (others => '0');
	constant pos_4 : t_param := (others => '0');

	--Equalizer band filter registers
	constant eq_f1 : t_param := (others => '0');
	constant eq_f2 : t_param := (others => '0');
	constant eq_f3 : t_param := (others => '0');
	constant eq_f4 : t_param := (others => '0');

	--Effect parameter registers
	constant eff_1 : t_param := (others => '0');
	constant eff_2 : t_param := (others => '0');
	constant eff_3 : t_param := (others => '0');
	constant eff_4 : t_param := (others => '0');
	constant eff_5 : t_param := (others => '0');
	
	--Create memory which houses all registers
	type t_reg is array (0 to reg_amount - 1) of t_param;
	signal regs : t_reg := (
		--Position registers
		pos_1,
		pos_2,
		pos_3,
		pos_4,
		--Equalizer registers
		eq_f1,
		eq_f2,
		eq_f3,
		eq_f4,
		--Effect parameter registers
		eff_1,
		eff_2,
		eff_3,
		eff_4,
		eff_5);

BEGIN
	data_transfer : process(nrst, sys_clk, rw)
		variable tmpRegSel : integer;

	begin
        if nrst = '0' then
			data <= "ZZZZZZZZZZZZZZZZZZZZZZZZZ" after 1 ns;
		elsif rising_edge(sys_clk) then
            if (enData = '1') then
                tmpRegSel := to_integer(unsigned(regSel));

                --Selected register is out of range
                if tmpRegSel > reg_amount - 1 then
                    --Do nothing
                elsif (rw = '0') then
                    --Write register
                    regs(tmpRegSel) <= data after 1 ns;
                else 
                    --Read register
                    data <= regs(tmpRegSel) after 1 ns;
                end if;
            --Disabled so make output high impedance
            else
            	data <= "ZZZZZZZZZZZZZZZZZZZZZZZZZ" after 1 ns;
            end if;
       	end if;

       	--Write register so make output high impedance
       	if rw = '0' then
        	data <= "ZZZZZZZZZZZZZZZZZZZZZZZZZ" after 1 ns;
      	end if;
	end process;

	effectloop : process(nrst, sample_clk)
		variable selEff : STD_LOGIC_VECTOR(4 downto 0);						--selected effect
		variable tmpInp : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');	--temporary processed input
		
	begin
		if nrst = '0' then
			output <= input after 1 ns;
		elsif rising_edge(sample_clk) then
			--Write modified signal to output
			output <= tmpInp after 1 ns;

			--Load input
			tmpInp := input;

			--Go through effect loop
			eff_loop : for i in 0 to eff_num - 1 loop
				selEff := regs(i / 5)((((i rem 5) * 5) + 4) downto ((i rem 5) * 5));

				case (selEff) is
					when wire 			=> null; --do nothing
					when distortion 	=> tmpInp := tmpInp(22 downto 0) & '0';
					when reverb 		=> tmpInp := tmpInp - "1";
					when delay 			=> tmpInp := tmpInp - "10";
					when phaser 		=> tmpInp := tmpInp - "11";
					when tremelo 		=> tmpInp := tmpInp - "100";
					when flanger 		=> tmpInp := tmpInp - "101";
					when fuzz 			=> tmpInp := tmpInp + "1";
					when overdrive 		=> tmpInp := tmpInp + "10";
					when chorus 		=> tmpInp := tmpInp + "11";
					when compressor 	=> tmpInp := tmpInp + "100";
					when wah 			=> tmpInp := tmpInp + "101";
					when looper 		=> tmpInp := '0' & tmpInp(23 downto 1);
					when wow_flutter 	=> tmpInp := "00" & tmpInp(23 downto 2);
					when modulator 		=> tmpInp := tmpInp(21 downto 0) & "00";
					when echo 			=> tmpInp := tmpInp(20 downto 0) & "000";
					when fade 			=> tmpInp := tmpInp(19 downto 0) & "0000";
					when noise_gate 	=> tmpInp := not tmpInp;
					when equalizer 		=> tmpInp := not tmpInp;
					when volume 		=> tmpInp := not tmpInp;
					when others 		=> null; --do nothing
				end case;
			end loop eff_loop;
		end if;
	end process;
END ARCH;