restart -f

force sck 1 0, 0 10 -rep 20
force mclk 1 0, 0 1 -rep 2
force nrst 0
run 30

force nrst 1
force sd 1
force ws 1 0, 0 480 -rep 960
run 500

force sd 0
run 240

force sd 1
run 240

force sd 0
run 120

force sd 1
run 240

force sd 0
run 120

force sd 0
run 120

force sd 1
run 120

force sd 0
run 120

force sd 1
run 120

force sd 0
run 120

force sd 1
run 120
