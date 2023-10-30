onerror {resume}
radix define States {
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
quietly WaveActivateNextPane {} 0
add wave -noupdate /calculator2_tb/clk
add wave -noupdate /calculator2_tb/reset
add wave -noupdate -radix unsigned /calculator2_tb/in_switches
add wave -noupdate -radix unsigned /calculator2_tb/uut/in_sync
add wave -noupdate -radix unsigned /calculator2_tb/uut/in_a
add wave -noupdate -radix unsigned /calculator2_tb/uut/in_b
add wave -noupdate /calculator2_tb/btn
add wave -noupdate /calculator2_tb/uut/btn_sync
add wave -noupdate /calculator2_tb/uut/state_led
add wave -noupdate /calculator2_tb/uut/pres_state
add wave -noupdate /calculator2_tb/uut/next_state
add wave -noupdate -radix unsigned /calculator2_tb/uut/res
add wave -noupdate -radix unsigned /calculator2_tb/uut/res_padded
add wave -noupdate /calculator2_tb/uut/bin_hund
add wave -noupdate /calculator2_tb/uut/bin_tens
add wave -noupdate /calculator2_tb/uut/bin_ones
add wave -noupdate -radix States /calculator2_tb/uut/ssd_hund
add wave -noupdate -radix States /calculator2_tb/uut/ssd_tens
add wave -noupdate -radix States /calculator2_tb/uut/ssd_ones
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {478 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ns} {2940 ns}
