vlib work
vcom -93 -work work ../../src/calculator.vhd
vcom -93 -work work ../src/calculator_tb.vhd
vcom -93 -work work ../../src/generic_counter.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/synchronizer_3bit.vhd
vsim -voptargs=+acc calculator_tb
do wave.do
run 2700 ns
