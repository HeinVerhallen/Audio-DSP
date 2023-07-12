restart -f

force clk 1 0, 0 1 -r 2
force nrst 0
force a 0
force b 0
run 200

force nrst 1
force a 1
run 2

force a 0
run 20

force b 1
run 2

force b 0
run 20

force a 1
run 2

force a 0
run 20

force b 1
run 2

force b 0
run 200