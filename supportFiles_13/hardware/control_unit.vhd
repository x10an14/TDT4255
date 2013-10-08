library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity control_unit is
	port(
		CLK 			: in STD_LOGIC;
		RESET			: in STD_LOGIC;
		proc_enable : in STD_LOGIC;
		OpCode		: in STD_LOGIC_VECTOR (5 downto 0);
		ALUOp			: out ALU_OP_INPUT;
		RegDst		: out STD_LOGIC;
		Branch		: out STD_LOGIC;
		MemRead		: out STD_LOGIC;
		MemtoReg		: out STD_LOGIC;
		MemWrite		: out STD_LOGIC;
		ALUSrc		: out STD_LOGIC;
		RegWrite		: out STD_LOGIC;
		PCWriteEnb	: out STD_LOGIC;
		JumpEnb		: out STD_LOGIC
	);
end control_unit;

architecture Behavioral of control_unit is

	type ALUstate is (ALU_FETCH, ALU_EXE, ALU_STALL, ALU_OFF);
	Signal state : ALUstate;

begin

	ALU_STATE: process(clk)
	begin
		if proc_enable /= '1' then
			state <= ALU_OFF;
		elsif rising_edge(clk) then
			case state is
				when ALU_FETCH =>
					state <= ALU_EXE;
				when ALU_EXE	=>
					if OpCode = "000000" or OpCode = "000100" or OpCode = "001111" then
						state <= ALU_FETCH;
					else
						state <= ALU_STALL;
					end if;
				when ALU_STALL =>
						state <= ALU_FETCH;
				when ALU_OFF	=>
						state <= ALU_FETCH;
			end case;
		end if;
	end process;

	SIGNAL_SETUP: process(OpCode, state)
	begin
		case state is
			when ALU_FETCH =>
				PCWriteEnb	<= '1';
				RegWrite 	<= '0';
				Branch		<= '0';
				MemRead		<= '0';
				MemtoReg		<= '0';
				MemWrite		<= '0';
				JumpEnb		<= '0';
			when ALU_EXE =>
				PCWriteEnb	<= '0'; --will be updated during execute-phase, will have new value on next fetch phase
				MemWrite		<= '0'; --nothing should be written to memory during exe phase
				RegDst		<= '0'; -- 0 for every instruction type except R-type
				Branch		<= '0'; -- 0 for every instruction type except branch-type
				MemRead		<= '0'; -- 0 for every instruction type except lw-type
				MemWrite		<= '0'; -- 0 for every instruction type except sw-type
				ALUSrc 		<= '0'; -- 0 for every inst except for lw & sw type
				MemtoReg		<= '0'; -- 1 for lw-type inst, 0 for R-type, don't-care for rest
				RegWrite		<= '0'; -- 1 for lw- & R-type instructions. The former one sets RW to 1 during stall CC
				JumpEnb		<= '0'; -- 0 for all except jump instructions, aka "000010" OpCode

				-- Default ALUOp values
				ALUOp.Op0	<= '0';
				ALUOp.Op1	<= '0';
				ALUOp.Op2	<= '0';
				case OpCode is
					when "001111" =>	--load immediate instr
						ALUSrc 		<= '1';
						ALUOp.Op0	<= '1';
						RegWrite		<= '1';
					when "000000" =>	--R-instruction (0 Hex - ALU operations probably)
						RegDst		<= '1';
						RegWrite		<= '1';
					when "000100" =>	--Branch opcode (4 Hex - BEQ Opcode  - I-instruction format)
						Branch		<= '1';
						ALUOp.Op1	<= '1';
						ALUOp.Op2	<= '1';
					when "100011" =>	--Load word opcode (23 Hex - LW Opcode - I-instruction format)
						MemRead		<= '1';
						ALUSrc		<= '1';
						MemtoReg		<= '1';
						ALUOp.Op0	<= '1';
					when "101011" =>	--Store word (2B hex - SW Opcode - I-instruction format)
						ALUSrc		<= '1';
						ALUOp.Op0	<= '1';
					when "000010" => --Jump (2 Hex - Jump Opcode - J-instruction format)
						JumpEnb		<= '1';
					when others =>
				end case;
			when ALU_STALL =>
				MemRead		<= '0';
				MemtoReg		<= '0';
				MemWrite		<= '0';
				RegWrite		<= '0';
				case OpCode is
					when "100011" =>	--Load word opcode (23 Hex - LW Opcode - I-instruction format)
							RegWrite		<= '1'; --
							MemtoReg		<= '1';
							MemRead		<= '1';
					when "101011" =>	--Store word (2B hex - SW Opcode - I-instruction format)
							MemWrite	 <= '1';
					when "001111" =>	--Load immediate. (Implemented as Load Upper Immediate - LUI Opcode - Hex(f) - I-instruction format)
					when others =>
				end case;
			 when ALU_OFF =>
				RegDst		<= '0';
				Branch		<= '0';
				MemRead		<= '0';
				MemtoReg		<= '0';
				ALUOp.Op0	<= '0';
				ALUOp.Op1	<= '0';
				ALUOp.Op2	<= '0';
				MemWrite		<= '0';
				ALUSrc		<= '0';
				RegWrite		<= '0';
				PCWriteEnb	<= '0';
		 end case;
	end process;

end Behavioral;
