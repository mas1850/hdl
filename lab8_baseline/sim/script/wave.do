onerror {resume}
radix define States {
    "8'b000?????" "Play" -color "green",
    "8'b001?????" "Play Repeat" -color "purple",
    "8'b01??????" "Pause" -color "orange",
    "8'b10??????" "Seek" -color "blue",
    "8'b11??????" "Stop" -color "red",
    -default hexadecimal
    -defaultcolor white
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/clk
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/reset
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/execute_btn
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/sync
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/inst_address
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/instruction
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/led
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/operation
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/repeat
add wave -noupdate -radix binary /dj_roomba_3000_tb/dj_roomba/seek_field
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/execute_sync
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/decode_flag
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/execute_flag
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/pres_state
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/next_state
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/sel_addr
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/data_address
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/audio_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8160 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 202
configure wave -valuecolwidth 48
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
configure wave -timelineunits us
update
WaveRestoreZoom {7237 ns} {11549 ns}
