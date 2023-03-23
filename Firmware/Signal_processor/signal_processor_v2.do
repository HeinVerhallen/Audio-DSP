restart -f

force sys_clk 1 0, 0 10 -rep 20
force sample_clk 1 0, 0 100 -rep 200
force nrst 0
force inp x"000c0e"
run 35

force nrst 1
force dat x"000000"
force reg "00000"
force en 0
force rw 0
run 20

force en 1
run 20

force dat x"0050ae"
force reg "00001"
run 20

force dat x"f03d70"
force reg "00011"
run 20

force dat x"zzzzzz"
force reg "00001"
force rw 1
run 20

force reg "00000"
run 20

force dat x"ff00ff"
#force dat x"zzzzzz"
force reg "00011"
force rw 0
run 20

force dat x"35000e"
force reg "00000"
run 20

force dat x"zzzzzz"
force reg "00001"
force rw 1
run 20

force reg "00010"
run 20

force reg "00011"
run 20

force reg "00000"
run 20

force en 0
run 20

force rw 0
run 20
