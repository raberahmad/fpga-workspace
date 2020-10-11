LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY finitestate IS
PORT(
  seven_segment_out: OUT std_logic_vector(0 to 6);
  clk:		IN std_logic;
  led0:	        OUT std_logic;
  start_button: IN STD_LOGIC;
  reset_button: IN STD_LOGIC;
  state_debug: OUT std_logic_vector(2 downto 0)

);
END finitestate;


architecture implementation of finitestate is

COMPONENT segment IS
		PORT (
	inputs: in std_logic_vector(3 downto 0);
	output_segments: out std_logic_vector(0 to 6);
	output_led: out std_logic_vector(3 downto 0);
	segment_enable: in std_logic

     );
	END COMPONENT;


Type state is (IDLE, COUNTER_STATE, END_STATE);
SIGNAL present_state, next_state: state;


signal segment_input: std_logic_vector(3 downto 0);
signal status_leds: std_logic_vector(3 downto 0);
signal turn_on_segment: std_logic := '0';
signal end_of_count: std_logic:='0';


begin

outputSegment: segment PORT MAP (inputs => segment_input, output_led => status_leds, segment_enable => turn_on_segment, output_segments => seven_segment_out);
state_debug <= STD_LOGIC_VECTOR(TO_UNSIGNED(state'POS(present_state),3));
process(clk, reset_button)

begin
	if start_button= '1' then 
		present_state<=IDLE;
	elsif (clk'event AND clk='1') then
		present_state<=next_state;
	end if;

end process;



PROCESS(start_button, present_state)
	BEGIN
		CASE present_state IS
			WHEN IDLE => 
				IF start_button= '1' THEN
					next_state <= COUNTER_STATE;
				ELSE
					next_state <= IDLE;
				END IF;
			WHEN COUNTER_STATE => 
				IF (end_of_count = '1') THEN
					next_state <= END_STATE;
				ELSE
					next_state <= COUNTER_STATE;
				END IF;	
			wHEN END_STATE => 
				next_state <= END_STATE;
			END CASE;
END PROCESS;


PROCESS(clk, present_state)
	variable var_clk : INTEGER RANGE 0 to 50000001;
	variable var_counter : integer RANGE 0 TO 11;
	begin
	if (rising_edge(clk)) then
		IF (present_state = IDLE) then
			var_clk := var_clk +1;
			if (var_clk = 12500000) then
				led0<='1';
			end if;
			if (var_clk = 50000000) then
				var_clk :=0;
				led0<='0';
			end if;
		end if;

		if(present_state = COUNTER_STATE) then
			var_clk := var_clk +1;
			turn_on_segment <= '1';
			end_of_count <= '1';
			led0 <= '0';
			if (var_clk = 50000000) then
				var_counter := var_counter +1;
				if (var_counter = 10) then
					var_counter:= 0;
					end_of_count<='1';
					turn_on_segment <= '0';
				end if;
				var_clk := 0;
			end if;	
		segment_input <= STD_LOGIC_VECTOR(TO_UNSIGNED(var_counter, segment_input'length));	
		end if;


		if(present_state = END_STATE) then
			var_clk := var_clk +1;
			if (var_clk = 18750000) then
				led0<='1';
			end if;
			if (var_clk = 25000000) then
				var_clk :=0;
				led0<='0';
			end if;
		end if;
	end if;

end process;






end implementation;
