--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:	 16:39:33 09/29/2013
-- Design Name:
-- Module Name:	 M:/Github/TDT4255/supportFiles_13/hardware/tb_control_unit.vhd
-- Project Name:	TDT4255_Project_Assignment1
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: control_unit
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.	Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY WORK;
USE WORK.MIPS_CONSTANT_PKG.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_control_unit IS
END tb_control_unit;

ARCHITECTURE behavior OF tb_control_unit IS

		-- Component Declaration for the Unit Under Test (UUT)

		COMPONENT control_unit
		PORT(
				 CLK : IN	std_logic;
				 RESET : IN	std_logic;
				 OpCode : IN	std_logic_vector(5 downto 0);
				 ALUOp : OUT	ALU_OP_INPUT;
				 RegDst : OUT	std_logic;
				 Branch : OUT	std_logic;
				 MemRead : OUT	std_logic;
				 MemtoReg : OUT	std_logic;
				 MemWrite : OUT	std_logic;
				 ALUSrc : OUT	std_logic;
				 RegWrite : OUT	std_logic;
				 Jump : OUT	std_logic;
				 PCWriteEnb : OUT	std_logic;
				 SRWriteEnb : OUT	std_logic
				);
		END COMPONENT;


	 --Inputs
	 signal CLK : std_logic := '0';
	 signal RESET : std_logic := '0';
	 signal OpCode : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
	 signal ALUOp : ALU_OP_INPUT;
	 signal RegDst : std_logic;
	 signal Branch : std_logic;
	 signal MemRead : std_logic;
	 signal MemtoReg : std_logic;
	 signal MemWrite : std_logic;
	 signal ALUSrc : std_logic;
	 signal RegWrite : std_logic;
	 signal Jump : std_logic;
	 signal PCWriteEnb : std_logic;
	 signal SRWriteEnb : std_logic;

	 -- Clock period definitions
	 constant CLK_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	 uut: control_unit PORT MAP (
					CLK => CLK,
					RESET => RESET,
					OpCode => OpCode,
					ALUOp => ALUOp,
					RegDst => RegDst,
					Branch => Branch,
					MemRead => MemRead,
					MemtoReg => MemtoReg,
					MemWrite => MemWrite,
					ALUSrc => ALUSrc,
					RegWrite => RegWrite,
					Jump => Jump,
					PCWriteEnb => PCWriteEnb,
					SRWriteEnb => SRWriteEnb
				);

	 -- Clock process definitions
	 CLK_process :process
	 begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	 end process;


	 -- Stimulus process
	 stim_proc: process
	 begin
			-- hold reset state for 100 ns.
			wait for 100 ns;

			-- insert stimulus here

		reset <= '1';

		wait for CLK_period;

		reset <= '0';
		ALUOp.Op0 <= '0';
		ALUOp.Op1 <= '0';
		ALUOp.Op2 <= '0';

		wait for CLK_period*4;

		opcode <= "000000";

		wait for CLK_period;

		opcode <= "000100";

		wait for CLK_period;

		opcode <= "100011";

		wait for CLK_period;

		opcode <= "101011";

		wait for CLK_period;

		opcode <= "001111";

		wait for CLK_period;

		opcode <= "000010";

			wait;
	 end process;

END;
