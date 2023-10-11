# M.A.Schneider
# Quartus II compile script for DE1-SoC  board

# 1] name your project here
set project_name "bcd"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE 5CSEMA5F31C6 
set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
set_global_assignment -name VHDL_FILE ../../src/top.vhd
set_global_assignment -name VHDL_FILE ../../src/generic_adder_beh/src/generic_adder_beh.vhd
set_global_assignment -name VHDL_FILE ../../src/generic_counter/src/generic_counter.vhd
set_global_assignment -name VHDL_FILE ../../src/seven_seg/src/seven_seg.vhd

# 3] set your pin constraints here
set_location_assignment PIN_AB12 -to reset
set_location_assignment PIN_AF14 -to clk

set_location_assignment PIN_AA24 -to output[0]
set_location_assignment PIN_Y23  -to output[1]
set_location_assignment PIN_Y24  -to output[2]
set_location_assignment PIN_W22  -to output[3]
set_location_assignment PIN_W24  -to output[4]
set_location_assignment PIN_V23  -to output[5]
set_location_assignment PIN_W25  -to output[6]

execute_flow -compile
project_close