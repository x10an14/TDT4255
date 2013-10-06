library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;


entity program_counter is
	port(
			CLK 		: in 	STD_LOGIC;
			RESET		: in 	STD_LOGIC;
			PC_WR_EN	: in 	STD_LOGIC; --ProgramCounter Write Enable pin
			PC_IN		: in 	STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0);
			PC_OUT	: out STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0)
	);
end program_counter;

architecture Behavioral of program_counter is
	signal REG : STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0) := (others => '0');

begin
	-- Set output to reg
   PC_OUT <= REG;
   
	process(CLK) is
	begin
		-- Here's were we decide what input (if any) to utilize
		if  PC_WR_EN = '1' and rising_edge(clk) then
			REG <= PC_IN;
		elsif RESET = '1' then
			REG <= X"00000000"; --Hardcoded reset value
		end if;
	end process;
   
end Behavioral;
