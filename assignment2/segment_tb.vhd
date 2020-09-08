LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-- The entity of your testbench. No ports declaration in this case.
ENTITY segment_tb IS
END ENTITY;



ARCHITECTURE testbench OF segment_tb IS
 -- The component declaration should match your entity.
-- It is very important that the name of the component and the ports
-- (remember direction of ports!) match your entity! Please notice that
-- the code below probably does not work for your design without
-- modifications.
 COMPONENT segment IS
 PORT (
	inputs: in std_logic_vector(3 downto 0);
	output_segments: out std_logic_vector(0 to 6);
	output_led: out std_logic_vector(3 downto 0)
);

 END COMPONENT;


 -- Signal declaration. These signals are used to drive your inputs and
 -- store results (if required).
	signal inputs_tb: std_logic_vector(3 downto 0);
	signal output_segments_tb: std_logic_vector(0 to 6);
	signal output_led_tb: std_logic_vector(3 downto 0);
 BEGIN
 -- A port map is in this case nothing more than a construction to
-- connect your entity ports with your signals.
tb: segment PORT MAP (inputs => inputs_tb, output_segments => output_segments_tb, output_led=> output_led_tb);


PROCESS
BEGIN
 -- Initialize signals.
 inputs_tb <= "0000";
 -- Loop through values.
 FOR I IN 0 TO 15 LOOP
 WAIT FOR 10 ns;
 -- Increment by one.
 inputs_tb <= STD_LOGIC_VECTOR(UNSIGNED(inputs_tb) + 1);
 END LOOP;
 REPORT "Test completed.";
 -- Wait forever.
 WAIT;
END PROCESS;
END ARCHITECTURE; 
