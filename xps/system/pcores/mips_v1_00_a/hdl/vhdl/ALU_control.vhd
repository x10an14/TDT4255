 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity ALU_control is
	port(
		CLK			: in STD_LOGIC;
		RESET		: in STD_LOGIC;
		FUNC		: in STD_LOGIC_VECTOR (5 downto 0);
		ALUOp		: in ALU_OP_INPUT;
		ALU_FUNC	: out ALU_INPUT
	);
end ALU_control;

architecture Behavioral of ALU_control is
	
begin
	ALU_LOGIC: process(ALUOp)
	begin
		if (ALUOp.Op1 = '0' and ALUOp.Op0 = '0' and ALUOp.Op2 = '0') then		-- if ALUOp == "000" AKA LW, SW, LDI
			ALU_FUNC.Op0 <= '0';
			ALU_FUNC.Op1 <= '1';
			ALU_FUNC.Op2 <= '0';
			ALU_FUNC.Op3 <= '0';

--			ALU_FUNC <= X"2";
--		elsif (ALUOp = ALU_OP_ONE) then	-- if ALUOp == "001" AKA BEQ
--			ALU_FUNC <= X"6";
--		elsif (ALUOP = ALU_OP_TWO) then	-- if ALUOp == "010" AKA function dependent
--			case (FUNC) is
--				when O"40" =>	-- ADD
--					ALU_FUNC <= ALU_OP_ADD;
--				when O"42" =>	-- SUB
--					ALU_FUNC <= ALU_OP_SUB;
--				when O"52" =>	-- SLT
--					ALU_FUNC <= ALU_OP_SLT;
--				when O"44" =>	-- AND
--					ALU_FUNC <= ALU_OP_AND;
--				when O"45" =>	-- OR
--					ALU_FUNC <= ALU_OP_OR;
--			end case;
		end if;
	end process;
end Behavioral; 
