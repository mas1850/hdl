onerror {resume}
radix define States {
    "7'b1000000" "0" -color "blue",
    "7'b1111001" "1" -color "blue",
    "7'b0100100" "2" -color "blue",
    "7'b0110000" "3" -color "blue",
    "7'b0011001" "4" -color "blue",
    "7'b0010010" "5" -color "blue",
    "7'b0000010" "6" -color "blue",
    "7'b1111000" "7" -color "blue",
    "7'b0000000" "8" -color "blue",
    "7'b0011000" "9" -color "blue",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pipeline_tb/uut/clk
add wave -noupdate /pipeline_tb/reset
add wave -noupdate -radix unsigned /pipeline_tb/uut/a
add wave -noupdate -radix unsigned /pipeline_tb/uut/result_temp
add wave -noupdate -radix unsigned /pipeline_tb/uut/result
add wave -noupdate -radix unsigned /pipeline_tb/uut/result_async
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {89 ns} 0}
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
WaveRestoreZoom {0 ns} {532 ns}
