restart -f
force clk 1 0, 0 1 -r 2
force input 1
force nrst 0
run 200

force nrst 1
force input 0
run 200000

force input 1
run 200000

force input 0
run 200000

force input 1
run 200000