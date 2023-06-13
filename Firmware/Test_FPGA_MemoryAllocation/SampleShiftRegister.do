restart -f

force nrst 0
force clk 1 0, 0 10 -rep 20
force inp "111100001111000011110000"
run 30

force nrst 1
run 100
