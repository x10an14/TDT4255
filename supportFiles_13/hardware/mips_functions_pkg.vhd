----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    10:24:24 09/27/2013
-- Design Name:
-- Module Name:    mips_functions_pkg - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

Library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

function BUS_SIGNAL_TO_ALU_INPUT(X: STD_LOGIC_VECTOR(3 downto 0)) return ALU_INPUT is
variable retval: ALU_INPUT;
begin
	retval.Op0 := X(0);
	retval.Op1 := X(1);
	retval.Op2 := X(2);
	retval.Op3 := X(3);
	return retval;
end function BUS_SIGNAL_TO_ALU_INPUT;

function ALU_OP_INPUT_TO_BUS_SIGNAL(X: ALU_OP_INPUT) return STD_LOGIC_VECTOR is
variable retval: STD_LOGIC_VECTOR(2 downto 0);
begin
	retval(0) := X.Op0;
	retval(1) := X.Op1;
	retval(2) := X.Op2;
	return retval;
end function ALU_OP_INPUT_TO_BUS_SIGNAL;


architecture Behavioral of mips_functions_pkg is

begin


end Behavioral;
