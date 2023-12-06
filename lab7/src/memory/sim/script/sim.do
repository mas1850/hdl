vlib work
vcom -93 -work work ../../src/memory.vhd
vcom -93 -work work ../src/memory_tb.vhd
vsim -voptargs=+acc memory_tb
do wave.do
run 200 ns
