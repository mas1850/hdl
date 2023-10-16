vlib work
vcom -93 -work work ../../src/alu_and.vhd
vcom -93 -work work ../../src/alu_or.vhd
vcom -93 -work work ../../src/alu_xor.vhd
vcom -93 -work work ../../src/full_adder_single_bit_beh.vhd
vcom -93 -work work ../src/full_adder_single_bit_beh_tb.vhd
vsim -voptargs=+acc full_adder_single_bit_beh_tb
do wave.do
run 100 ns
