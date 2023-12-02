# M.A.Schneider
# Quartus II compile script for DE1-SoC board

# 1] name your project here
set project_name "calculator3"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE 5CSEMA5F31C6 
set_global_assignment -name TOP_LEVEL_ENTITY calculator3
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
set_global_assignment -name VHDL_FILE ../../src/calculator3.vhd
set_global_assignment -name VHDL_FILE ../../src/rising_edge_synchronizer.vhd
set_global_assignment -name VHDL_FILE ../../src/synchronizer_8bit.vhd
set_global_assignment -name VHDL_FILE ../../src/synchronizer_2bit.vhd
set_global_assignment -name VHDL_FILE ../../src/alu.vhd
set_global_assignment -name VHDL_FILE ../../src/seven_seg.vhd
set_global_assignment -name VHDL_FILE ../../src/double_dabble/src/double_dabble.vhd
set_global_assignment -name VHDL_FILE ../../src/memory/src/memory.vhd

set_location_assignment PIN_AF14 -to clk
set_location_assignment PIN_AA14 -to reset_n
set_location_assignment PIN_AA15 -to mr_btn
set_location_assignment PIN_W15  -to ms_btn
set_location_assignment PIN_Y16  -to exe_btn

set_location_assignment PIN_V16  -to state_led[0]
set_location_assignment PIN_W16  -to state_led[1]
set_location_assignment PIN_V17  -to state_led[2]
set_location_assignment PIN_V18  -to state_led[3]
set_location_assignment PIN_W17  -to state_led[4]

set_location_assignment PIN_AB12 -to in_switches[0]
set_location_assignment PIN_AC12 -to in_switches[1]
set_location_assignment PIN_AF9  -to in_switches[2]
set_location_assignment PIN_AF10 -to in_switches[3]
set_location_assignment PIN_AD11 -to in_switches[4]
set_location_assignment PIN_AD12 -to in_switches[5]
set_location_assignment PIN_AE11 -to in_switches[6]
set_location_assignment PIN_AC9  -to in_switches[7]

set_location_assignment PIN_AD10 -to op_switches[0]
set_location_assignment PIN_AE12 -to op_switches[1]

set_location_assignment PIN_AE26 -to ssd_ones[0]
set_location_assignment PIN_AE27 -to ssd_ones[1]
set_location_assignment PIN_AE28 -to ssd_ones[2]
set_location_assignment PIN_AG27 -to ssd_ones[3]
set_location_assignment PIN_AF28 -to ssd_ones[4]
set_location_assignment PIN_AG28 -to ssd_ones[5]
set_location_assignment PIN_AH28 -to ssd_ones[6]

set_location_assignment PIN_AJ29 -to ssd_tens[0]
set_location_assignment PIN_AH29 -to ssd_tens[1]
set_location_assignment PIN_AH30 -to ssd_tens[2]
set_location_assignment PIN_AG30 -to ssd_tens[3]
set_location_assignment PIN_AF29 -to ssd_tens[4]
set_location_assignment PIN_AF30 -to ssd_tens[5]
set_location_assignment PIN_AD27 -to ssd_tens[6]

set_location_assignment PIN_AB23 -to ssd_hund[0]
set_location_assignment PIN_AE29 -to ssd_hund[1]
set_location_assignment PIN_AD29 -to ssd_hund[2]
set_location_assignment PIN_AC28 -to ssd_hund[3]
set_location_assignment PIN_AD30 -to ssd_hund[4]
set_location_assignment PIN_AC29 -to ssd_hund[5]
set_location_assignment PIN_AC30 -to ssd_hund[6]

# set_location_assignment PIN_AD26 -to bcd_3[0]
# set_location_assignment PIN_AC27 -to bcd_3[1]
# set_location_assignment PIN_AD25 -to bcd_3[2]
# set_location_assignment PIN_AC25 -to bcd_3[3]
# set_location_assignment PIN_AB28 -to bcd_3[4]
# set_location_assignment PIN_AB25 -to bcd_3[5]
# set_location_assignment PIN_AB22 -to bcd_3[6]

# set_location_assignment PIN_AA24 -to bcd_4[0]
# set_location_assignment PIN_Y23  -to bcd_4[1]
# set_location_assignment PIN_Y24  -to bcd_4[2]
# set_location_assignment PIN_W22  -to bcd_4[3]
# set_location_assignment PIN_W24  -to bcd_4[4]
# set_location_assignment PIN_V23  -to bcd_4[5]
# set_location_assignment PIN_W25  -to bcd_4[6]

# set_location_assignment PIN_V25  -to bcd_5[0]
# set_location_assignment PIN_AA28 -to bcd_5[1]
# set_location_assignment PIN_Y27  -to bcd_5[2]
# set_location_assignment PIN_AB27 -to bcd_5[3]
# set_location_assignment PIN_AB26 -to bcd_5[4]
# set_location_assignment PIN_AA26 -to bcd_5[5]
# set_location_assignment PIN_AA25 -to bcd_5[6]

execute_flow -compile
project_close