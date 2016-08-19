# TCL File Generated by Component Editor 15.0
# Tue Jul 19 16:32:56 PDT 2016
# DO NOT MODIFY


#
# pipeline_counter "pipeline_counter" v1.0
#  2016.07.19.16:32:56
#
#

#
# request TCL package from ACDS 15.0
#
package require -exact qsys 15.0


#
# module pipeline_counter
#
set_module_property DESCRIPTION ""
set_module_property NAME pipeline_counter
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME pipeline_counter
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL pipeline_counter
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file pipeline_counter.vhd VHDL PATH test_components/pipeline_counter.vhd TOP_LEVEL_FILE

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL pipeline_counter
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file pipeline_counter.vhd VHDL PATH test_components/pipeline_counter.vhd


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


#
# display items
#


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
# connection point counter
#
add_interface counter avalon end
set_interface_property counter addressUnits SYMBOLS
set_interface_property counter associatedClock clock
set_interface_property counter associatedReset reset
set_interface_property counter bitsPerSymbol 8
set_interface_property counter burstOnBurstBoundariesOnly false
set_interface_property counter burstcountUnits WORDS
set_interface_property counter explicitAddressSpan 0
set_interface_property counter holdTime 0
set_interface_property counter linewrapBursts false
set_interface_property counter maximumPendingReadTransactions 1
set_interface_property counter maximumPendingWriteTransactions 0
set_interface_property counter readLatency 0
set_interface_property counter readWaitTime 1
set_interface_property counter setupTime 0
set_interface_property counter timingUnits Cycles
set_interface_property counter writeWaitTime 0
set_interface_property counter ENABLED true
set_interface_property counter EXPORT_OF ""
set_interface_property counter PORT_NAME_MAP ""
set_interface_property counter CMSIS_SVD_VARIABLES ""
set_interface_property counter SVD_ADDRESS_GROUP ""

add_interface_port counter counter_address address Input 8
add_interface_port counter counter_byteenable byteenable Input register_size/8
add_interface_port counter counter_read read Input 1
add_interface_port counter counter_readdata readdata Output register_size
add_interface_port counter counter_response response Output 2
add_interface_port counter counter_write write Input 1
add_interface_port counter counter_writedata writedata Input register_size
add_interface_port counter counter_lock lock Input 1
add_interface_port counter counter_waitrequest waitrequest Output 1
add_interface_port counter counter_readdatavalid readdatavalid Output 1
set_interface_assignment counter embeddedsw.configuration.isFlash 0
set_interface_assignment counter embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment counter embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment counter embeddedsw.configuration.isPrintableDevice 0


#
# connection point conduit_end_1
#
add_interface conduit_end_1 conduit end
set_interface_property conduit_end_1 associatedClock clock
set_interface_property conduit_end_1 associatedReset reset
set_interface_property conduit_end_1 ENABLED true
set_interface_property conduit_end_1 EXPORT_OF ""
set_interface_property conduit_end_1 PORT_NAME_MAP ""
set_interface_property conduit_end_1 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_1 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_1 pipeline_count name Output 3