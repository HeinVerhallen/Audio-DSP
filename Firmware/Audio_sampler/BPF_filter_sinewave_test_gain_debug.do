restart -f

force mclk 1 0, 0 10 -rep 20
#400Hz
force freq 00000000000000000000000110010000
force param 000000
run 10000000

force param 111000
run 10000000

force param 001111
run 10000000

force param 000000
run 10000000

force param 111111
run 10000000