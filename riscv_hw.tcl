# TCL File Generated by Component Editor 15.0
# Mon Nov 09 13:16:38 PST 2015
# DO NOT MODIFY


#
# riscv "riscv" v1.0
#  2015.11.09.13:16:38
#
#

#
# request TCL package from ACDS 15.0
#
package require -exact qsys 15.0


#
# module riscv
#
set_module_property DESCRIPTION ""
set_module_property NAME riscv
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME riscv
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL riscV
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file utils.vhd VHDL PATH ../utils.vhd
add_fileset_file components.vhd VHDL PATH ../components.vhd
add_fileset_file alu.vhd VHDL PATH ../alu.vhd
add_fileset_file branch_unit.vhd VHDL PATH ../branch_unit.vhd
add_fileset_file decode.vhd VHDL PATH ../decode.vhd
add_fileset_file execute.vhd VHDL PATH ../execute.vhd
add_fileset_file instruction_fetch.vhd VHDL PATH ../instruction_fetch.vhd
add_fileset_file load_store_unit.vhd VHDL PATH ../load_store_unit.vhd
add_fileset_file register_file.vhd VHDL PATH ../register_file.vhd
add_fileset_file riscv.vhd VHDL PATH ../riscv.vhd TOP_LEVEL_FILE
add_fileset_file sys_call.vhd VHDL PATH ../sys_call.vhd

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL riscV
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file utils.vhd VHDL PATH ../utils.vhd
add_fileset_file components.vhd VHDL PATH ../components.vhd
add_fileset_file alu.vhd VHDL PATH ../alu.vhd
add_fileset_file branch_unit.vhd VHDL PATH ../branch_unit.vhd
add_fileset_file decode.vhd VHDL PATH ../decode.vhd
add_fileset_file execute.vhd VHDL PATH ../execute.vhd
add_fileset_file instruction_fetch.vhd VHDL PATH ../instruction_fetch.vhd
add_fileset_file load_store_unit.vhd VHDL PATH ../load_store_unit.vhd
add_fileset_file register_file.vhd VHDL PATH ../register_file.vhd
add_fileset_file riscv.vhd VHDL PATH ../riscv.vhd
add_fileset_file sys_call.vhd VHDL PATH ../sys_call.vhd



#
# parameters
#
add_parameter REGISTER_SIZE INTEGER 32
set_parameter_property REGISTER_SIZE DEFAULT_VALUE 32
set_parameter_property REGISTER_SIZE DISPLAY_NAME REGISTER_SIZE
set_parameter_property REGISTER_SIZE TYPE INTEGER
set_parameter_property REGISTER_SIZE UNITS None
set_parameter_property REGISTER_SIZE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property REGISTER_SIZE HDL_PARAMETER true
add_parameter RESET_VECTOR NATURAL 512
set_parameter_property RESET_VECTOR DEFAULT_VALUE 512
set_parameter_property RESET_VECTOR DISPLAY_NAME RESET_VECTOR
set_parameter_property RESET_VECTOR TYPE NATURAL
set_parameter_property RESET_VECTOR UNITS None
set_parameter_property RESET_VECTOR ALLOWED_RANGES 0:2147483647
set_parameter_property RESET_VECTOR HDL_PARAMETER true
add_parameter MULTIPLY_ENABLE BOOLEAN false
set_parameter_property MULTIPLY_ENABLE DEFAULT_VALUE false
set_parameter_property MULTIPLY_ENABLE DISPLAY_NAME MULTIPLY_ENABLE
set_parameter_property MULTIPLY_ENABLE TYPE BOOLEAN
set_parameter_property MULTIPLY_ENABLE UNITS None
set_parameter_property MULTIPLY_ENABLE HDL_PARAMETER true


#
# display items
#


#
# connection point clock
#
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


#
# connection point reset
#
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


#
# connection point data
#
add_interface data avalon start
set_interface_property data addressUnits SYMBOLS
set_interface_property data associatedClock clock
set_interface_property data associatedReset reset
set_interface_property data bitsPerSymbol 8
set_interface_property data burstOnBurstBoundariesOnly false
set_interface_property data burstcountUnits WORDS
set_interface_property data doStreamReads false
set_interface_property data doStreamWrites false
set_interface_property data holdTime 0
set_interface_property data linewrapBursts false
set_interface_property data maximumPendingReadTransactions 0
set_interface_property data maximumPendingWriteTransactions 0
set_interface_property data readLatency 0
set_interface_property data readWaitTime 1
set_interface_property data setupTime 0
set_interface_property data timingUnits Cycles
set_interface_property data writeWaitTime 0
set_interface_property data ENABLED true
set_interface_property data EXPORT_OF ""
set_interface_property data PORT_NAME_MAP ""
set_interface_property data CMSIS_SVD_VARIABLES ""
set_interface_property data SVD_ADDRESS_GROUP ""

add_interface_port data avm_data_address address Output register_size
add_interface_port data avm_data_byteenable byteenable Output register_size/8
add_interface_port data avm_data_read read Output 1
add_interface_port data avm_data_readdata readdata Input register_size
add_interface_port data avm_data_response response Input 2
add_interface_port data avm_data_write write Output 1
add_interface_port data avm_data_writedata writedata Output register_size
add_interface_port data avm_data_lock lock Output 1
add_interface_port data avm_data_waitrequest waitrequest Input 1
add_interface_port data avm_data_readdatavalid readdatavalid Input 1


#
# connection point instruction
#
add_interface instruction avalon start
set_interface_property instruction addressUnits SYMBOLS
set_interface_property instruction associatedClock clock
set_interface_property instruction associatedReset reset
set_interface_property instruction bitsPerSymbol 8
set_interface_property instruction burstOnBurstBoundariesOnly false
set_interface_property instruction burstcountUnits WORDS
set_interface_property instruction doStreamReads false
set_interface_property instruction doStreamWrites false
set_interface_property instruction holdTime 0
set_interface_property instruction linewrapBursts false
set_interface_property instruction maximumPendingReadTransactions 0
set_interface_property instruction maximumPendingWriteTransactions 0
set_interface_property instruction readLatency 0
set_interface_property instruction readWaitTime 1
set_interface_property instruction setupTime 0
set_interface_property instruction timingUnits Cycles
set_interface_property instruction writeWaitTime 0
set_interface_property instruction ENABLED true
set_interface_property instruction EXPORT_OF ""
set_interface_property instruction PORT_NAME_MAP ""
set_interface_property instruction CMSIS_SVD_VARIABLES ""
set_interface_property instruction SVD_ADDRESS_GROUP ""

add_interface_port instruction avm_instruction_address address Output register_size
add_interface_port instruction avm_instruction_byteenable byteenable Output register_size/8
add_interface_port instruction avm_instruction_read read Output 1
add_interface_port instruction avm_instruction_readdata readdata Input register_size
add_interface_port instruction avm_instruction_response response Input 2
add_interface_port instruction avm_instruction_write write Output 1
add_interface_port instruction avm_instruction_writedata writedata Output register_size
add_interface_port instruction avm_instruction_lock lock Output 1
add_interface_port instruction avm_instruction_waitrequest waitrequest Input 1
add_interface_port instruction avm_instruction_readdatavalid readdatavalid Input 1


#
# connection point program_counter
#
add_interface program_counter conduit end
set_interface_property program_counter associatedClock ""
set_interface_property program_counter associatedReset ""
set_interface_property program_counter ENABLED true
set_interface_property program_counter EXPORT_OF ""
set_interface_property program_counter PORT_NAME_MAP ""
set_interface_property program_counter CMSIS_SVD_VARIABLES ""
set_interface_property program_counter SVD_ADDRESS_GROUP ""

add_interface_port program_counter coe_program_counter export Output register_size


#
# connection point to_host
#
add_interface to_host conduit end
set_interface_property to_host associatedClock ""
set_interface_property to_host associatedReset ""
set_interface_property to_host ENABLED true
set_interface_property to_host EXPORT_OF ""
set_interface_property to_host PORT_NAME_MAP ""
set_interface_property to_host CMSIS_SVD_VARIABLES ""
set_interface_property to_host SVD_ADDRESS_GROUP ""

add_interface_port to_host coe_to_host export Output register_size


#
# connection point from_host
#
add_interface from_host conduit end
set_interface_property from_host associatedClock ""
set_interface_property from_host associatedReset ""
set_interface_property from_host ENABLED true
set_interface_property from_host EXPORT_OF ""
set_interface_property from_host PORT_NAME_MAP ""
set_interface_property from_host CMSIS_SVD_VARIABLES ""
set_interface_property from_host SVD_ADDRESS_GROUP ""

add_interface_port from_host coe_from_host export Input register_size
