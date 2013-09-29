----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:09:32 09/29/2013 
-- Design Name: 
-- Module Name:    test_module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_module is
    Port ( clk : in  STD_LOGIC;
           out_test : out  STD_LOGIC);
   end test_module;
   
architecture Behavioral of test_module is
   signal outty: std_logic;

begin

   outty_proc : process (clk)
   begin
      outty <= clk;
   end process;
   
   out_test <= outty;
end Behavioral;

