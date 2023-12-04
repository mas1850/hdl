vlib work
vcom -93 -work work ../../src/rom/blink_rom.vhd
vcom -93 -work work ../../src/generic_counter.vhd
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/blink_block_mem.vhd
vcom -93 -work work ../src/blink_block_mem_tb.vhd
vsim -voptargs=+acc blink_block_mem_tb
do wave.do
run 5 us
