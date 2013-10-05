--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:06:10 10/05/2013
-- Design Name:   
-- Module Name:   C:/Users/fadeev/Documents/TDT4255/ise_project_files/alu_tb.vhd
-- Project Name:  ise_project_files
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
 library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

ENTITY alu_tb IS
END alu_tb;
 
ARCHITECTURE behavior OF alu_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
	 generic (N: natural := 32);
    PORT(
         X : IN  std_logic_vector(N-1 downto 0);
         Y : IN  std_logic_vector(N-1 downto 0);
         ALU_IN : IN  ALU_INPUT;
         R : OUT  std_logic_vector(N-1 downto 0);
         FLAGS : OUT  ALU_FLAGS
        );
    END COMPONENT;
    

   --Inputs
   signal X : std_logic_vector(31 downto 0) := (28 downto 25 => '1',
																	others => '0');
   signal Y : std_logic_vector(31 downto 0) := (12 downto 8 => '1', others => '0');
   signal ALU_IN : ALU_INPUT;
	


 	--Outputs
   signal R : std_logic_vector(31 downto 0);
   signal FLAGS : ALU_FLAGS;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
	ALU_IN.Op0 <= '0';
	ALU_IN.Op1 <= '1';
	ALU_IN.Op2 <= '0';
	ALU_IN.Op3 <= '0';
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          X => X,
          Y => Y,
          ALU_IN => ALU_IN,
          R => R,
          FLAGS => FLAGS
        );

   -- Clock process definitions
   clock_process :process
   begin
--		clock <= '0';
		wait for clock_period/2;
--		clock <= '1';
--		wait for <clock>_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
