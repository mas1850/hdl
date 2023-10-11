vlib work
vcom -93 -work work ../../src/synchronizer.vhd
vcom -93 -work work ../src/synchronizer_tb.vhd
vsim -voptargs=+acc synchronizer_tb
do wave.do
run 1 us
