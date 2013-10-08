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
			PC_OUT		: out STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0) := (others => '1')
	);
end program_counter;

architecture Behavioral of program_counter is
	type PcClkState is (CLK_HIGH, CLK_LOW);
	Signal state : PcClkState := CLK_LOW;

begin
	process(CLK, PC_WR_EN)
	begin
	-- Here's were we decide what input (if any) to utilize
	if rising_edge(CLK) then
		state <= CLK_HIGH;
	elsif falling_edge(CLK) then
		state <= CLK_LOW;
	else
	end if;

	if (PC_WR_EN = '1' and state = CLK_HIGH and not falling_edge(CLK)) then
		PC_OUT <= PC_IN;
	end if;

	if RESET = '1' then
		PC_OUT <= X"00000000"; --Hardcoded reset value
	end if;
	end process;

end Behavioral;
