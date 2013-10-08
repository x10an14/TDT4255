--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:	17:17:00 09/29/2013
-- Design Name:
-- Module Name:	C:/Users/fadeev/Documents/TDT4255/supportFiles_13/hardware_old_project/processor_tb.vhd
-- Project Name:	ISEproject
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: processor
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY processor_tb IS
END processor_tb;

ARCHITECTURE behavior OF processor_tb IS

		-- Component Declaration for the Unit Under Test (UUT)

		COMPONENT processor
		PORT(
				clk : IN	std_logic;
				reset : IN	std_logic;
				processor_enable : IN	std_logic;
				imem_data_in : IN	std_logic_vector(31 downto 0);
				dmem_data_in : IN	std_logic_vector(31 downto 0);
				imem_address : OUT	std_logic_vector(31 downto 0);
				dmem_address : OUT	std_logic_vector(31 downto 0);
				dmem_address_wr : OUT	std_logic_vector(31 downto 0);
				dmem_data_out : OUT	std_logic_vector(31 downto 0);
				dmem_write_enable : OUT	std_logic
				);
		END COMPONENT;


	--Inputs
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal processor_enable : std_logic := '1';
	signal imem_data_in : std_logic_vector(31 downto 0) := (others => '0');
	signal dmem_data_in : std_logic_vector(31 downto 0) := (others => '0');
	signal dmem_address : std_logic_vector(31 downto 0) := (others => '0');

	--Outputs
	signal imem_address : std_logic_vector(31 downto 0);
	signal dmem_address_wr : std_logic_vector(31 downto 0);
	signal dmem_data_out : std_logic_vector(31 downto 0);
	signal dmem_write_enable : std_logic;

	-- Clock period definitions
	constant clk_period : time := 10 ns;

	-- signals needed for testing
	signal addi_1_1_f : std_logic_vector(31 downto 0) := "1111" & "000000000000"
									& "10000" & "10000" & "001000"; --add F to reg
	signal addi_1_1_f_reverse : std_logic_vector(31 downto 0) := "000100" & "00001" & "00001" & "0000000000001111";
	signal lw1 : std_logic_vector(31 downto 0) := X"8C010001";


BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: processor PORT MAP (
					clk => clk,
					reset => reset,
					processor_enable => processor_enable,
					imem_data_in => imem_data_in,
					dmem_data_in => dmem_data_in,
					imem_address => imem_address,
					dmem_address => dmem_address,
					dmem_address_wr => dmem_address_wr,
					dmem_data_out => dmem_data_out,
					dmem_write_enable => dmem_write_enable
				);

	-- Clock process definitions
	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;


	-- Stimulus process
	stim_proc: process
	begin
			-- hold reset state for 100 ns.
		reset <= '1';
		wait for 100 ns;

		reset <= '0';
		imem_data_in <= lw1;

			wait;
	end process;

END;
