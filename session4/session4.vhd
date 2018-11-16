library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity session4 is
  port( clk_25, vga_vs 	: in std_logic;
		btn, sw			: in std_logic_vector(3 downto 0);
		led 			: out std_logic_vector(3 downto 0);
		wr_memo			: out std_logic;
		data 			: out std_logic_vector(2 downto 0);
		adr_memo		    : out std_logic_vector(16 downto 0) );
end session4;


architecture lecture of session4 is
  
  -- Unnit Control States
  type state_main is ( ini, w_b0_b1, ld_count, temp1, wr_1, end_1, temp2, wr_2, end_2, w_b0, check_b1, w_vs, count, temp3, wr_3, end_3, temp4, wr_4, end_4,w_vs2);  -- Unit Control States
  type leds_Status is (off, l_up, l_down);
  type state_memo is (s0, s1, s2, s3, s4, s5, s6);
  -- Led status
  signal state : state_main;
  signal leds : leds_Status;
  signal st_write : state_memo;
  -- Control signals for the up-dawn counters with parallel load.
  signal ld, ce, up : std_logic;
  -- Internal signals of y_position
  signal ymin, ymax, ymin_o : std_logic_vector(9 downto 0);  --new and old square coordinates.
  signal xmin, xMAX : std_logic_vector(9 downto 0); -- x coordinates. in this example: fixed.
  
  -- Temporary registers for memo operation
  signal address_t : std_logic_vector(16 downto 0);
  signal x_t, y_t  : std_logic_vector(9 downto 0);
  signal i, j : integer range 0 to 8;  -- Counting variables to know which memo cell is written.
  signal data_t: std_logic_vector(2 downto 0);
  
  -- Intput and output signals of control unit for memo operation
  signal start, done: std_logic;
  
  -- Constant colors
  CONSTANT color_object : STD_LOGIC_VECTOR(2 downto 0) := "001"; -- color Blue
  CONSTANT color_background : STD_LOGIC_VECTOR(2 downto 0) := "111"; -- color White
  
begin
-- Xsignals never change. Better be a constant:
  xmin <= "0100000000"; --256
  xMAX <= "0100001111"; --256+15
  
  
  
-- Control Unit for memo operation:
-- All signals updated inside if (clk_25'event and clk_25='1') are output of registers!!
	process(clk_25)
	Begin
		if (clk_25'event and clk_25='1') then
		case st_write is
			when s0  => if start = '1' then st_write <= s1; end if;
			when s1 => st_write <= s2;
				j <= 0; i <= 0;
				-- adress = y(8:1) concatenated with x(9:1)
				address_t(16 downto 9) <= y_t(8 downto 1);
				address_t(8 downto 0) <= x_t(9 downto 1);
				data <= data_t;
			-- In s2 wr_memo should be active and data is stored in the cell address_t.
			when s2 => st_write <= s3; 
			    i <= i+1;  -- i loop: to write a square row.
			    
			when s3 => if (i<8) then st_write <= s2; address_t <= address_t + 1; 
						else st_write <= s4; end if;
			when s4 => st_write <= s5;
				i <= 0; j <= j+1;  -- Now we are writting the following square row
			when s5 => if (j<8) then st_write <= s2; 
						address_t(16 downto 9) <= address_t(16 downto 9) +1;
						address_t(8 downto 0) <= x_t(9 downto 1);
						else st_write <= s6; end if;
					--address_t(16 downto 9) <= y_t(8 downto 1);
					--address_t(8 downto 0) <= x_t(9 downto 1);
			when s6 => st_write <= s0;
		End Case;
		End If;
	End process;
	
-- Combinationals outputs of the control unit to operate with memory:
wr_memo <= '1' when st_write = s2 else '0';
done <= '1' when st_write = s6 else '0';


		adr_memo <= address_t;
	
  			
-- Main Control Unit.
  process(clk_25) 
  begin
	if (clk_25'event and clk_25='1') then
		case state is
			-----------------------------------------------------------------------------
			-- right part of the state diagram
			when ini  => state <= w_b0_b1;
						 leds <= off;
						 up <= '1';
						 y_t <= "0000000000";
			when w_b0_b1  => if btn(0) ='1' then state <= ld_count;
							 elsif btn(1) = '1' then state <= check_b1;
							 end if;
							 
			when ld_count  => state <= temp1;
			-------------------------------Erasing old square
			when temp1 => state <= wr_1;
			-- Writting the information that is passed as parameter in temporal registers.
				x_t <= xmin; y_t <= ymin_o; 
				data_t <= color_background;
			when wr_1 => state <= end_1;
			when end_1 => if done = '1' then state <= temp2; end if;
			-------------------------------Plotting new square
			when temp2 => state <= wr_2;
			-- Writting the information that is passed as parameter in temporal registers.
				x_t <= xmin; y_t <= ymin; 
				data_t <= color_object;
			when wr_2 => state <= end_2;
			when end_2 => if done = '1' then state <= w_b0; end if;
						--- Plot done. Old can be updated
						ymin_o <= ymin;
						
			when w_b0 => if btn(0) = '0' then state <= w_b0_b1;
						end if;
			--------------------------------------------------------------------------------			
			--Left part of the state diagram
			when check_b1 => if btn(1) = '1' then state <= w_vs;
							else state <= ini;
							end if;
			when w_vs => if vga_vs = '0' then state <= count; end if;
			when count => state <= temp3;
						if (up = '1') then leds <= l_up; else leds <= l_down;
						end if;
			-------------------------------Erasing old square
			when temp3 => state <= wr_3;
			-- Writting the information that is passed as parameter in temporal registers.
				x_t <= xmin; y_t <= ymin_o; 
				data_t <= color_background;
			when wr_3 => state <= end_3;
			when end_3 => if done = '1' then state <= temp4; end if;
			-------------------------------Plotting new square
			when temp4 => state <= wr_4;
			-- Writting the information that is passed as parameter in temporal registers.
				x_t <= xmin; y_t <= ymin; 
				data_t <= color_object;
			when wr_4 => state <= end_4;
			when end_4 => if done = '1' then state <= w_vs2; end if;
							--- Plot done. Old can be updated
						ymin_o <= ymin;
		    ----------------------------End Plot. State diagram resumes. 
			when w_vs2 => if vga_vs = '1' then state <= check_b1;
						end if;
						--- update of up	
						if (up = '1') and (ymax >= 480) then up <= '0';
						elsif (up='0') and (ymin = 0) then up <='1';
						end if;
			
		end case;
	end if;
end process;

-- Combinational Outputs of the control unit:
ld <= '1' when state = ld_count else '0';
ce <= '1' when state = count else '0';
start <= '1' when state = temp1 or state = temp2 or state = temp3 or state = temp4 else '0';

-- leds status
led <= "0000" when leds = off else
		"1100" when leds = l_up else "0011";
-- Counters for ypos_min and ypos_MAX
process(clk_25, btn(3))
begin
	if (btn(3) = '1') then ymin <= "0000000000";ymax <= "0000001111";
	elsif (clk_25'event and clk_25='1') then
	    if ld = '1' then
			ymin <= "0" & sw & "00000";
			ymax <= "0" & sw & "01111";
		elsif ce = '1' then
			if up = '1' then
				ymax <= ymax +1;
				ymin <= ymin +1;
			else
				ymin <= ymin -1;
				ymax <= ymax -1;
			end if;
		end if;
	end if;
end process;

end lecture;