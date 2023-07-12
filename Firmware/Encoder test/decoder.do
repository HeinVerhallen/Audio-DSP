restart -f

force clk 1 0, 0 1 -r 2
force nrst 0
force input 0
run 2 

force nrst 1
force input 1
run 2
force input 0
run 5000000

force input 1
run 2
force input 0
run 400