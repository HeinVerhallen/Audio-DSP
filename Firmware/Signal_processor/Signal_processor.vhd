LIBRARY ieee;
USE ieee.std_logic_1164.all;

use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

--  Entity Declaration
ENTITY SIGNAL_PROC IS
	PORT
	(
		clk 	: IN STD_LOGIC;
		nrst 	: IN STD_LOGIC;

		input 	: IN STD_LOGIC_VECTOR(23 downto 0);
		output 	: OUT STD_LOGIC_VECTOR(23 downto 0);

		data 	: INOUT STD_LOGIC_VECTOR(23 downto 0);
		regSel 	: IN STD_LOGIC_VECTOR(4 downto 0);
		enData 	: IN STD_LOGIC;
		rw 		: IN STD_LOGIC
	);
END SIGNAL_PROC;


--  Architecture Body
ARCHITECTURE ARCH OF SIGNAL_PROC IS
	--signal nextstate,presentstate : string(1 to 2);
	--signal temp : STD_LOGIC_VECTOR(3 downto 0);
	--signal res : STD_LOGIC_VECTOR(3 downto 0);
	
	constant reg_amount : integer := 13;
	constant eff_num : integer := 20;

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
	signal pos_1 : t_param := (phaser & delay & reverb & distortion & wah);
	signal pos_2 : t_param := (others => '0');
	signal pos_3 : t_param := (others => '0');
	signal pos_4 : t_param := (others => '0');

	--Equalizer band filter registers
	signal eq_f1 : t_param := (others => '0');
	signal eq_f2 : t_param := (others => '0');
	signal eq_f3 : t_param := (others => '0');
	signal eq_f4 : t_param := (others => '0');

	--Effect parameter registers
	signal eff_1 : t_param := (others => '0');
	signal eff_2 : t_param := (others => '0');
	signal eff_3 : t_param := (others => '0');
	signal eff_4 : t_param := (others => '0');
	signal eff_5 : t_param := (others => '0');
	
	--Create register list
	type t_reg is array (0 to reg_amount - 1) of t_param;
	signal regs : t_reg := (
		pos_1,
		pos_2,
		pos_3,
		pos_4,
		eq_f1,
		eq_f2,
		eq_f3,
		eq_f4,
		eff_1,
		eff_2,
		eff_3,
		eff_4,
		eff_5);

	--type t_state is (init, effect_loop, idle);
	--signal state : t_state := init;
	
	--subtype t_param is STD_LOGIC_VECTOR(24 downto 0);

	--type t_mem is 
	--	record
	--		pos1 	: t_param;
	--		pos2 	: t_param;
	--		pos3 	: t_param;
	--		pos4 	: t_param;
	--		eff_1 	: t_param;
	--		eff_2 	: t_param;
	--		eff_3 	: t_param;
	--		eff_4 	: t_param;
	--		eff_5 	: t_param;
	--	end record;

	--signal reg2 : t_mem := (x"0000abc", pos4 => x"0000123", pos2 => wire & distortion & reverb & delay & phaser, others => (others => '0'));

	--signal index : integer range 0 to eff_num - 1 := 0;

	--signal proc_inp : STD_LOGIC_VECTOR(23 downto 0);

BEGIN
	--load: process(nrst, clk)
	--begin
	--	if nrst = '0' then
	--		state <= init;
	--	elsif rising_edge(clk) then
	--		--if index + 1 > eff_num - 1 then
	--		--	index <= 0 after 1 ns;
	--		--else
	--		--	index <= index + 1 after 1 ns;
	--		--end if;

	--		--Load input
	--		proc_inp <= input after 1 ns;

	--		--Start effect loop
	--		--state <= effect_loop after 1 ns;
	--	end if;
	--end process;

	processing: process(nrst, clk)--state, proc_inp)
		--variable n_s : string(1 to 2);
		--variable tmpEff : STD_LOGIC_VECTOR(4 downto 0);
		variable selEff : STD_LOGIC_VECTOR(4 downto 0);
		variable tmpInp : STD_LOGIC_VECTOR(23 downto 0);
		--variable state : t_state;
		
	begin
		if nrst = '0' then
			output <= input after 1 ns;
			--state := init; -- after 1 ns;
		elsif rising_edge(clk) then
			--if index + 1 > eff_num - 1 then
			--	index <= 0 after 1 ns;
			--else
			--	index <= index + 1 after 1 ns;
			--end if;

			--Load input
			--proc_inp <= input after 1 ns;
			tmpInp := input;

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
					when others 		=> null;
				end case;
			end loop eff_loop;

			output <= tmpInp after 1 ns;

			--Start effect loop
			--state := effect_loop; -- after 1 ns;
		end if;

		--case state is
		--	when init => output <= input after 1 ns;
		--	when effect_loop =>
		--		--tmpInp := proc_inp;

		--		eff_loop : for i in 0 to eff_num - 1 loop
		--			selEff := regs(i / 5)((((i rem 5) * 5) + 4) downto ((i rem 5) * 5));

		--			case (selEff) is
		--				when wire 			=> null; --do nothing
		--				when distortion 	=> tmpInp := tmpInp(22 downto 0) & '0';
		--				when reverb 		=> tmpInp := tmpInp - "1";
		--				when delay 			=> tmpInp := tmpInp - "10";
		--				when phaser 		=> tmpInp := tmpInp - "11";
		--				when tremelo 		=> tmpInp := tmpInp - "100";
		--				when flanger 		=> tmpInp := tmpInp - "101";
		--				when fuzz 			=> tmpInp := tmpInp + "1";
		--				when overdrive 		=> tmpInp := tmpInp + "10";
		--				when chorus 		=> tmpInp := tmpInp + "11";
		--				when compressor 	=> tmpInp := tmpInp + "100";
		--				when wah 			=> tmpInp := tmpInp + "101";
		--				when looper 		=> tmpInp := '0' & tmpInp(23 downto 1);
		--				when wow_flutter 	=> tmpInp := "00" & tmpInp(23 downto 2);
		--				when modulator 		=> tmpInp := tmpInp(21 downto 0) & "00";
		--				when echo 			=> tmpInp := tmpInp(20 downto 0) & "000";
		--				when fade 			=> tmpInp := tmpInp(19 downto 0) & "0000";
		--				when noise_gate 	=> tmpInp := not tmpInp;
		--				when equalizer 		=> tmpInp := not tmpInp;
		--				when volume 		=> tmpInp := not tmpInp;
		--				when others 		=> null;
		--			end case;
		--		end loop eff_loop;

		--		state := idle; -- after 1 ns;
                
		--	when idle => 
		--		output <= tmpInp after 1 ns;

		--		--if (proc_inp'event) then
		--		--	state <= effect_loop after 1 ns;
		--		--	tmpInp := proc_inp;
		--		--end if;
        --    when others => null;
		--end case;
	end process;
END ARCH;