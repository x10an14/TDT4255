--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:07:18 10/02/2013
-- Design Name:   
-- Module Name:   M:/Github/TDT4255/supportFiles_13/hardware/tb_program_counter.vhd
-- Project Name:  TDT4255_Project_Assignment1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: program_counter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_program_counter IS
END tb_program_counter;
 
ARCHITECTURE behavior OF tb_program_counter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT program_counter
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         PC_WR_EN : IN  std_logic;
         PC_IN : IN  std_logic_vector(31 downto 0);
         PC_OUT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal PC_WR_EN : std_logic := '0';
   signal PC_IN : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal PC_OUT : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: program_counter PORT MAP (
          CLK => CLK,
          RESET => RESET,
          PC_WR_EN => PC_WR_EN,
          PC_IN => PC_IN,
          PC_OUT => PC_OUT
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
		RESET <= '1';
		wait for CLK_period;
		assert (RESET /= '1') report "Reset is not 1..." severity error;
		assert (PC_OUT /= X"00000000") report "Out is not 0..." severity error;
      wait for 100 ns;

      -- insert stimulus here 
		
		RESET <= '0';
		PC_IN <= X"00000001";
		wait for CLK_period;
		assert (PC_IN /= X"00000001") report "In is not 1..." severity error;
		PC_WR_EN <= '1';
		wait for CLK_period;
		assert (PC_OUT /= X"00000001") report "Out is not 1..." severity error;
		wait for CLK_period*3;
		
		PC_IN <= X"F0F0F0F0";
		wait for CLK_period;
		assert (PC_OUT /= X"F0F0F0F0") report "Out is not 4 042 322 160..." severity error;
		PC_WR_EN <= '0';
		wait for CLK_period*3;
		
		PC_IN <= X"FFFFFFFF";
		wait for CLK_period;
		assert (PC_OUT /= X"F0F0F0F0") report "Out changed when it shouldn't have =(... " severity error;
		RESET <= '1';
		
      wait;
   end process;

END;
