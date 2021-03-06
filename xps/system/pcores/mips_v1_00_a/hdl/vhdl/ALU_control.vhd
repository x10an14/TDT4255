library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity ALU_control is
	port(
		CLK		: in STD_LOGIC;
		RESET		: in STD_LOGIC;
		FUNC		: in STD_LOGIC_VECTOR (5 downto 0);
		ALUOp		: in ALU_OP_INPUT;
		ALU_FUNC	: out ALU_INPUT
	);
end ALU_control;

architecture Behavioral of ALU_control is
	 constant R_Instr		: ALU_OP_INPUT := (others => '0');
	 constant BEQ_Instr	: ALU_OP_INPUT := (Op0 => '0', others => '1');
	 constant LwSw_Instr	: ALU_OP_INPUT := (Op0 => '1', others => '0');
	 
begin
	ALU_LOGIC: process(ALUOp, FUNC)
	begin
		ALU_FUNC.Op0 <= '0';
		ALU_FUNC.Op1 <= '0';
		ALU_FUNC.Op2 <= '0';
		ALU_FUNC.Op3 <= '0';
		if (ALUOp = R_Instr) then -- r instructions
			case FUNC is
				when "100000" => --add OpCode
					ALU_FUNC.Op1 <= '1';
				when "100010" =>	--subtract OpCode
					ALU_FUNC.Op1 <= '1';
					ALU_FUNC.Op2 <= '1';
				when "101010" =>	--slt OpCode
					ALU_FUNC.Op0 <= '1';
					ALU_FUNC.Op1 <= '1';
					ALU_FUNC.Op2 <= '1';
				when "100100" =>	--and OpCode
				when "100101" =>	--or OpCode
					ALU_FUNC.Op0 <= '1';
				when others =>
			end case;
		elsif (ALUOp = BEQ_Instr) then -- beq, do subtract function
			ALU_FUNC.Op1 <= '1';
			ALU_FUNC.Op2 <= '1';
		elsif (ALUOp = LwSw_Instr) then -- ls, sw, load imm, do add function
			ALU_FUNC.Op1 <= '1';
		else
		end if;
	end process;

end Behavioral;
