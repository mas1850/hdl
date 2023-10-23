vlib work
vcom -93 -work work ../../src/calculator2.vhd
vcom -93 -work work ../src/calculator2_tb.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/synchronizer_8bit.vhd
vcom -93 -work work ../../src/double_dabble/src/double_dabble.vhd
vsim -voptargs=+acc calculator2_tb
do wave.do
run 2700 ns
