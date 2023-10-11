vlib work
vcom -93 -work work ../../src/calculator.vhd
vcom -93 -work work ../src/calculator_tb.vhd
vcom -93 -work work ../../src/seven_seg/src/seven_seg.vhd
vsim -voptargs=+acc calculator_tb
do wave.do
run 500 ns
