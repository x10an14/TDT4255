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
				 PCWriteEnb : OUT	std_logic
				);
		END COMPONENT;


	 --Inputs
	 signal CLK : std_logic := '0';
	 signal RESET : std_logic := '0';
	 signal OpCode : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
	 signal ALUOp : ALU_OP_INPUT;
	 signal RegDst : std_logic := '0';
	 signal Branch : std_logic := '0';
	 signal MemRead : std_logic := '0';
	 signal MemtoReg : std_logic := '0';
	 signal MemWrite : std_logic := '0';
	 signal ALUSrc : std_logic := '0';
	 signal RegWrite : std_logic := '0';
	 signal PCWriteEnb : std_logic := '0';

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
					PCWriteEnb => PCWriteEnb
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
 		reset <= '1';
		wait for 50 ns; -- hold reset for 50 ns
		reset <= '0';
		
		wait for CLK_period;
--		assert ((ALUOp.Op0 = '0') and (ALUOp.Op1 = '0') and (ALUOp.Op2 = '0')) report "ALUOp not reset" severity error;
		-- insert stimulus here
			
		opcode <= "000100";
		wait for CLK_period;
--		assert (PCWriteEnb = '1') report "PCWriteEnb is not 1..." severity error;
--		assert (RegDst = '1') report "RegDst is not 1..." severity error;
--		assert (RegWrite = '1') report "RegWrite is not 1..." severity error;
--		assert (ALUOp.Op1 = '1') report "ALUOp.Op1 is not 1..." severity error;
		
		
			wait;
	 end process;

END;
