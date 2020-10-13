LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-- The entity of your testbench. No ports declaration in this case.
ENTITY finitestate_tb IS
END ENTITY;



ARCHITECTURE testbench OF finitestate_tb IS
 -- The component declaration should match your entity.
-- It is very important that the name of the component and the ports
-- (remember direction of ports!) match your entity! Please notice that
-- the code below probably does not work for your design without
-- modifications.
 COMPONENT finitestate IS
 PORT (
	seven_segment_out: OUT std_logic_vector(0 to 6);
  	clk:		IN std_logic;
  	led0:	        OUT std_logic;
  	start_button: IN STD_LOGIC;
  	reset_button: IN STD_LOGIC;
  	state_debug: OUT std_logic_vector(2 downto 0)
);

 END COMPONENT;


 -- Signal declaration. These signals are used to drive your inputs and
 -- store results (if required).
	signal seven_segment_out_tb: std_logic_vector(0 to 6);
  	signal clk_tb: std_logic;
  	signal led0_tb: std_logic;
  	signal start_button_tb: STD_LOGIC;
  	signal reset_button_tb: STD_LOGIC;
  	signal state_debug_tb: std_logic_vector(2 downto 0);
	
 BEGIN
 -- A port map is in this case nothing more than a construction to
-- connect your entity ports with your signals.
tb: finitestate PORT MAP (seven_segment_out => seven_segment_out_tb, clk => clk_tb, led0 => led0_tb, start_button => start_button_tb, reset_button => reset_button_tb, state_debug => state_debug_tb);


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


 FOR I IN 0 TO 512 LOOP
 WAIT FOR 10 ns;
 -- Increment by one.
 	if(clk_tb = '0') THEN
		if I = 10 then
		start_button_tb<= '0';
		elsif I = 500 then 
			reset_button_tb<='0';
		end if;
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



