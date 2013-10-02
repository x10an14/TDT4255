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
		imem_data_in			: in STD_LOGIC_VECTOR (IDATA_BUS - 1 downto 0);
		dmem_data_in			: in STD_LOGIC_VECTOR (DDATA_BUS - 1 downto 0);
		imem_address			: out STD_LOGIC_VECTOR (IADDR_BUS - 1 downto 0);
		dmem_address			: in STD_LOGIC_VECTOR (DADDR_BUS - 1 downto 0);
		dmem_address_wr		: out STD_LOGIC_VECTOR (DADDR_BUS - 1 downto 0);
		dmem_data_out			: out STD_LOGIC_VECTOR (DDATA_BUS - 1 downto 0);
		dmem_write_enable		: out STD_LOGIC
	);
end processor;

architecture behave of processor is
   --component control unit
     component proc_control_module is
         port(Opcode : in  STD_LOGIC_VECTOR (5 downto 0);
              clk : in STD_LOGIC;
              processor_enable : in STD_LOGIC;
              reset : in STD_LOGIC;
              RegDst : out STD_LOGIC;
              RegWrite : out STD_LOGIC;
              ALUSrc : out STD_LOGIC;
              MemtoReg : out STD_LOGIC;
              MemRead : out STD_LOGIC;
              MemWrite : out STD_LOGIC;
              ALUOp0 : out STD_LOGIC; -- this signal and the next one are to be worked on, they are meant to deal with branching
              ALUOp1 : out STD_LOGIC;
              Branch : out STD_LOGIC;
              state_vector : out STD_LOGIC_VECTOR(1 downto 0));
      end component proc_control_module;
	--component ALU_control
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
               PC_CON	: in 	STD_LOGIC;
               PC_IN		: in 	STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0);
               PC_OUT	: out	STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0)
         );
     end component program_counter;
	--component sign extender
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
--      PC related signals:
      signal alu_output_to_PC, PC_output, PC_increment_signal : STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0);
      signal pc_con : STD_LOGIC := '0';
      signal alu_in : ALU_INPUT;
      signal alu_flags : ALU_FLAGS;
--      control unit related signals
      signal RegDst, RegWrite, ALUSrc, MemtoReg, MemRead, MemWrite, ALUOp0, ALUOp1, Branch : STD_LOGIC;
      signal state_vector : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- to be removed
--      main ALU related signals
      signal main_alu_result, main_alu_RS, main_alu_RT : STD_LOGIC_VECTOR(DDATA_BUS-1 downto 0);
begin
--      setting up control unit
     CU : proc_control_module
     port map (
         Opcode => imem_data_in (31 downto 26),
         clk => clk,
         processor_enable => processor_enable,
         reset => reset,
         RegDst => RegDst,
         RegWrite => RegWrite,
         ALUSrc => ALUSrc,
         MemtoReg => MemtoReg,
         MemRead => MemRead,
         MemWrite => MemWrite,
         ALUOp0 => ALUOp0,
         ALUOp1 => ALUOp1,
         Branch => Branch,
         state_vector => state_vector         
     );
      
--      setting up program counter circuit - PC itself, ALU that increments it

     PC : program_counter
     port map (
         CLK => clk,
         RESET => reset,
         PC_CON => pc_con,
         PC_IN => alu_output_to_PC,
         PC_OUT => PC_output
     );
     
     alu_in.Op0 <= '1';
     alu_in.Op1 <= '1';
     alu_in.Op2 <= '1';
     alu_in.Op3 <= '1';
     alu_flags.Carry <= '0';

     PC_incrementer : ALU
     generic map (
         N => IADDR_BUS
     )
     port map (
         X => PC_increment_signal,
         Y => PC_output,
         ALU_IN => alu_in,
         R => alu_output_to_PC,
         FLAGS => alu_flags
     );

--      setting up connection to instruction memory (using imem_data_in and imem_address processor-ports)
     imem_address <= PC_output;
     
--       setting up register-file

     regs : register_file
     port map (
         CLK => clk,
         RESET => reset,
         RW => RegWrite,
         RS_ADDR => imem_data_in (25 downto 21),
         RT_ADDR => imem_data_in (20 downto 16),
         RD_ADDR => imem_data_in (15 downto 11),
         WRITE_DATA => main_alu_result,
         RS => main_alu_RS,
         RT => main_alu_RT
     );
     
     
end behave;