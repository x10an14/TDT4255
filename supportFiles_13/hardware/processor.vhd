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
	--component PC
	--component sign extender
	--component instruction memory
	--component register memory
	--component data memory
	--component PC adder
	--component ALU jump adder
begin
	--blabla
end behave;