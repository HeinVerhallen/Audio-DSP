--
-- VHDL Architecture das1_lib.pisoL.pisoL
--
-- Created:
--          by - Administrator.UNKNOWN (GTR)
--          at - 09:39:56 05/ 3/2011
--
-- using Mentor Graphics HDL Designer(TM) 2006.1 (Build 72)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY initialize IS
   PORT( 
	
	   AUD_LINE_IN_LC     : OUT std_logic_vector (15 downto 0);				
      AUD_LINE_IN_RC     : OUT std_logic_vector (15 downto 0);
	   AUD_ADC_PATH	    : OUT std_logic_vector (15 downto 0);
      AUD_DAC_PATH	    : OUT std_logic_vector (15 downto 0);
      AUD_POWER		    : OUT std_logic_vector (15 downto 0);
	   AUD_DATA_FORMAT    : OUT std_logic_vector (15 downto 0);	 
	   AUD_SAMPLE_CTRL    : OUT std_logic_vector (15 downto 0); 
	   AUD_SET_ACTIVE     : OUT std_logic_vector (15 downto 0)			


   );

-- Declarations

END initialize ;

--
ARCHITECTURE initialize OF initialize IS



BEGIN
      AUD_LINE_IN_LC     <=	X"011F";	 --1  -- simultaneus load, disable mute left in					
      AUD_LINE_IN_RC     <=	X"031F";  --2  -- simultaneus load, disable mute	right in
	   AUD_ADC_PATH	    <=	X"0850";  --5  -- no sidetone,DAC:on, mic disabled, line input to ADC:on 72
      AUD_DAC_PATH	    <=	X"0A06";  --6  -- deemphasis to 48 Khz, enable high pass Filter  on ADC
      AUD_POWER		    <=	X"0C00";	 --7  -- no power down mode
	   AUD_DATA_FORMAT    <=	X"0E4A";  --8  -- orig c MSB first, I2S left justified, master mode, bclk inverted,	 
	   AUD_SAMPLE_CTRL    <=	X"1000";  --9  -- 384 fs oversampling 	 
	   AUD_SET_ACTIVE     <=	X"1201";  --10 -- activate

  END ARCHITECTURE initialize;

