library ieee;
use ieee.std_logic_1164.all;

entity component_one is
port (
 inputs: in std_logic_vector(3 downto 0);
 outputs: out std_logic_vector(6 downto 0)
);
end component_one;

architecture implementation of component_one is
begin
 outputs(0) <= NOT(inputs(0));
 outputs(1) <= NOT(inputs(1));
 outputs(2) <= NOT(inputs(0)) or NOT(inputs(1));
 outputs(3) <= NOT(inputs(0)) and NOT(inputs(1));
 outputs(4) <= NOT(inputs(0)) and NOT(inputs(1)) and NOT(inputs(2)) and NOT(inputs(3));
 outputs(5) <= NOT(inputs(0)) or NOT(inputs(1)) or NOT(inputs(2)) or NOT(inputs(3));
 outputs(6) <= NOT(NOT(inputs(0)) or NOT(inputs(1)) or NOT(inputs(2)) or NOT(inputs(3)));
end implementation;