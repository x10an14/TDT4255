--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package MIPS_CONSTANT_PKG is

	-- RECORDS
	type ALU_OP_INPUT is
	record
		Op0	:	STD_LOGIC;
		Op1	:	STD_LOGIC;
		Op2	:	STD_LOGIC;
	end record;
	
	type ALU_INPUT is
	record
		Op0		:	STD_LOGIC;
		Op1		:	STD_LOGIC;
		Op2		:	STD_LOGIC;
		Op3		:	STD_LOGIC;
	end record;

	type ALU_FLAGS is
	record
		Carry		: STD_LOGIC;
		Overflow	: STD_LOGIC;
		Zero		: STD_LOGIC;
		Negative	: STD_LOGIC;
	end record;
	
  -- NEW!
	type BRANCH_TYPE is (COND_BRANCH, JUMP, NO_BRANCH);
  type ALU_OP      is (ALUOP_LOAD_STORE, ALUOP_BRANCH, ALUOP_FUNC, ALUOP_LDI);

	-- CONSTANTS
	constant IADDR_BUS	: integer	:= 32;
	constant IDATA_BUS	: integer	:= 32;
	constant DADDR_BUS	: integer	:= 32;
	constant DDATA_BUS	: integer	:= 32;
	constant RADDR_BUS	: integer	:= 5;
	
	constant MEM_ADDR_COUNT	: integer	:= 8;
	
	constant ZERO1b	: STD_LOGIC							  :=  '0';
	constant ZERO32b	: STD_LOGIC_VECTOR(31 downto 0) :=  "00000000000000000000000000000000";	
	constant ZERO16b	: STD_LOGIC_VECTOR(15 downto 0) :=  "0000000000000000";
	constant ONE32b	: STD_LOGIC_VECTOR(31 downto 0) :=  "11111111111111111111111111111111";	
	constant ONE16b	: STD_LOGIC_VECTOR(15 downto 0) :=  "1111111111111111";	
	
	constant ALU_OP_AND	: ALU_INPUT := (others => '0');								-- AKA X"0"
	constant ALU_OP_OR	: ALU_INPUT := (Op0 = '1', others => '0');				-- AKA X"1"
	constant ALU_OP_ADD	: ALU_INPUT := (Op1 = '1', others => '0');				-- AKA X"2"
	constant ALU_OP_SLT	: ALU_INPUT := (Op3 = '0', others => '1');				-- AKA X"7"
	constant ALU_OP_SUB	: ALU_INPUT := (Op2 = '1', Op1 = '1', others => '0');	-- AKA X"6"
	
	constant ALU_OP_ZERO	: ALU_OP_INPUT := (others => '0');
	constant ALU_OP_ONE	: ALU_OP_INPUT	:= (Op0 = '1', others => '0');
	constant ALU_OP_TWO	: ALU_OP_INPUT := (Op1 = '1', others => '0');
	
end MIPS_CONSTANT_PKG;
