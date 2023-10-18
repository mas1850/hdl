# M.A.Schneider
# 10/18/23
# Quartus II compile script for DE1-SoC board

# 1] name your project here
set project_name "calculator"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE 5CSEMA5F31C6 
set_global_assignment -name TOP_LEVEL_ENTITY calculator
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
set_global_assignment -name VHDL_FILE ../../src/calculator.vhd
set_global_assignment -name VHDL_FILE ../../src/rising_edge_synchronizer.vhd
set_global_assignment -name VHDL_FILE ../../src/seven_seg.vhd
set_global_assignment -name VHDL_FILE ../../src/generic_counter.vhd
set_global_assignment -name VHDL_FILE ../../src/synchronizer_3bit.vhd

set_location_assignment PIN_AB12 -to reset
set_location_assignment PIN_AF14 -to clk
set_location_assignment PIN_AC9  -to a_in[0]
set_location_assignment PIN_AD10 -to a_in[1]
set_location_assignment PIN_AE12 -to a_in[2]
set_location_assignment PIN_AD11 -to b_in[0]
set_location_assignment PIN_AD12 -to b_in[1]
set_location_assignment PIN_AE11 -to b_in[2]

set_location_assignment PIN_AA24 -to a_out[0]
set_location_assignment PIN_Y23  -to a_out[1]
set_location_assignment PIN_Y24  -to a_out[2]
set_location_assignment PIN_W22  -to a_out[3]
set_location_assignment PIN_W24  -to a_out[4]
set_location_assignment PIN_V23  -to a_out[5]
set_location_assignment PIN_W25  -to a_out[6]

set_location_assignment PIN_AB23 -to b_out[0]
set_location_assignment PIN_AE29 -to b_out[1]
set_location_assignment PIN_AD29 -to b_out[2]
set_location_assignment PIN_AC28 -to b_out[3]
set_location_assignment PIN_AD30 -to b_out[4]
set_location_assignment PIN_AC29 -to b_out[5]
set_location_assignment PIN_AC30 -to b_out[6]

set_location_assignment PIN_AE26 -to res_out[0]
set_location_assignment PIN_AE27 -to res_out[1]
set_location_assignment PIN_AE28 -to res_out[2]
set_location_assignment PIN_AG27 -to res_out[3]
set_location_assignment PIN_AF28 -to res_out[4]
set_location_assignment PIN_AG28 -to res_out[5]
set_location_assignment PIN_AH28 -to res_out[6]

set_location_assignment PIN_AA15 -to add_btn
set_location_assignment PIN_AA14 -to sub_btn

execute_flow -compile
project_close