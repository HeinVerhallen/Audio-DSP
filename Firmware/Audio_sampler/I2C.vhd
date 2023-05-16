library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity I2C is
    port(
        clk: in std_logic;
        enable: in std_logic;
        reset: in std_logic; 
        I2C_ADDRESS: in std_logic_vector(6 downto 0);
        I2C_DATA: in std_logic_vector(7 downto 0);
        I2C_RW: in std_logic; 								-- Read (1) Write(0)
        SDA : inout std_logic; 								--SDA = Serial Data/Address  
        SCL : out std_logic; 									--SCL = Serial Clock  
        I2C_BUSY : out std_logic; 							--1 Busy , 0 (waits for response)
        DATA_READ: out std_logic_vector(7 downto 0)
    );
end entity;


architecture arch of I2C is
    Type State is(IDLE,ADDR,W_DATA,R_DATA,TEMP1,TEMP2,TEMP3,S_ACK,WS_ACK,R_ACK);
    SIGNAL present:state := IDLE;                                             -- Presesnt address to be used in this case IDLE is the default value 
    SIGNAL SHIFT_ADD: Std_logic_vector(6 downto 0);									--Save address info
    SIGNAL SHIFT_DAT: Std_logic_vector(7 downto 0);									--Saves Data info
    SIGNAL SIG_RW : std_logic; 																--Saves RW info 
    SIGNAL ACK_FlagADD : std_logic := '1'; 												--ACK address
    SIGNAL ACK_FlagDAT : std_logic := '1';  												--ACK data 
    signal incount : unsigned(3 downto 0) := "0000"; 									--Counter
begin

process (clk)
begin
    if reset = '1' then 
            SDA <= '1';
            SCL <= '1';
            SHIFT_ADD <= "0000000";
            SHIFT_DAT <= "00000000";
            incount <= x"0";
            present <= IDLE;
            I2C_BUSY <= '1';
    else 
    
if (clk'event and clk = '0') then  -- checks if clk is chaning AND the status
    case present is 
        when IDLE => -- sets intial state 
            
             I2C_BUSY <= '1';
             SDA <= '1';
             SCL <= '1'; 

            if enable = '1' then
                I2C_BUSY <= '1';
                SDA <='0'; 
                SHIFT_ADD <= I2C_ADDRESS; 	--Loads the address bits
                SHIFT_DAT <= I2C_DATA; 	 	--loads the Data bits
                SIG_RW <= I2C_RW;   --loads the Read write bit
                present <= ADDR;    
            else 
               present <= IDLE;
            end if;

        when ADDR => --address/RW

            if incount < x"7" then 													--Check variable ''incount' if address/RW are less then 7 
                I2C_BUSY <= '1';             									-- Indicates system is busy 
                SCL <= '0';                  									-- clk signal'0'
                SDA <= SHIFT_ADD(6);         									-- SDA shifted to '6' Which is the MSB
                SHIFT_ADD(6 downto 0) <= SHIFT_ADD(5 downto 0) & 'U' ;	-- SDA shifted to the left and setting the LSB as U 
                incount <= incount + 1;                                 -- Increment counter by 1
                present <= TEMP1;                                       -- SET tempor1 TO PRESENT 

            else if incount = x"7" then --RW 1 bit 
                I2C_BUSY <= '1';    
                SCL <= '0';
                SDA <= SIG_RW;
                incount <= incount + 1;
                present <= TEMP1;

            else if incount = x"8" then --ACK
                I2C_BUSY <= '0';
                SDA<= 'Z';
                SCL<='0';
                present <= S_ACK;     
            
            else if incount < x"11"	then -- count
                I2C_BUSY <= '1';
                SDA<= '1';
                SCL<='0';
                incount <= incount + 1;
                present <= ADDR;

            else 
                SCL <= '0';
                incount <= x"0";

                if SIG_RW = '0' then 		-- Write data '0'
                    present<= W_DATA;   
                else  							--Read Data
                    I2C_BUSY <= '0'; 
                    SDA <= 'Z';      		-- Z in this case is the value of SDA when incount = 8 bits
                    present<= R_DATA;
                end if;
         
              end if;       
            end if;
          end if;
        end if;

        when S_ACK => -- address from slave 
                ack_flagADD <= SDA;
                SCL<='1';
                incount <= incount + 1;
                present<=ADDR;

        when W_DATA => 
            if incount < x"8" then --write 8 bit data
                SCL <= '0';
                SDA <= shift_dat(7);
                shift_dat(7 downto 0) <= shift_dat(6 downto 0) & 'U' ;
                incount <= incount + 1;
                present <= TEMP2;

            else if incount = x"8" then --ACK if count is 8 
                I2C_BUSY <= '0';
                SDA<= 'Z';
                SCL<='0';
                present <= WS_ACK;

             else  --Return back to IDLE state 
                I2C_BUSY <= '1';   
                SCL<='1';
                SDA<= '1';
                incount <= x"0";
                present <= IDLE;
                end if;
            end if;

        when WS_ACK => --ACK bit to the write data
            ack_flagDAT <= SDA;
            incount <= incount + 1;
            present<=W_DATA;
            SCL<='1';
            

        WHEN R_DATA => --Read data
                if incount < x"8" then      --Reads of the slave comand data
                    SCL <= '1';
                    shift_dat(7 downto 0) <= shift_dat(6 downto 0) & SDA;
                    incount <= incount + 1;
                    present <= TEMP3;

                else if incount = x"8" then --ACK
                    I2C_BUSY <= '1';    
                    SCL <= '0';
                    DATA_READ <= shift_dat; --data read is now sent 
                    SDA <= '1'; --ACK
                    incount <= incount + 1;
                    present <= R_ACK;
                else  --return back to IDLE state by setting IDLE to pressent 
                    I2C_BUSY <= '1';
                    SCL<='1';
                    SDA<= '1';
                    incount <= x"0";
                    present <= IDLE;
                    end if;
                end if;

        when R_ACK => 						--ACK read 
            SCL<= '1';
            present <=R_DATA;

													--All the Temp values are used to control the	**SCL**
        when TEMP1 => 
            SCL<= '1';
            present <= ADDR; 

        when TEMP2 => 
            SCL<= '1';
            present <= W_DATA; 

        when TEMP3 =>
            SCL<= '0';
            present <= R_DATA; 
                    
        when others => null; 
        end case;

         end if;

    end if;
   end process; 
   
end arch ; 