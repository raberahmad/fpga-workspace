LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-- The entity of your testbench. No ports declaration in this case.
ENTITY calculations_tb IS
END ENTITY;



ARCHITECTURE testbench OF calculations_tb IS
 -- The component declaration should match your entity.
-- It is very important that the name of the component and the ports
-- (remember direction of ports!) match your entity! Please notice that
-- the code below probably does not work for your design without
-- modifications.
 COMPONENT calculations IS
 PORT (
	inputs_first: in std_logic_vector(3 downto 0);
	segment_first: out std_logic_vector(0 to 6);
	status_leds_first: out std_logic_vector(3 downto 0);

	inputs_second: in std_logic_vector(3 downto 0);
	segment_second: out std_logic_vector(0 to 6);
	status_leds_second: out std_logic_vector(3 downto 0);
	
  	output_segment_left:	OUT std_logic_vector(0 to 6);
  	output_segment_right:	OUT std_logic_vector(0 to 6);

  	calc_button:	IN std_logic
);

 END COMPONENT;


 -- Signal declaration. These signals are used to drive your inputs and
 -- store results (if required).

	signal inputs_first_tb: std_logic_vector(3 downto 0);
	signal segment_first_tb: std_logic_vector(0 to 6);
	signal status_leds_first_tb: std_logic_vector(3 downto 0);

	signal inputs_second_tb: std_logic_vector(3 downto 0);
	signal segment_second_tb: std_logic_vector(0 to 6);
	signal status_leds_second_tb: std_logic_vector(3 downto 0);
	
  	signal output_segment_left_tb:	std_logic_vector(0 to 6);
  	signal output_segment_right_tb:	std_logic_vector(0 to 6);

  	signal calc_button_tb:	std_logic;
 BEGIN
 -- A port map is in this case nothing more than a construction to
-- connect your entity ports with your signals.
tb: calculations PORT MAP (
inputs_first => inputs_first_tb, 
segment_first => segment_first_tb, 
status_leds_first=>status_leds_first_tb,
inputs_second=>inputs_second_tb,
segment_second=>segment_second_tb,
status_leds_second=>status_leds_second_tb,
output_segment_left=>output_segment_left_tb,
output_segment_right=>output_segment_right_tb,
calc_button=>calc_button_tb);


PROCESS
BEGIN
 -- Initialize signals.
 inputs_first_tb <= "0000";
 inputs_second_tb<= "0000";
calc_button_tb<= '0';
 -- Loop through values.


 FOR I IN 0 TO 15 LOOP
 WAIT FOR 10 ns;
 -- Increment by one.
 inputs_first_tb <= STD_LOGIC_VECTOR(UNSIGNED(inputs_first_tb) + 1);
 calc_button_tb<='1';

 wait for 10 ns;
calc_button_tb<='0';
 END LOOP;


 FOR I IN 0 TO 15 LOOP
 WAIT FOR 10 ns;
 -- Increment by one.
 inputs_second_tb <= STD_LOGIC_VECTOR(UNSIGNED(inputs_second_tb) + 1);
 calc_button_tb<='1';

 wait for 10 ns;
calc_button_tb<='0';
 END LOOP;

 REPORT "Test completed.";
 -- Wait forever.
 WAIT;
END PROCESS;
END ARCHITECTURE; 

