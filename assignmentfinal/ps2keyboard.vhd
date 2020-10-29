LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ps2keyboard IS
GENERIC(
    clk_freq              : INTEGER := 50_000_000;
    idle_cycles		: INTEGER := 3000; --60us (>1/2 period ps2_clk) komy uit boek geen idee waarom?
    debounce_counter_size : INTEGER := 8       --set such that (2^size)/clk_freq = 5us (size = 8 for 50MHz)
); 
port(
	clk: in std_logic;
	clk_keyb: in std_logic;
	ps2_data: in std_logic;
	output_to_segment: out std_logic_vector(0 to 6);
	error_led: out std_logic; --debugging
	idle_led: out std_logic --debugging
);
END ps2keyboard;


ARCHITECTURE keyboard_implementation of ps2keyboard is


COMPONENT segment IS
		PORT (
	inputs: in std_logic_vector(3 downto 0);
	output_segments: out std_logic_vector(0 to 6);
	output_led: out std_logic_vector(3 downto 0);
	segment_enable: in std_logic

     );
	END COMPONENT;

 COMPONENT debounce IS
    GENERIC(
      counter_size : INTEGER); --debounce period (in seconds) = 2^counter_size/(clk freq in Hz)
    PORT(
      clk    : IN  STD_LOGIC;  --input clock
      button : IN  STD_LOGIC;  --input signal to be debounced
      result : OUT STD_LOGIC); --debounced signal
  END COMPONENT;

--signals voor segment portmap
signal segment_input: std_logic_vector(3 downto 0);
signal output_leds: std_logic_vector(3 downto 0);
signal turn_on_segment: std_logic := '1';


--signals voor keyboard
signal temp_data: std_logic_vector(10 downto 0);
signal perm_data: std_logic_vector(10 downto 0);
signal error: std_logic;
signal idle: std_logic;


SIGNAL sync_ffs     : STD_LOGIC_VECTOR(1 DOWNTO 0);       --synchronizer flip-flops for PS/2 signals
SIGNAL clk_keyb_deb  : STD_LOGIC;                          --debounced clock signal from PS/2 keyboard
SIGNAL ps2_data_deb : STD_LOGIC;                          --debounced data signal from PS/2 keyboard





begin



PROCESS(clk)
  BEGIN
    IF(clk'EVENT AND clk = '1') THEN  --rising edge of system clock
      sync_ffs(0) <= clk_keyb;           --synchronize PS/2 clock signal
      sync_ffs(1) <= ps2_data;          --synchronize PS/2 data signal
    END IF;
  END PROCESS;

debounce_ps2_clk: debounce
    GENERIC MAP(counter_size => debounce_counter_size)
    PORT MAP(clk => clk, button => sync_ffs(0), result => clk_keyb_deb);
  debounce_ps2_data: debounce
    GENERIC MAP(counter_size => debounce_counter_size)
    PORT MAP(clk => clk, button => sync_ffs(1), result => ps2_data_deb);


outputSegment: segment PORT MAP (inputs => segment_input, output_led => output_leds, segment_enable => turn_on_segment, output_segments => output_to_segment);
	


--check if idle
process(clk)
	variable counter: integer range 0 to idle_cycles;
begin
	if (clk'event and clk='1') then 
		if(ps2_data_deb = '0') then
			idle <= '0';
			counter := 0;
		elsif (clk_keyb_deb = '1') then
			counter := counter + 1;
			if (counter = idle_cycles) then
				idle<='1';
				
			end if;
			
		else
			counter:=0;
		end if;
		idle_led <= idle;
	end if;
end process;



process(clk_keyb_deb)
	variable bit_nummer: integer range 0 to 12;
begin
	if (clk_keyb_deb'event and clk_keyb_deb = '0') then
		if (idle = '1') then
			bit_nummer := 0;
		else 
			temp_data(bit_nummer) <= ps2_data_deb;
			bit_nummer := bit_nummer +1;
			if (bit_nummer = 11) then
				bit_nummer:= 0;
				perm_data <= temp_data;
			end if;
		end if;
	end if;
end process;


process(perm_data)
begin
	IF (perm_data(0)='0' AND perm_data(10)='1' AND (perm_data(1) XOR
 	perm_data(2) XOR perm_data(3) XOR perm_data(4) XOR perm_data(5) 
	XOR perm_data(6) XOR perm_data(7) XOR perm_data(8)
	XOR perm_data(9))='1') THEN
	
		error <= '0';
	ELSE
		error <= '1';
	END IF;
end process;

process (perm_data, error)
begin
	if(error='0') then 
		error_led <= '0';
		turn_on_segment<='1';
		case perm_data(8 downto 1) is 
			when "01000101" => segment_input <= "0000"; --0
			when "00010110" => segment_input <= "0001"; --1
			when "00011110" => segment_input <= "0010"; --2
			when "00100110" => segment_input <= "0011"; --3	
			when "00100101" => segment_input <= "0100"; --4
			when "00101110" => segment_input <= "0101"; --5
			when "00110110" => segment_input <= "0110"; --6
			when "00111101" => segment_input <= "0111"; --7
			when "00111110" => segment_input <= "1000"; --8
			when "01000110" => segment_input <= "1001"; --9
			when "00011100" => segment_input <= "1010"; --A
			when "00110010" => segment_input <= "1011"; --B
			when "00100001" => segment_input <= "1100"; --C
			when "00100011" => segment_input <= "1101"; --D
			when "00100100" => segment_input <= "1110"; --E
			when "00101011" => segment_input <= "1111"; --F
			when others => turn_on_segment<='0';
		end case;
	elsif (error='1') then
	    error_led <= '1';
	    turn_on_segment<='0';
	end if;
end process;


end keyboard_implementation;
