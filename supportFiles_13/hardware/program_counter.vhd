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
			PC_OUT	: out STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0) := (others => '1')
	);
end program_counter;

architecture Behavioral of program_counter is
	type PcClkState is (CLK_RISED, CLK_FELL);
	Signal state : PcClkState := CLK_FELL;
begin
	-- Set output to reg
--	PC_OUT <= REG;

	process(CLK, PC_WR_EN) is
	begin
		-- Here's were we decide what input (if any) to utilize
		if rising_edge(clk) then
		 state <= CLK_RISED;
	elsif falling_edge(clk) then
		 state <= CLK_FELL;
	end if;

	if (PC_WR_EN = '1' and state = CLK_RISED and not falling_edge(clk)) then
		 PC_OUT <= PC_IN;
	end if;

		if RESET = '1' then
			PC_OUT <= X"00000000"; --Hardcoded reset value
		end if;
	end process;

end Behavioral;
