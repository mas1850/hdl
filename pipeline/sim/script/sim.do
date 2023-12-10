vlib work
vcom -93 -work work ../../src/generic_counter.vhd
vcom -93 -work work ../../src/pipeline.vhd
vcom -93 -work work ../src/pipeline_tb.vhd
vsim -voptargs=+acc pipeline_tb
do wave.do
run 2000 ns