vlib work
vcom -93 -work work ../../src/processor.vhd
vcom -93 -work work ../src/processor_tb.vhd
vcom -93 -work work ../../src/calculator3.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/synchronizer_8bit.vhd
vcom -93 -work work ../../src/synchronizer_2bit.vhd
vcom -93 -work work ../../src/alu.vhd
vcom -93 -work work ../../src/double_dabble/src/double_dabble.vhd
vcom -93 -work work ../../src/memory/src/memory.vhd
vcom -93 -work work ../../src/rom/blink_rom.vhd
vsim -voptargs=+acc processor_tb
do wave.do
run 2000 ns
