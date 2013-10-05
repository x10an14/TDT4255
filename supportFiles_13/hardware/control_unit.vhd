library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity control_unit is
	port(
		CLK 			: in STD_LOGIC;
		RESET			: in STD_LOGIC;
		OpCode		: in STD_LOGIC_VECTOR (5 downto 0);
		ALUOp			: out ALU_OP_INPUT;
		RegDst		: out STD_LOGIC;
		Branch		: out STD_LOGIC;
		MemRead		: out STD_LOGIC;
		MemtoReg		: out STD_LOGIC;
		MemWrite		: out STD_LOGIC;
		ALUSrc		: out STD_LOGIC;
		RegWrite		: out STD_LOGIC;
		PCWriteEnb	: out STD_LOGIC
--		SRWriteEnb	: out STD_LOGIC -- what is this?
		--control write enable for register file is the same as RegWrite?
	);
end control_unit;

architecture Behavioral of control_unit is

	type ALUstate is (ALU_FETCH, ALU_EXE, ALU_STALL);
	Signal state : ALUstate;

begin

	ALU_STATE_MACHINE: process(CLK, RESET, OpCode)

	begin
		if rising_edge(CLK) then
			
			if reset = '1' then
				state 		<= ALU_STALL; -- next state after reset is set to 0 after being = 1 is alu_fetch
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
			else
			-- the following is transference from fetch state to execute-state
				case state is
					when ALU_FETCH =>
						state 		<= ALU_EXE;
						PCWriteEnb	<= '1'; --will be updated during execute-phase, will have new value on next fetch phase
						MemWrite		<= '0'; --nothing should be written to memory during exe phase
						RegDst		<= '0'; -- 0 for every instruction type except R-type
						Branch		<= '0'; -- 0 for every instruction type except branch-type
						MemRead		<= '0'; -- 0 for every instruction type except lw-type
						MemWrite		<= '0'; -- 0 for every instruction type except sw-type
						ALUSrc 		<= '0'; -- 0 for every inst except for lw & sw type
						MemtoReg		<= '0'; -- 1 for lw-type inst, 0 for R-type, don't-care for rest
						RegWrite		<= '0'; -- 1 for lw- & R-type instructions. The former one sets RW to 1 during stall CC
						case OpCode is
							when "000100" =>	--addi-instruction
								ALUSrc 		<= '1';
								ALUOp.Op0	<= '0';
								ALUOp.Op1	<= '0';
								ALUOp.Op2	<= '0';
								RegWrite		<= '1';
							when "000000" =>	--R-instruction (0 Hex - ALU operations probably)
								RegDst		<= '1';
								ALUOp.Op0	<= '0';
								ALUOp.Op1	<= '1';
								ALUOp.Op2	<= '0';
								RegWrite		<= '1';
							when "000100" =>	--Branch opcode (4 Hex - BEQ Opcode  - I-instruction format)
								Branch		<= '1';
								ALUOp.Op0	<= '1';
								ALUOp.Op1	<= '0';
								ALUOp.Op2	<= '0';
							when "100011" =>	--Load word opcode (23 Hex - LW Opcode - I-instruction format)
								MemRead		<= '1';
								MemtoReg		<= '1';
								ALUOp.Op0	<= '0';
								ALUOp.Op1	<= '0';
								ALUOp.Op2	<= '0';
								ALUSrc		<= '1';
							when "101011" =>	--Store word (2B hex - SW Opcode - I-instruction format)
								ALUOp.Op0	<= '0';
								ALUOp.Op1	<= '0';
								ALUOp.Op2	<= '0';
								ALUSrc		<= '1';
								RegWrite		<= '0';
							when "001111" =>	--Load immediate. (Implemented as Load Upper Immediate - LUI Opcode - Hex(f) - I-instruction format)
								ALUOp.Op0	<= '1';
								ALUOp.Op1	<= '1';
								ALUOp.Op2	<= '0';
								ALUSrc		<= '1';
								RegWrite		<= '1';
							when "000010" =>	--Jump (2 Hex - J Opcode - J-instruction format)
								ALUOp.Op0	<= '0';
								ALUOp.Op1	<= '0';
								ALUOp.Op2	<= '0';
								RegWrite		<= '0';
								Branch			<= '1';
								PCWriteEnb	<= '0';
							when others =>
						end case;
					-- following is transference from execute-state to either fetch-state or stall-state
					when ALU_EXE =>
						state 		<= ALU_FETCH; 
						MemRead		<= '0';
						MemtoReg		<= '0';
						MemWrite		<= '0'; -- 
						RegWrite		<= '0'; -- 
						PCWriteEnb	<= '0'; -- was updated during execute state, will be sat to 0 until next execute-state
						case OpCode is
							when "000000" =>	--R-instruction (0 Hex - ALU operations probably)
							when "000100" =>	--Branch opcode (4 Hex - BEQ Opcode  - I-instruction format)
							when "100011" =>	--Load word opcode (23 Hex - LW Opcode - I-instruction format)
							when "101011" =>	--Store word (2B hex - SW Opcode - I-instruction format)
							when "001111" =>	--Load immediate. (Implemented as Load Upper Immediate - LUI Opcode - Hex(f) - I-instruction format)
							when "000010" =>	--Jump (2 Hex - J Opcode - J-instruction format)
							when others =>
						end case;
					when ALU_STALL =>
						state 		<= ALU_FETCH;
						PCWriteEnb	<= '0';
						RegWrite 	<= '0';  
						Branch		<= '0';
						MemRead		<= '0';
						MemtoReg		<= '0';
						MemWrite		<= '0';
						
				end case;
			end if;
		end if;
	end process;
end Behavioral;
