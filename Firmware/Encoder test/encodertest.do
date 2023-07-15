restart -f

force clk 1 0, 0 10 -r 20
force nrst 0
force a 1
force b 1
force switch 0
run 20000

force nrst 1
force b 0
run 2000000

force a 0
run 2000000

force b 1
run 2000000

force a 1
run 2000000

run 200