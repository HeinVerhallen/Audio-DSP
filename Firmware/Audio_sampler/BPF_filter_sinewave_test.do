restart -f

force nrst 0
force mclk 1 0, 0 10 -rep 20
run 30

force nrst 1
force param 000000
run 10000000

force param 001000
run 10000000

force param 100000
run 10000000

force param 100010
run 10000000

force param 100110
run 10000000
