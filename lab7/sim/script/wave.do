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
add wave -noupdate -radix decimal /calculator3_tb/uut/in_switches
add wave -noupdate -radix binary /calculator3_tb/uut/op_switches
add wave -noupdate /calculator3_tb/uut/ms_btn
add wave -noupdate /calculator3_tb/uut/mr_btn
add wave -noupdate /calculator3_tb/uut/exe_btn
add wave -noupdate /calculator3_tb/uut/clk
add wave -noupdate /calculator3_tb/uut/reset_n
add wave -noupdate /calculator3_tb/uut/in_sync
add wave -noupdate /calculator3_tb/uut/op_sync
add wave -noupdate /calculator3_tb/uut/ms_sync
add wave -noupdate /calculator3_tb/uut/mr_sync
add wave -noupdate /calculator3_tb/uut/exe_sync
add wave -noupdate /calculator3_tb/uut/write_en
add wave -noupdate -radix binary /calculator3_tb/uut/address
add wave -noupdate /calculator3_tb/uut/pres_state
add wave -noupdate -radix States /calculator3_tb/uut/state_led
add wave -noupdate /calculator3_tb/uut/next_state
add wave -noupdate -radix unsigned /calculator3_tb/uut/directory
add wave -noupdate -radix unsigned /calculator3_tb/uut/alu_out
add wave -noupdate -radix unsigned /calculator3_tb/uut/res
add wave -noupdate -radix unsigned /calculator3_tb/uut/res_padded
add wave -noupdate -radix unsigned /calculator3_tb/uut/bin_hund
add wave -noupdate -radix unsigned /calculator3_tb/uut/bin_tens
add wave -noupdate -radix unsigned /calculator3_tb/uut/bin_ones
add wave -noupdate -radix SevenSeg /calculator3_tb/uut/ssd_hund
add wave -noupdate -radix SevenSeg /calculator3_tb/uut/ssd_tens
add wave -noupdate -radix SevenSeg /calculator3_tb/uut/ssd_ones
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
WaveRestoreZoom {0 ns} {364 ns}
