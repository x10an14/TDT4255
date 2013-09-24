library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity processor is
	generic ( 
		MEM_ADDR_BUS : integer := 31 
	);
	port(
		clk 						: in STD_LOGIC;
		reset						: in STD_LOGIC;
		processor_enable 		: in STD_LOGIC;
		imem_address			: out STD_LOGIC_VECTOR (MEM_ADDR_BUS downto 0);
		imem_data_in			: in STD_LOGIC_VECTOR (MEM_ADDR_BUS downto 0);
		dmem_data_in			: in STD_LOGIC_VECTOR (MEM_ADDR_BUS downto 0);
		dmem_address			: out STD_LOGIC_VECTOR (MEM_ADDR_BUS downto 0);
		dmem_address_wr		: out STD_LOGIC_VECTOR (MEM_ADDR_BUS downto 0);
		dmem_data_out			: out STD_LOGIC_VECTOR (MEM_ADDR_BUS downto 0);
		dmem_write_ennable	: out STD_LOGIC
	);		
end processor;

architecture Behavioral of processor is
begin
	--blabla
end Behavorial;