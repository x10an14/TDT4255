								library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity processor is
	port(
		clk 						: in STD_LOGIC;
		reset						: in STD_LOGIC;
		processor_enable 		: in STD_LOGIC;
		imem_data_in			: in STD_LOGIC_VECTOR (IDATA_BUS - 1 downto 0);   -- check
		dmem_data_in			: in STD_LOGIC_VECTOR (DDATA_BUS - 1 downto 0);   -- check
		imem_address			: out STD_LOGIC_VECTOR (IADDR_BUS - 1 downto 0);  -- check
		dmem_address			: out STD_LOGIC_VECTOR (DADDR_BUS - 1 downto 0);  -- check
		dmem_address_wr		: out STD_LOGIC_VECTOR (DADDR_BUS - 1 downto 0);  -- check
		dmem_data_out			: out STD_LOGIC_VECTOR (DDATA_BUS - 1 downto 0);  -- check
		dmem_write_enable		: out STD_LOGIC -- check
	);
end processor;

architecture behave of processor is
	 --component control unit
		 component control_unit is
				 port(
							CLK : IN	std_logic;
							RESET : IN	std_logic;
                     proc_enable : IN std_logic;
							OpCode : IN	std_logic_vector(5 downto 0);
							ALUOp : OUT	ALU_OP_INPUT;
							RegDst : OUT	std_logic;
							Branch : OUT	std_logic;
							MemRead : OUT	std_logic;
							MemtoReg : OUT	std_logic;
							MemWrite : OUT	std_logic;
							ALUSrc : OUT	std_logic;
							RegWrite : OUT	std_logic;
							PCWriteEnb : OUT	std_logic
					);
							
			end component control_unit;
	--component ALU_control
		component ALU_control is
				port(
					CLK			: in STD_LOGIC;
					RESET		: in STD_LOGIC;
					FUNC		: in STD_LOGIC_VECTOR (5 downto 0);
					ALUOp		: in ALU_OP_INPUT;
					ALU_FUNC	: out ALU_INPUT
				);
		end component ALU_control;
	--component ALU
		 component ALU is
				 generic (N: NATURAL);
				 port( X			: in STD_LOGIC_VECTOR(N-1 downto 0);
							 Y			: in STD_LOGIC_VECTOR(N-1 downto 0);
							 ALU_IN	: in ALU_INPUT;
							 R			: out STD_LOGIC_VECTOR(N-1 downto 0);
							 FLAGS		: out ALU_FLAGS
				 );
		 end component ALU;
	--component PC
		 component program_counter is
				 port( CLK 		: in 	STD_LOGIC;
							 RESET		: in 	STD_LOGIC;
							 PC_WR_EN	: in 	STD_LOGIC;
							 PC_IN		: in 	STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0);
							 PC_OUT	: out	STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0)
				 );
		 end component program_counter;
	--component sign extender
		component sign_extender is
				generic (IN_WIDTH, OUT_WIDTH: NATURAL);
				port(		input : in  STD_LOGIC_VECTOR ( IN_WIDTH-1 downto 0);
							output : out  STD_LOGIC_VECTOR (OUT_WIDTH-1 downto 0)
				);
		end component sign_extender;
	--component instruction memory # defined and instantiated in toplevel
	 --component register memory
		 component register_file is
				 port(
						CLK 			:	in	STD_LOGIC;
						RESET			:	in	STD_LOGIC;
						RW				:	in	STD_LOGIC;
						RS_ADDR 		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0);
						RT_ADDR 		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0);
						RD_ADDR 		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0);
						WRITE_DATA	:	in	STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0);
						RS				:	out	STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0);
						RT				:	out	STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0)
				 );
			end component register_file;
	--component data memory # defined and instantiated in toplevel
	--component PC adder # ALU?
	--component ALU jump adder

	 --signals definition
--			PC related signals:
			signal alu_output_to_PC, PC_output, PC_increment_signal : STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0);
			signal PC_WR_EN : STD_LOGIC := '0';
			signal alu_in666 : ALU_INPUT;
			signal pc_alu_flags : ALU_FLAGS;
--			control unit related signals
			signal RegDst, RegWrite, MemtoReg, MemRead, MemWrite, ALUOp0, ALUOp1, Branch : STD_LOGIC;
			signal ALUSrc : std_logic := '1';
			signal state_vector : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- to be removed
--			main ALU related signals
			signal main_alu_X, main_alu_Y : STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0);
			signal main_alu_result : STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0) := (others => '0');
			signal main_alu_input : ALU_INPUT;
			signal main_alu_flags : ALU_FLAGS;
--			sign extender signals
			signal sign_extender_output : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
--			registers signals
			signal register_rs_output, register_rt_output, register_write_data : STD_LOGIC_VECTOR(31 downto 0);
			signal write_reg_addr : std_logic_vector(4 downto 0);
--			shit to be dealt with later
			signal aluOpInput : ALU_OP_INPUT;
begin
--			reset process
--		reset_proc : process(reset)
--		begin
--			if (reset = '1') then
--				imem_address <= (others => '0');
--			end if;
--		end process;
		 alu_in666.Op0 <= '0';
		 alu_in666.Op1 <= '1';
		 alu_in666.Op2 <= '0';
		 alu_in666.Op3 <= '0';
--			setting up control unit
		 CU : control_unit
		 port map (
				CLK => clk,
				RESET => reset,
            proc_enable => processor_enable,
				OpCode => imem_data_in (31 downto 26),
				ALUOp => aluOpInput, --this has to be figured out, would suggest making the functions I tried to work on actually work. would be very handy here and elswhere.
				RegDst => RegDst,
				Branch => Branch,
				MemRead => MemRead,
				MemtoReg => MemtoReg,
				MemWrite => MemWrite,
				ALUSrc => ALUSrc,
				RegWrite => RegWrite,
				PCWriteEnb => PC_WR_EN --Same as above comment
		 );
		 dmem_write_enable <= MemWrite;

--			setting up program counter circuit - PC itself, ALU that increments it
		 PC_increment_signal <= (1 => '1', others => '0');
		 PC : program_counter
		 port map (
				 CLK => clk,
				 RESET => reset,
				 PC_WR_EN => PC_WR_EN,
				 PC_IN => alu_output_to_PC,
				 PC_OUT => PC_output
		 );
		 imem_address <= PC_output;

		 pc_alu_flags.Carry <= '0';

		 PC_incrementer : ALU
		 generic map (
				 N => IADDR_BUS
		 )
		 port map (
				 X => PC_increment_signal,
				 Y => PC_output,
				 ALU_IN => alu_in666,
				 R => alu_output_to_PC,
				 FLAGS => pc_alu_flags
		 );

--			setting up connection to instruction memory (using imem_data_in and imem_address processor-ports)
--		imem_address <= PC_output;
--		 setting up sign extender
		sign_ext : sign_extender
		generic map ( in_width => 16,
							out_width => 32
		)
		port map (
				input => imem_data_in (15 downto 0),
--				input => (others => '1'),
				output => sign_extender_output
		);
		

--			 setting up register-file
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
		
		dmem_data_out <= register_rt_output;
		
		regs : register_file
		port map (
				 CLK => clk,
				 RESET => reset,
				 RW => RegWrite,
				 RS_ADDR => imem_data_in (25 downto 21),
				 RT_ADDR => imem_data_in (20 downto 16),
				 RD_ADDR => write_reg_addr,
				 WRITE_DATA => main_alu_result,
				 RS => register_rs_output,
				 RT => register_rt_output
		 );

--			setting up main ALU
		ALUSource_proc : process(ALUSrc, sign_extender_output, register_rt_output)
			begin
				if ALUSrc = '1' then
					main_alu_Y <= sign_extender_output;
	--				main_alu_Y <= (others => '1');
				else 
					main_alu_Y <= register_rt_output;
	--				main_alu_Y <= (others => '0');
				end if;
			end process;
		main_alu_X <= register_rs_output;
		

		ALU_main_unit : alu
		generic map (N => 32)
		port map (
			X => main_alu_X,
			Y => main_alu_Y,
			ALU_IN => main_alu_input,
			R => main_alu_result,
			FLAGS => main_alu_flags
		);
		dmem_address <= main_alu_result;
		dmem_address_wr <= main_alu_result;

		
--		aluOpInput.Op0 <= '0'; 
--		aluOpInput.Op1 <= '0';
--		aluOpInput.Op2 <= '0';
		
		ALU_control_unit : ALU_control
		port map (
			CLK => clk,
			RESET => reset,
			FUNC => "000000",
			ALUOp => aluOpInput,
			ALU_FUNC => main_alu_input
		);
		
		
				

end behave;