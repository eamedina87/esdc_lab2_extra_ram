
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2014.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z010clg400-1
#    set_property BOARD_PART digilentinc.com:zybo:part0:1.0 [current_project]


# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}


# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set btn [ create_bd_port -dir I -from 3 -to 0 btn ]
  set led [ create_bd_port -dir O -from 3 -to 0 led ]
  set sw [ create_bd_port -dir I -from 3 -to 0 sw ]
  set sys_clock [ create_bd_port -dir I -type clk sys_clock ]
  set_property -dict [ list CONFIG.FREQ_HZ {125000000} CONFIG.PHASE {0.000}  ] $sys_clock
  set vga_b [ create_bd_port -dir O -from 4 -to 0 vga_b ]
  set vga_g [ create_bd_port -dir O -from 5 -to 0 vga_g ]
  set vga_hs [ create_bd_port -dir O vga_hs ]
  set vga_r [ create_bd_port -dir O -from 4 -to 0 vga_r ]
  set vga_vs [ create_bd_port -dir O vga_vs ]

  # Create instance: VGA_SYNC_0, and set properties
  set VGA_SYNC_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:VGA_SYNC:1.0 VGA_SYNC_0 ]

  # Create instance: add_generator_0, and set properties
  set add_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:add_generator:1.0 add_generator_0 ]

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_0 ]
  set_property -dict [ list CONFIG.Assume_Synchronous_Clk {true} CONFIG.Byte_Size {9} CONFIG.Enable_32bit_Address {false} CONFIG.Enable_A {Always_Enabled} CONFIG.Enable_B {Always_Enabled} CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Operating_Mode_B {READ_FIRST} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100} CONFIG.Read_Width_A {3} CONFIG.Read_Width_B {3} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {true} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Write_Depth_A {131072} CONFIG.Write_Width_A {3} CONFIG.Write_Width_B {3} CONFIG.use_bram_block {Stand_Alone}  ] $blk_mem_gen_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_0 ]
  set_property -dict [ list CONFIG.CLKIN1_JITTER_PS {80.0} CONFIG.CLKOUT1_JITTER {313.937} CONFIG.CLKOUT1_PHASE_ERROR {246.739} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25.000} CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} CONFIG.MMCM_CLKFBOUT_MULT_F {36.375} CONFIG.MMCM_CLKIN1_PERIOD {8.0} CONFIG.MMCM_CLKOUT0_DIVIDE_F {36.375} CONFIG.MMCM_DIVCLK_DIVIDE {5} CONFIG.PRIM_IN_FREQ {125} CONFIG.USE_BOARD_FLOW {true}  ] $clk_wiz_0

  # Create instance: session4_0, and set properties
  set session4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:session4:1.0 session4_0 ]

  # Create port connections
  connect_bd_net -net VGA_SYNC_0_pixel_column [get_bd_pins VGA_SYNC_0/pixel_column] [get_bd_pins add_generator_0/pixel_column]
  connect_bd_net -net VGA_SYNC_0_pixel_row [get_bd_pins VGA_SYNC_0/pixel_row] [get_bd_pins add_generator_0/pixel_row]
  connect_bd_net -net VGA_SYNC_0_vga_b [get_bd_ports vga_b] [get_bd_pins VGA_SYNC_0/vga_b]
  connect_bd_net -net VGA_SYNC_0_vga_g [get_bd_ports vga_g] [get_bd_pins VGA_SYNC_0/vga_g]
  connect_bd_net -net VGA_SYNC_0_vga_hs [get_bd_ports vga_hs] [get_bd_pins VGA_SYNC_0/vga_hs]
  connect_bd_net -net VGA_SYNC_0_vga_r [get_bd_ports vga_r] [get_bd_pins VGA_SYNC_0/vga_r]
  connect_bd_net -net VGA_SYNC_0_vga_vs [get_bd_ports vga_vs] [get_bd_pins VGA_SYNC_0/vga_vs] [get_bd_pins session4_0/vga_vs]
  connect_bd_net -net add_generator_0_adr_memo [get_bd_pins add_generator_0/adr_memo] [get_bd_pins blk_mem_gen_0/addrb]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins VGA_SYNC_0/color_in] [get_bd_pins blk_mem_gen_0/doutb]
  connect_bd_net -net btn_1 [get_bd_ports btn] [get_bd_pins session4_0/btn]
  connect_bd_net -net f_div5_0_clkout [get_bd_pins VGA_SYNC_0/clock_25Mhz] [get_bd_pins blk_mem_gen_0/clka] [get_bd_pins blk_mem_gen_0/clkb] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins session4_0/clk_25]
  connect_bd_net -net session4_0_adr_memo [get_bd_pins blk_mem_gen_0/addra] [get_bd_pins session4_0/adr_memo]
  connect_bd_net -net session4_0_data [get_bd_pins blk_mem_gen_0/dina] [get_bd_pins session4_0/data]
  connect_bd_net -net session4_0_led [get_bd_ports led] [get_bd_pins session4_0/led]
  connect_bd_net -net session4_0_wr_memo [get_bd_pins blk_mem_gen_0/wea] [get_bd_pins session4_0/wr_memo]
  connect_bd_net -net sw_1 [get_bd_ports sw] [get_bd_pins session4_0/sw]
  connect_bd_net -net sys_clock_1 [get_bd_ports sys_clock] [get_bd_pins clk_wiz_0/clk_in1]

  # Create address segments
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


