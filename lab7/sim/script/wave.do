onerror {resume}
radix define SevenSeg {
    "7'b1000000" "0" -color "purple",
    "7'b1111001" "1" -color "purple",
    "7'b0100100" "2" -color "purple",
    "7'b0110000" "3" -color "purple",
    "7'b0011001" "4" -color "purple",
    "7'b0010010" "5" -color "purple",
    "7'b0000010" "6" -color "purple",
    "7'b1111000" "7" -color "purple",
    "7'b0000000" "8" -color "purple",
    "7'b0011000" "9" -color "purple",
    "7'b0001000" "A" -color "purple",
    "7'b0000011" "b" -color "purple",
    "7'b1000110" "C" -color "purple",
    "7'b0100001" "d" -color "purple",
    "7'b0000110" "E" -color "purple",
    "7'b0001110" "F" -color "purple",
    "7'b0111111" "-" -color "red",
    -default default
}
radix define States {
    "5'b10000" "R_W" -color "pink",
    "5'b01000" "WW_No_Op" -color "pink",
    "5'b00100" "W_W" -color "pink",
    "5'b00010" "W_S" -color "pink",
    "5'b00001" "R_S" -color "pink",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /processor_tb/execute_btn
add wave -noupdate /processor_tb/reset_n
add wave -noupdate /processor_tb/clk
add wave -noupdate /processor_tb/uut/state_led
add wave -noupdate /processor_tb/uut/ssd_hund
add wave -noupdate /processor_tb/uut/ssd_tens
add wave -noupdate /processor_tb/uut/ssd_ones
add wave -noupdate /processor_tb/uut/execute_sync
add wave -noupdate /processor_tb/uut/address_sig
add wave -noupdate /processor_tb/uut/instruction
add wave -noupdate /processor_tb/uut/in_switches
add wave -noupdate /processor_tb/uut/op_switches
add wave -noupdate /processor_tb/uut/exe_btn
add wave -noupdate /processor_tb/uut/mr_btn
add wave -noupdate /processor_tb/uut/ms_btn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {121 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 57
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {655 ns} {1019 ns}
