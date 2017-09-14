
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: clock
proc create_hier_cell_clock { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_clock() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O clk_2x_out
  create_bd_pin -dir I -type clk clk_in1
  create_bd_pin -dir O -type clk clk_out
  create_bd_pin -dir I -type rst cpu_resetn_in
  create_bd_pin -dir I -type rst ext_resetn_in
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn_jtag
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn_jtag
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_reset_cpu
  create_bd_pin -dir I -type rst system_resetn_in

  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.4 clk_wiz ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {151.636} \
CONFIG.CLKOUT1_PHASE_ERROR {98.575} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} \
CONFIG.CLKOUT2_JITTER {130.958} \
CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} \
CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} \
CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {2} \
CONFIG.RESET_PORT {resetn} \
CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz

  # Create instance: proc_sys_reset_cpu, and set properties
  set proc_sys_reset_cpu [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_cpu ]

  # Create instance: proc_sys_reset_jtag, and set properties
  set proc_sys_reset_jtag [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_jtag ]

  # Create instance: proc_sys_reset_system, and set properties
  set proc_sys_reset_system [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_system ]

  # Create instance: util_vector_logic_resetn_and, and set properties
  set util_vector_logic_resetn_and [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_resetn_and ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_resetn_and

  # Create port connections
  connect_bd_net -net clk_in1 [get_bd_pins clk_in1] [get_bd_pins clk_wiz/clk_in1]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins clk_out] [get_bd_pins clk_wiz/clk_out1] [get_bd_pins proc_sys_reset_cpu/slowest_sync_clk] [get_bd_pins proc_sys_reset_jtag/slowest_sync_clk] [get_bd_pins proc_sys_reset_system/slowest_sync_clk]
  connect_bd_net -net clk_wiz_clk_out2 [get_bd_pins clk_2x_out] [get_bd_pins clk_wiz/clk_out2]
  connect_bd_net -net clk_wiz_locked [get_bd_pins clk_wiz/locked] [get_bd_pins proc_sys_reset_system/dcm_locked]
  connect_bd_net -net cpu_resetn_in_1 [get_bd_pins cpu_resetn_in] [get_bd_pins util_vector_logic_resetn_and/Op2]
  connect_bd_net -net ext_resetn_in [get_bd_pins ext_resetn_in] [get_bd_pins clk_wiz/resetn] [get_bd_pins proc_sys_reset_cpu/ext_reset_in] [get_bd_pins proc_sys_reset_jtag/ext_reset_in] [get_bd_pins proc_sys_reset_system/ext_reset_in]
  connect_bd_net -net proc_sys_reset_cpu_peripheral_reset [get_bd_pins peripheral_reset_cpu] [get_bd_pins proc_sys_reset_cpu/peripheral_reset]
  connect_bd_net -net proc_sys_reset_jtag_interconnect_aresetn [get_bd_pins interconnect_aresetn_jtag] [get_bd_pins proc_sys_reset_jtag/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_jtag_peripheral_aresetn [get_bd_pins peripheral_aresetn_jtag] [get_bd_pins proc_sys_reset_jtag/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_system_interconnect_aresetn [get_bd_pins interconnect_aresetn] [get_bd_pins proc_sys_reset_system/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_system_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins proc_sys_reset_system/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_system_peripheral_reset [get_bd_pins peripheral_reset] [get_bd_pins proc_sys_reset_system/peripheral_reset]
  connect_bd_net -net system_resetn_in [get_bd_pins system_resetn_in] [get_bd_pins proc_sys_reset_system/aux_reset_in] [get_bd_pins util_vector_logic_resetn_and/Op1]
  connect_bd_net -net util_vector_logic_resetn_and_Res [get_bd_pins proc_sys_reset_cpu/aux_reset_in] [get_bd_pins util_vector_logic_resetn_and/Res]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set leds_8bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 leds_8bits ]

  # Create ports

  # Create instance: axi_bram_ctrl_onchip_A4, and set properties
  set axi_bram_ctrl_onchip_A4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_onchip_A4 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_onchip_A4

  # Create instance: axi_bram_ctrl_onchip_A4L, and set properties
  set axi_bram_ctrl_onchip_A4L [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_onchip_A4L ]
  set_property -dict [ list \
CONFIG.ECC_TYPE {0} \
CONFIG.PROTOCOL {AXI4LITE} \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_onchip_A4L

  # Create instance: axi_crossbar_data_uncacheable, and set properties
  set axi_crossbar_data_uncacheable [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_data_uncacheable ]
  set_property -dict [ list \
CONFIG.CONNECTIVITY_MODE {SASD} \
CONFIG.DATA_WIDTH {32} \
CONFIG.M00_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M00_READ_ISSUING {1} \
CONFIG.M00_WRITE_ISSUING {1} \
CONFIG.M01_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M01_READ_ISSUING {1} \
CONFIG.M01_WRITE_ISSUING {1} \
CONFIG.M02_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M02_READ_ISSUING {1} \
CONFIG.M02_WRITE_ISSUING {1} \
CONFIG.M03_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M03_READ_ISSUING {1} \
CONFIG.M03_WRITE_ISSUING {1} \
CONFIG.M04_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M04_READ_ISSUING {1} \
CONFIG.M04_WRITE_ISSUING {1} \
CONFIG.M05_A00_ADDR_WIDTH {0} \
CONFIG.M05_A00_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M05_READ_ISSUING {1} \
CONFIG.M05_WRITE_ISSUING {1} \
CONFIG.M06_A00_ADDR_WIDTH {0} \
CONFIG.M06_A00_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M06_READ_ISSUING {1} \
CONFIG.M06_WRITE_ISSUING {1} \
CONFIG.M07_A00_ADDR_WIDTH {0} \
CONFIG.M07_A00_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M07_READ_ISSUING {1} \
CONFIG.M07_WRITE_ISSUING {1} \
CONFIG.M08_A00_ADDR_WIDTH {0} \
CONFIG.M08_A00_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M08_READ_ISSUING {1} \
CONFIG.M08_WRITE_ISSUING {1} \
CONFIG.M09_A00_ADDR_WIDTH {0} \
CONFIG.M09_A00_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M09_READ_ISSUING {1} \
CONFIG.M09_WRITE_ISSUING {1} \
CONFIG.M10_A00_ADDR_WIDTH {0} \
CONFIG.M10_A00_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M10_READ_ISSUING {1} \
CONFIG.M10_WRITE_ISSUING {1} \
CONFIG.M11_A00_ADDR_WIDTH {0} \
CONFIG.M11_A00_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M11_READ_ISSUING {1} \
CONFIG.M11_WRITE_ISSUING {1} \
CONFIG.M12_A00_ADDR_WIDTH {0} \
CONFIG.M12_A00_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M12_READ_ISSUING {1} \
CONFIG.M12_WRITE_ISSUING {1} \
CONFIG.M13_A00_ADDR_WIDTH {0} \
CONFIG.M13_A00_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M13_READ_ISSUING {1} \
CONFIG.M13_WRITE_ISSUING {1} \
CONFIG.M14_A00_ADDR_WIDTH {0} \
CONFIG.M14_A00_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M14_READ_ISSUING {1} \
CONFIG.M14_WRITE_ISSUING {1} \
CONFIG.M15_A00_ADDR_WIDTH {0} \
CONFIG.M15_A00_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A01_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A02_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A03_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A04_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A05_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A06_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A07_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A08_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A09_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A10_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A11_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A12_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A13_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A14_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_A15_BASE_ADDR {0xffffffffffffffff} \
CONFIG.M15_READ_ISSUING {1} \
CONFIG.M15_WRITE_ISSUING {1} \
CONFIG.NUM_MI {5} \
CONFIG.NUM_SI {2} \
CONFIG.PROTOCOL {AXI4LITE} \
CONFIG.R_REGISTER {1} \
CONFIG.S00_READ_ACCEPTANCE {1} \
CONFIG.S00_SINGLE_THREAD {1} \
CONFIG.S00_WRITE_ACCEPTANCE {1} \
CONFIG.S01_READ_ACCEPTANCE {1} \
CONFIG.S01_SINGLE_THREAD {1} \
CONFIG.S01_WRITE_ACCEPTANCE {1} \
CONFIG.S02_READ_ACCEPTANCE {1} \
CONFIG.S02_WRITE_ACCEPTANCE {1} \
CONFIG.S03_READ_ACCEPTANCE {1} \
CONFIG.S03_WRITE_ACCEPTANCE {1} \
CONFIG.S04_READ_ACCEPTANCE {1} \
CONFIG.S04_WRITE_ACCEPTANCE {1} \
CONFIG.S05_READ_ACCEPTANCE {1} \
CONFIG.S05_WRITE_ACCEPTANCE {1} \
CONFIG.S06_READ_ACCEPTANCE {1} \
CONFIG.S06_WRITE_ACCEPTANCE {1} \
CONFIG.S07_READ_ACCEPTANCE {1} \
CONFIG.S07_WRITE_ACCEPTANCE {1} \
CONFIG.S08_READ_ACCEPTANCE {1} \
CONFIG.S08_WRITE_ACCEPTANCE {1} \
CONFIG.S09_READ_ACCEPTANCE {1} \
CONFIG.S09_WRITE_ACCEPTANCE {1} \
CONFIG.S10_READ_ACCEPTANCE {1} \
CONFIG.S10_WRITE_ACCEPTANCE {1} \
CONFIG.S11_READ_ACCEPTANCE {1} \
CONFIG.S11_WRITE_ACCEPTANCE {1} \
CONFIG.S12_READ_ACCEPTANCE {1} \
CONFIG.S12_WRITE_ACCEPTANCE {1} \
CONFIG.S13_READ_ACCEPTANCE {1} \
CONFIG.S13_WRITE_ACCEPTANCE {1} \
CONFIG.S14_READ_ACCEPTANCE {1} \
CONFIG.S14_WRITE_ACCEPTANCE {1} \
CONFIG.S15_READ_ACCEPTANCE {1} \
CONFIG.S15_WRITE_ACCEPTANCE {1} \
 ] $axi_crossbar_data_uncacheable

  # Create instance: axi_gpio_jtag_reset, and set properties
  set axi_gpio_jtag_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_jtag_reset ]
  set_property -dict [ list \
CONFIG.C_ALL_OUTPUTS {1} \
CONFIG.C_ALL_OUTPUTS_2 {1} \
CONFIG.C_DOUT_DEFAULT {0x00000001} \
CONFIG.C_DOUT_DEFAULT_2 {0x00000001} \
CONFIG.C_GPIO2_WIDTH {1} \
CONFIG.C_GPIO_WIDTH {1} \
CONFIG.C_IS_DUAL {1} \
CONFIG.GPIO_BOARD_INTERFACE {Custom} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_jtag_reset

  # Create instance: axi_gpio_leds, and set properties
  set axi_gpio_leds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_leds ]
  set_property -dict [ list \
CONFIG.C_ALL_OUTPUTS_2 {1} \
CONFIG.C_DOUT_DEFAULT_2 {0x00000001} \
CONFIG.C_GPIO2_WIDTH {1} \
CONFIG.C_IS_DUAL {1} \
CONFIG.GPIO_BOARD_INTERFACE {leds_8bits} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_leds

  # Create instance: axi_interconnect_A4L_to_A4_PS7_GP0, and set properties
  set axi_interconnect_A4L_to_A4_PS7_GP0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_A4L_to_A4_PS7_GP0 ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {1} \
 ] $axi_interconnect_A4L_to_A4_PS7_GP0

  # Create instance: axi_interconnect_A4L_to_A4_PS7_HP1, and set properties
  set axi_interconnect_A4L_to_A4_PS7_HP1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_A4L_to_A4_PS7_HP1 ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {1} \
 ] $axi_interconnect_A4L_to_A4_PS7_HP1

  # Create instance: axi_interconnect_instruction_cached, and set properties
  set axi_interconnect_instruction_cached [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_instruction_cached ]

  # Create instance: axi_interconnect_jtag, and set properties
  set axi_interconnect_jtag [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_jtag ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
CONFIG.NUM_MI {2} \
CONFIG.NUM_SI {1} \
 ] $axi_interconnect_jtag

  # Create instance: blk_mem_gen_onchip, and set properties
  set blk_mem_gen_onchip [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_onchip ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {false} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {READ_FIRST} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_onchip

  # Create instance: clock
  create_hier_cell_clock [current_bd_instance .] clock

  # Create instance: edge_extender, and set properties
  set edge_extender [ create_bd_cell -type ip -vlnv user.org:user:edge_extender:1.0 edge_extender ]

  # Create instance: fit_timer, and set properties
  set fit_timer [ create_bd_cell -type ip -vlnv xilinx.com:ip:fit_timer:2.0 fit_timer ]
  set_property -dict [ list \
CONFIG.C_NO_CLOCKS {50000000} \
 ] $fit_timer

  # Create instance: idram, and set properties
  set idram [ create_bd_cell -type ip -vlnv user.org:user:idram:1.0 idram ]
  set_property -dict [ list \
CONFIG.SIZE {131072} \
 ] $idram

  # Create instance: jtag_axi, and set properties
  set jtag_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi ]
  set_property -dict [ list \
CONFIG.PROTOCOL {0} \
 ] $jtag_axi

  # Create instance: orca, and set properties
  set orca [ create_bd_cell -type ip -vlnv user.org:user:orca:1.0 orca ]
  set_property -dict [ list \
CONFIG.AXI_ENABLE {1} \
CONFIG.BRANCH_PREDICTORS {32} \
CONFIG.COUNTER_LENGTH {32} \
CONFIG.DIVIDE_ENABLE {1} \
CONFIG.ENABLE_EXCEPTIONS {1} \
CONFIG.ENABLE_EXT_INTERRUPTS {1} \
CONFIG.FAMILY {XILINX} \
CONFIG.ICACHE_BURST_EN {1} \
CONFIG.ICACHE_EXTERNAL_WIDTH {32} \
CONFIG.ICACHE_LINE_SIZE {16} \
CONFIG.ICACHE_SIZE {8192} \
CONFIG.INTERRUPT_VECTOR {0xC0000200} \
CONFIG.IUC_ADDR_BASE {0x80000000} \
CONFIG.IUC_ADDR_LAST {0xFFFFFFFF} \
CONFIG.LVE_ENABLE {0} \
CONFIG.MULTIPLY_ENABLE {1} \
CONFIG.NUM_EXT_INTERRUPTS {1} \
CONFIG.PIPELINE_STAGES {5} \
CONFIG.POWER_OPTIMIZED {0} \
CONFIG.RESET_VECTOR {0xC0000000} \
CONFIG.SCRATCHPAD_ADDR_BITS {10} \
CONFIG.SHIFTER_MAX_CYCLES {1} \
 ] $orca

  # Create instance: processing_system7, and set properties
  set processing_system7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7 ]
  set_property -dict [ list \
CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {32} \
CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {32} \
CONFIG.PCW_USE_M_AXI_GP0 {0} \
CONFIG.PCW_USE_S_AXI_GP0 {1} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.PCW_USE_S_AXI_HP1 {1} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7

  # Create instance: ps7_uart_monitor, and set properties
  set ps7_uart_monitor [ create_bd_cell -type ip -vlnv vectorblox.com:debug:ps7_uart_monitor:1.0 ps7_uart_monitor ]

  # Create instance: system_ila_orca_masters, and set properties
  set system_ila_orca_masters [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.0 system_ila_orca_masters ]
  set_property -dict [ list \
CONFIG.C_BRAM_CNT {3.5} \
CONFIG.C_DATA_DEPTH {1024} \
CONFIG.C_INPUT_PIPE_STAGES {1} \
CONFIG.C_MON_TYPE {INTERFACE} \
CONFIG.C_NUM_MONITOR_SLOTS {3} \
CONFIG.C_SLOT {0} \
CONFIG.C_SLOT_0_APC_EN {1} \
CONFIG.C_SLOT_0_AXI_AW_SEL {0} \
CONFIG.C_SLOT_0_AXI_AW_SEL_DATA {0} \
CONFIG.C_SLOT_0_AXI_AW_SEL_TRIG {0} \
CONFIG.C_SLOT_0_AXI_B_SEL {0} \
CONFIG.C_SLOT_0_AXI_B_SEL_DATA {0} \
CONFIG.C_SLOT_0_AXI_B_SEL_TRIG {0} \
CONFIG.C_SLOT_0_AXI_W_SEL {0} \
CONFIG.C_SLOT_0_AXI_W_SEL_DATA {0} \
CONFIG.C_SLOT_0_AXI_W_SEL_TRIG {0} \
CONFIG.C_SLOT_1_APC_EN {1} \
CONFIG.C_SLOT_1_AXI_AW_SEL {0} \
CONFIG.C_SLOT_1_AXI_AW_SEL_DATA {0} \
CONFIG.C_SLOT_1_AXI_AW_SEL_TRIG {0} \
CONFIG.C_SLOT_1_AXI_B_SEL {0} \
CONFIG.C_SLOT_1_AXI_B_SEL_DATA {0} \
CONFIG.C_SLOT_1_AXI_B_SEL_TRIG {0} \
CONFIG.C_SLOT_1_AXI_W_SEL {0} \
CONFIG.C_SLOT_1_AXI_W_SEL_DATA {0} \
CONFIG.C_SLOT_1_AXI_W_SEL_TRIG {0} \
CONFIG.C_SLOT_1_MAX_RD_BURSTS {4} \
CONFIG.C_SLOT_2_APC_EN {1} \
 ] $system_ila_orca_masters

  # Create instance: xlconstant_bypass_ps7_uart, and set properties
  set xlconstant_bypass_ps7_uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_bypass_ps7_uart ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $xlconstant_bypass_ps7_uart

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_interconnect_A4L_to_A4_PS7_GP0/S00_AXI] [get_bd_intf_pins ps7_uart_monitor/M_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_onchip_A4L/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_onchip/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_onchip_b_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_onchip_A4/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_onchip/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_crossbar_data_uncacheable_M00_AXI [get_bd_intf_pins axi_crossbar_data_uncacheable/M00_AXI] [get_bd_intf_pins idram/data]
  connect_bd_intf_net -intf_net axi_crossbar_data_uncacheable_M01_AXI [get_bd_intf_pins axi_crossbar_data_uncacheable/M01_AXI] [get_bd_intf_pins ps7_uart_monitor/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_data_uncacheable_M02_AXI [get_bd_intf_pins axi_crossbar_data_uncacheable/M02_AXI] [get_bd_intf_pins axi_gpio_leds/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_data_uncacheable_M03_AXI [get_bd_intf_pins axi_bram_ctrl_onchip_A4L/S_AXI] [get_bd_intf_pins axi_crossbar_data_uncacheable/M03_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_data_uncacheable_M04_AXI [get_bd_intf_pins axi_crossbar_data_uncacheable/M04_AXI] [get_bd_intf_pins axi_interconnect_A4L_to_A4_PS7_HP1/S00_AXI]
  connect_bd_intf_net -intf_net axi_gpio_leds_GPIO [get_bd_intf_ports leds_8bits] [get_bd_intf_pins axi_gpio_leds/GPIO]
  connect_bd_intf_net -intf_net axi_interconnect_A4L_to_A4_PS7_GP0_M00_AXI [get_bd_intf_pins axi_interconnect_A4L_to_A4_PS7_GP0/M00_AXI] [get_bd_intf_pins processing_system7/S_AXI_GP0]
  connect_bd_intf_net -intf_net axi_interconnect_A4L_to_A4_PS7_HP1_M00_AXI [get_bd_intf_pins axi_interconnect_A4L_to_A4_PS7_HP1/M00_AXI] [get_bd_intf_pins processing_system7/S_AXI_HP1]
  connect_bd_intf_net -intf_net axi_interconnect_A4L_to_A4_PS7_HP2_M00_AXI [get_bd_intf_pins axi_gpio_jtag_reset/S_AXI] [get_bd_intf_pins axi_interconnect_jtag/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_A4L_to_A4_PS7_HP2_M01_AXI [get_bd_intf_pins axi_crossbar_data_uncacheable/S01_AXI] [get_bd_intf_pins axi_interconnect_jtag/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_instruction_cached_M00_AXI [get_bd_intf_pins axi_interconnect_instruction_cached/M00_AXI] [get_bd_intf_pins processing_system7/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_interconnect_instruction_cached_M01_AXI [get_bd_intf_pins axi_bram_ctrl_onchip_A4/S_AXI] [get_bd_intf_pins axi_interconnect_instruction_cached/M01_AXI]
  connect_bd_intf_net -intf_net jtag_axi_M_AXI [get_bd_intf_pins axi_interconnect_jtag/S00_AXI] [get_bd_intf_pins jtag_axi/M_AXI]
  connect_bd_intf_net -intf_net orca_DUC [get_bd_intf_pins axi_crossbar_data_uncacheable/S00_AXI] [get_bd_intf_pins orca/DUC]
connect_bd_intf_net -intf_net [get_bd_intf_nets orca_DUC] [get_bd_intf_pins orca/DUC] [get_bd_intf_pins system_ila_orca_masters/SLOT_2_AXI]
  connect_bd_intf_net -intf_net orca_IC [get_bd_intf_pins axi_interconnect_instruction_cached/S00_AXI] [get_bd_intf_pins orca/IC]
connect_bd_intf_net -intf_net [get_bd_intf_nets orca_IC] [get_bd_intf_pins orca/IC] [get_bd_intf_pins system_ila_orca_masters/SLOT_1_AXI]
  connect_bd_intf_net -intf_net orca_IUC [get_bd_intf_pins idram/instr] [get_bd_intf_pins orca/IUC]
connect_bd_intf_net -intf_net [get_bd_intf_nets orca_IUC] [get_bd_intf_pins orca/IUC] [get_bd_intf_pins system_ila_orca_masters/SLOT_0_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7/FIXED_IO]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_interconnect_jtag/ARESETN] [get_bd_pins clock/interconnect_aresetn_jtag]
  connect_bd_net -net axi_gpio_jtag_reset_gpio2_io_o [get_bd_pins axi_gpio_jtag_reset/gpio2_io_o] [get_bd_pins clock/system_resetn_in]
  connect_bd_net -net axi_gpio_jtag_reset_gpio_io_o [get_bd_pins axi_gpio_jtag_reset/gpio_io_o] [get_bd_pins clock/cpu_resetn_in]
  connect_bd_net -net axi_gpio_leds_gpio2_io_o [get_bd_pins axi_gpio_leds/gpio2_io_o] [get_bd_pins fit_timer/Rst]
  connect_bd_net -net clock_clk_2x_out -boundary_type upper [get_bd_pins clock/clk_2x_out]
  connect_bd_net -net clock_clk_out [get_bd_pins axi_bram_ctrl_onchip_A4/s_axi_aclk] [get_bd_pins axi_bram_ctrl_onchip_A4L/s_axi_aclk] [get_bd_pins axi_crossbar_data_uncacheable/aclk] [get_bd_pins axi_gpio_jtag_reset/s_axi_aclk] [get_bd_pins axi_gpio_leds/s_axi_aclk] [get_bd_pins axi_interconnect_A4L_to_A4_PS7_GP0/ACLK] [get_bd_pins axi_interconnect_A4L_to_A4_PS7_GP0/M00_ACLK] [get_bd_pins axi_interconnect_A4L_to_A4_PS7_GP0/S00_ACLK] [get_bd_pins axi_interconnect_A4L_to_A4_PS7_HP1/ACLK] [get_bd_pins axi_interconnect_A4L_to_A4_PS7_HP1/S00_ACLK] [get_bd_pins axi_interconnect_instruction_cached/ACLK] [get_bd_pins axi_interconnect_instruction_cached/M01_ACLK] [get_bd_pins axi_interconnect_instruction_cached/S00_ACLK] [get_bd_pins axi_interconnect_jtag/ACLK] [get_bd_pins axi_interconnect_jtag/M00_ACLK] [get_bd_pins axi_interconnect_jtag/M01_ACLK] [get_bd_pins axi_interconnect_jtag/S00_ACLK] [get_bd_pins clock/clk_out] [get_bd_pins edge_extender/clk] [get_bd_pins fit_timer/Clk] [get_bd_pins idram/clk] [get_bd_pins jtag_axi/aclk] [get_bd_pins orca/clk] [get_bd_pins processing_system7/S_AXI_GP0_ACLK] [get_bd_pins ps7_uart_monitor/axi_aclk] [get_bd_pins system_ila_orca_masters/clk]
  connect_bd_net -net clock_interconnect_aresetn [get_bd_pins axi_crossbar_data_uncacheable/aresetn] [get_bd_pins axi_interconnect_A4L_to_A4_PS7_GP0/ARESETN] [get_bd_pins axi_interconnect_A4L_to_A4_PS7_HP1/ARESETN] [get_bd_pins axi_interconnect_instruction_cached/ARESETN] [get_bd_pins clock/interconnect_aresetn]
  connect_bd_net -net clock_peripheral_aresetn [get_bd_pins axi_bram_ctrl_onchip_A4/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_onchip_A4L/s_axi_aresetn] [get_bd_pins axi_gpio_leds/s_axi_aresetn] [get_bd_pins axi_interconnect_A4L_to_A4_PS7_GP0/M00_ARESETN] [get_bd_pins axi_interconnect_A4L_to_A4_PS7_GP0/S00_ARESETN] [get_bd_pins axi_interconnect_A4L_to_A4_PS7_HP1/S00_ARESETN] [get_bd_pins axi_interconnect_instruction_cached/M01_ARESETN] [get_bd_pins axi_interconnect_instruction_cached/S00_ARESETN] [get_bd_pins axi_interconnect_jtag/M01_ARESETN] [get_bd_pins clock/peripheral_aresetn] [get_bd_pins ps7_uart_monitor/axi_aresetn] [get_bd_pins system_ila_orca_masters/resetn]
  connect_bd_net -net clock_peripheral_aresetn_jtag [get_bd_pins axi_gpio_jtag_reset/s_axi_aresetn] [get_bd_pins axi_interconnect_jtag/M00_ARESETN] [get_bd_pins axi_interconnect_jtag/S00_ARESETN] [get_bd_pins clock/peripheral_aresetn_jtag] [get_bd_pins jtag_axi/aresetn]
  connect_bd_net -net clock_peripheral_reset [get_bd_pins clock/peripheral_reset] [get_bd_pins edge_extender/reset] [get_bd_pins idram/reset]
  connect_bd_net -net clock_peripheral_reset_cpu [get_bd_pins clock/peripheral_reset_cpu] [get_bd_pins orca/reset]
  connect_bd_net -net edge_extender_0_interrupt_out [get_bd_pins edge_extender/interrupt_out] [get_bd_pins orca/global_interrupts]
  connect_bd_net -net fit_timer_Interrupt [get_bd_pins edge_extender/interrupt_in] [get_bd_pins fit_timer/Interrupt]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_interconnect_A4L_to_A4_PS7_HP1/M00_ACLK] [get_bd_pins axi_interconnect_instruction_cached/M00_ACLK] [get_bd_pins clock/clk_in1] [get_bd_pins processing_system7/FCLK_CLK0] [get_bd_pins processing_system7/S_AXI_HP0_ACLK] [get_bd_pins processing_system7/S_AXI_HP1_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins axi_interconnect_A4L_to_A4_PS7_HP1/M00_ARESETN] [get_bd_pins axi_interconnect_instruction_cached/M00_ARESETN] [get_bd_pins clock/ext_resetn_in] [get_bd_pins processing_system7/FCLK_RESET0_N]
  connect_bd_net -net xlconstant_bypass_ps7_uart_dout [get_bd_pins ps7_uart_monitor/bypass] [get_bd_pins xlconstant_bypass_ps7_uart/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00020000 -offset 0xD0000000 [get_bd_addr_spaces jtag_axi/Data] [get_bd_addr_segs axi_bram_ctrl_onchip_A4L/S_AXI/Mem0] SEG_axi_bram_ctrl_onchip_A4L_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 [get_bd_addr_spaces jtag_axi/Data] [get_bd_addr_segs axi_gpio_jtag_reset/S_AXI/Reg] SEG_axi_gpio_jtag_reset_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xFFFF0000 [get_bd_addr_spaces jtag_axi/Data] [get_bd_addr_segs axi_gpio_leds/S_AXI/Reg] SEG_axi_gpio_leds_Reg
  create_bd_addr_seg -range 0x10000000 -offset 0xC0000000 [get_bd_addr_spaces jtag_axi/Data] [get_bd_addr_segs idram/data/reg0] SEG_idram_reg0
  create_bd_addr_seg -range 0x20000000 -offset 0x80000000 [get_bd_addr_spaces jtag_axi/Data] [get_bd_addr_segs processing_system7/S_AXI_GP0/GP0_DDR_LOWOCM] SEG_processing_system7_0_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces jtag_axi/Data] [get_bd_addr_segs processing_system7/S_AXI_GP0/GP0_IOP] SEG_processing_system7_0_GP0_IOP
  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces jtag_axi/Data] [get_bd_addr_segs processing_system7/S_AXI_GP0/GP0_QSPI_LINEAR] SEG_processing_system7_0_GP0_QSPI_LINEAR
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces jtag_axi/Data] [get_bd_addr_segs processing_system7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x00020000 -offset 0x50000000 [get_bd_addr_spaces orca/IC] [get_bd_addr_segs axi_bram_ctrl_onchip_A4/S_AXI/Mem0] SEG_axi_bram_ctrl_onchip_A4_Mem0
  create_bd_addr_seg -range 0x00020000 -offset 0xD0000000 [get_bd_addr_spaces orca/DUC] [get_bd_addr_segs axi_bram_ctrl_onchip_A4L/S_AXI/Mem0] SEG_axi_bram_ctrl_onchip_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0xFFFF0000 [get_bd_addr_spaces orca/DUC] [get_bd_addr_segs axi_gpio_leds/S_AXI/Reg] SEG_axi_gpio_leds_Reg
  create_bd_addr_seg -range 0x10000000 -offset 0xC0000000 [get_bd_addr_spaces orca/DUC] [get_bd_addr_segs idram/data/reg0] SEG_idram_reg0
  create_bd_addr_seg -range 0x10000000 -offset 0xC0000000 [get_bd_addr_spaces orca/IUC] [get_bd_addr_segs idram/instr/reg0] SEG_idram_reg0
  create_bd_addr_seg -range 0x20000000 -offset 0x80000000 [get_bd_addr_spaces orca/DUC] [get_bd_addr_segs processing_system7/S_AXI_GP0/GP0_DDR_LOWOCM] SEG_processing_system7_0_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces orca/DUC] [get_bd_addr_segs processing_system7/S_AXI_GP0/GP0_IOP] SEG_processing_system7_0_GP0_IOP
  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces orca/DUC] [get_bd_addr_segs processing_system7/S_AXI_GP0/GP0_QSPI_LINEAR] SEG_processing_system7_0_GP0_QSPI_LINEAR
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces orca/IC] [get_bd_addr_segs processing_system7/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces orca/DUC] [get_bd_addr_segs processing_system7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


