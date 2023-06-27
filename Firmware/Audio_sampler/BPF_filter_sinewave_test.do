restart -f

force nrst 0
force mclk 1 0, 0 10 -rep 20
run 30

force nrst 1
run 50000000
