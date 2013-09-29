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
begin
      
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

--     regs : register_file
     
end behave;