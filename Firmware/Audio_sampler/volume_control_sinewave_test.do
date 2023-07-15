restart -f

force mclk 1 0, 0 10 -rep 20
#400Hz
force freq 00000000000000000000000110010000
force param 0000000
run 10000000

force param 0001000
run 10000000

force param 1000000
run 10000000

force param 1000100
run 10000000

force param 1001100
run 10000000

force param 1011100
run 10000000

force param 1111111
run 10000000
