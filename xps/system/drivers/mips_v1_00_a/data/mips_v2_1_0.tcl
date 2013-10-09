##############################################################################
## Filename:          M:\Github\TDT4255\xps\system/drivers/mips_v1_00_a/data/mips_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Wed Oct 09 05:03:51 2013 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "mips" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
