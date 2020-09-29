LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-- The entity of your testbench. No ports declaration in this case.
ENTITY clock_tb IS
END ENTITY;



ARCHITECTURE testbench OF clock_tb IS
 -- The component declaration should match your entity.
-- It is very important that the name of the component and the ports
-- (remember direction of ports!) match your entity! Please notice that
-- the code below probably does not work for your design without
-- modifications.
 COMPONENT clock IS
 PORT (
	output_segments: out std_logic_vector(0 to 6);
	led_out: out std_logic;
	clk: in std_logic
);

 END COMPONENT;


 -- Signal declaration. These signals are used to drive your inputs and
 -- store results (if required).
	signal output_segments_tb: std_logic_vector(0 to 6);
	signal led_out_tb: std_logic;
	signal clk_tb: std_logic;
	
 BEGIN
 -- A port map is in this case nothing more than a construction to
-- connect your entity ports with your signals.
tb: clock PORT MAP (output_segments => output_segments_tb, led_out => led_out_tb, clk => clk_tb);


PROCESS
BEGIN
 -- Initialize signals.

 -- Loop through values.


 FOR I IN 0 TO 512 LOOP
 WAIT FOR 10 ns;
 -- Increment by one.
 	if(clk_tb = '0') THEN
			clk_tb <= '1';
		ELSE
			clk_tb <= '0';
		END IF;

 END LOOP;


 REPORT "Test completed.";
 -- Wait forever.
 WAIT;
END PROCESS;
END ARCHITECTURE; 


