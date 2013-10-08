library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity processor is
	port(
		clk					: in STD_LOGIC;
		reset					: in STD_LOGIC;
		processor_enable	: in STD_LOGIC;
		imem_data_in		: in STD_LOGIC_VECTOR (IDATA_BUS - 1 downto 0);	-- implemented
		dmem_data_in		: in STD_LOGIC_VECTOR (DDATA_BUS - 1 downto 0);	-- implemented
		imem_address		: out STD_LOGIC_VECTOR (IADDR_BUS - 1 downto 0);	-- implemented
		dmem_address		: out STD_LOGIC_VECTOR (DADDR_BUS - 1 downto 0);	-- implemented
		dmem_address_wr	: out STD_LOGIC_VECTOR (DADDR_BUS - 1 downto 0);	-- implemented
		dmem_data_out		: out STD_LOGIC_VECTOR (DDATA_BUS - 1 downto 0);	-- implemented
		dmem_write_enable	: out STD_LOGIC -- implemented
	);
end processor;

architecture behave of processor is

	--component control unit
		component control_unit is
				port(
							CLK			: IN	std_logic;
							RESET		: IN	std_logic;
							proc_enable : IN std_logic;
							OpCode		: IN	std_logic_vector(5 downto 0);
							ALUOp		: OUT	ALU_OP_INPUT;
							RegDst		: OUT	std_logic;
							Branch		: OUT	std_logic;
							MemRead		: OUT	std_logic;
							MemtoReg	: OUT	std_logic;
							MemWrite	: OUT	std_logic;
							ALUSrc		: OUT	std_logic;
							RegWrite		: OUT	std_logic;
							PCWriteEnb	: OUT	std_logic;
							JumpEnb		: out STD_LOGIC
					);
			end component control_unit;

	--component ALU_control
		component ALU_control is
				port(
					CLK		: in STD_LOGIC;
					RESET		: in STD_LOGIC;
					FUNC		: in STD_LOGIC_VECTOR (5 downto 0);
					ALUOp		: in ALU_OP_INPUT;
					ALU_FUNC	: out ALU_INPUT
				);
		end component ALU_control;

	--component ALU
		component ALU is
				generic (N: NATURAL);
				port(X			: in STD_LOGIC_VECTOR(N-1 downto 0);
						Y			: in STD_LOGIC_VECTOR(N-1 downto 0);
						ALU_IN	: in ALU_INPUT;
						R			: out STD_LOGIC_VECTOR(N-1 downto 0);
						FLAGS		: out ALU_FLAGS
				);
		end component ALU;

	--component PC
		component program_counter is
				port(CLK		: in	STD_LOGIC;
						RESET		: in	STD_LOGIC;
						PC_WR_EN	: in	STD_LOGIC;
						PC_IN		: in	STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0);
						PC_OUT	: out	STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0)
				);
		end component program_counter;

	--component sign extender
		component sign_extender is
				generic (IN_WIDTH, OUT_WIDTH: NATURAL);
				port(	input	: in STD_LOGIC_VECTOR ( IN_WIDTH-1 downto 0);
						output	: out STD_LOGIC_VECTOR (OUT_WIDTH-1 downto 0)
				);
		end component sign_extender;

	--component register memory
		component register_file is
				port(
						CLK			:	in	STD_LOGIC;
						RESET			:	in	STD_LOGIC;
						RW				:	in	STD_LOGIC;
						RS_ADDR		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0);
						RT_ADDR		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0);
						RD_ADDR		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0);
						WRITE_DATA	:	in	STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0);
						RS				:	out STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0);
						RT				:	out STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0)
				);
			end component register_file;

	--###### SIGNALS DEFINITIONS ######
--			ProgramCounter related signals:
			signal alu_pc_output, branching_alu_output, PC_input, PC_output: STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0);
			signal pc_increment_signal					: std_logic_vector (0 to IADDR_BUS-1);
			signal pc_write_enable							: STD_LOGIC := '0';
			signal alu_add_input_signal					: ALU_INPUT;
			signal pc_alu_flags, branching_alu_flags	: ALU_FLAGS;

--			ControlUnit related signals
			signal RegDst, RegWrite, MemRead, MemWrite, ALUOp0, ALUOp1, Branch : STD_LOGIC;
			signal MemtoReg									: std_logic := '0';
			signal ALUSrc										: std_logic := '1';
			signal JmpEnable									: STD_LOGIC := '0';
			signal Branching_Mux_Output									: STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0) := (others => '0');

--			Main ALU related signals
			signal main_alu_X, main_alu_Y : STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0);
			signal main_alu_result			: STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0) := (others => '0');
			signal main_alu_input			: ALU_INPUT;
			signal main_alu_flags			: ALU_FLAGS;
			signal aluOpInput				: ALU_OP_INPUT;

--			SignExtender signals
			signal sign_extender_output	: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

--			registers signals
			signal register_rs_output, register_rt_output, register_write_data : STD_LOGIC_VECTOR(31 downto 0);
			signal write_reg_addr			: std_logic_vector(4 downto 0);

begin
		--Signal values
		alu_add_input_signal.Op0 <= '0';
		alu_add_input_signal.Op1 <= '1';
		alu_add_input_signal.Op2 <= '0';
		alu_add_input_signal.Op3 <= '0';
		dmem_write_enable <= MemWrite;
		PC_increment_signal <= (31 => '1', others => '0');
		imem_address <= PC_output;
		dmem_data_out <= register_rt_output;
		main_alu_X <= register_rs_output;
		dmem_address <= main_alu_result;
		dmem_address_wr <= main_alu_result;

--			setting up control unit
		CU : control_unit
		port map (
				CLK			=> clk,
				RESET		=> reset,
				proc_enable => processor_enable,
				OpCode		=> imem_data_in (31 downto 26),
				ALUOp		=> aluOpInput,
				RegDst		=> RegDst,
				Branch		=> Branch,
				MemRead		=> MemRead,
				MemtoReg	=> MemtoReg,
				MemWrite	=> MemWrite,
				ALUSrc		=> ALUSrc,
				RegWrite	=> RegWrite,
				PCWriteEnb	=> pc_write_enable,
				JumpEnb		=> JmpEnable
		);

--			setting up program counter circuit - PC itself, ALU that increments it
			branching_control_process: process (Branch, main_alu_flags.Zero, CLK)
			begin
						if (Branch = '1' and main_alu_flags.Zero = '1') then
							Branching_Mux_Output <= branching_alu_output;
						else
							Branching_Mux_Output <= alu_pc_output;
						end if;
			end process;

			branching_alu : ALU
			generic map (
				N => IADDR_BUS
			)
			port map (
				X => sign_extender_output,
				Y => alu_pc_output,
				ALU_IN => alu_add_input_signal,
				R => branching_alu_output,
				FLAGS => branching_alu_flags
			);

		PC : program_counter
		port map (
			CLK => clk,
			RESET => reset,
			PC_WR_EN => pc_write_enable,
			PC_IN => PC_input,
			PC_OUT => PC_output
		);

		PC_incrementer : ALU
		generic map (
			N => IADDR_BUS
		)
		port map (
			X => PC_increment_signal,
			Y => PC_output,
			ALU_IN => alu_add_input_signal,
			R => alu_pc_output,
			FLAGS => pc_alu_flags
		);

		--Jump Control Process
		JumpControlProcess: process(JmpEnable, CLK)
		begin
			if (CLK = '1' or CLK = '0') then
				if (JmpEnable = '1') then
					pc_input <= alu_pc_output(31 downto 26) & imem_data_in(25 downto 0);
				else
					pc_input <= branching_mux_output;
				end if;
			end if;
		end process;

--		setting up sign extender
		sign_ext : sign_extender
		generic map (
			in_width => 16,
			out_width => 32
		)
		port map (
			input => imem_data_in (15 downto 0),
			output => sign_extender_output
		);

--			setting up register-file
		write_reg_proc : process(RegDst, imem_data_in)
		begin
			if RegDst = '1' then
				write_reg_addr <= imem_data_in (15 downto 11);
			else
				write_reg_addr <= imem_data_in (20 downto 16);
			end if;
		end process;

		write_data_proc : process(MemtoReg, main_alu_result, dmem_data_in)
		begin
			if MemtoReg = '1' then
				register_write_data <= dmem_data_in;
			else
				register_write_data <= main_alu_result;
			end if;
		end process;

		regs : register_file
		port map (
			CLK => clk,
			RESET => reset,
			RW => RegWrite,
			RS_ADDR => imem_data_in (25 downto 21),
			RT_ADDR => imem_data_in (20 downto 16),
			RD_ADDR => write_reg_addr,
			WRITE_DATA => register_write_data,
			RS => register_rs_output,
			RT => register_rt_output
		);

--			setting up main ALU
		ALUSource_proc : process(ALUSrc, sign_extender_output, register_rt_output)
			begin
				if ALUSrc = '1' then
					main_alu_Y <= sign_extender_output;
				else
					main_alu_Y <= register_rt_output;
				end if;
			end process;

		ALU_main_unit : alu
		generic map (N => 32)
		port map (
			X => main_alu_X,
			Y => main_alu_Y,
			ALU_IN => main_alu_input,
			R => main_alu_result,
			FLAGS => main_alu_flags
		);
		ALU_control_unit : ALU_control
		port map (
			CLK => clk,
			RESET => reset,
			FUNC => imem_data_in(5 downto 0),
			ALUOp => aluOpInput,
			ALU_FUNC => main_alu_input
		);

end behave;
