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
add wave -noupdate /calculator_tb/uut/clk
add wave -noupdate /calculator_tb/uut/reset
add wave -noupdate /calculator_tb/uut/a_in
add wave -noupdate /calculator_tb/uut/a_synced
add wave -noupdate /calculator_tb/uut/a_padded
add wave -noupdate /calculator_tb/uut/b_in
add wave -noupdate /calculator_tb/uut/b_synced
add wave -noupdate /calculator_tb/uut/b_padded
add wave -noupdate /calculator_tb/uut/res
add wave -noupdate /calculator_tb/add_btn
add wave -noupdate /calculator_tb/uut/add_synced
add wave -noupdate /calculator_tb/sub_btn
add wave -noupdate /calculator_tb/uut/sub_synced
add wave -noupdate /calculator_tb/uut/flag
add wave -noupdate -radix States /calculator_tb/uut/a_out
add wave -noupdate -radix States /calculator_tb/uut/b_out
add wave -noupdate -radix States /calculator_tb/uut/res_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9 ns} 0}
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
WaveRestoreZoom {0 ns} {731 ns}
