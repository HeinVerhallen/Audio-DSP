restart -f
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testbench/b2v_inst/clke
add wave -noupdate -format Logic /testbench/b2v_inst1/clk
add wave -noupdate -format Literal -radix unsigned /testbench/ok 
add wave -noupdate -divider -height 30 clk/ok
add wave -noupdate -format Literal -radix unsigned testbench/b2v_inst1/encia
add wave -noupdate -format Literal -radix unsigned testbench/b2v_inst1/encib
add wave -noupdate -format Logic /testbench/b2v_inst2/loadpiso_c 
add wave -noupdate -divider -height 30 input
add wave -noupdate -format Literal -radix unsigned /testbench/b2v_inst1/decoa
add wave -noupdate -format Literal -radix unsigned /testbench/b2v_inst1/decob
add wave -noupdate -format Logic /testbench/b2v_inst2/writeadc

add list \
{sim:/testbench/b2v_inst1/encia } \
{sim:/testbench/b2v_inst1/encib } \
{sim:/testbench/b2v_inst1/decoa } \
{sim:/testbench/b2v_inst1/decob } 

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 238
configure wave -valuecolwidth 74
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {657248 ns}


