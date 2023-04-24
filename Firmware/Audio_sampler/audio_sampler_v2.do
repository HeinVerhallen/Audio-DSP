restart -f

force nrst 0
force bck 1 0, 0 10 -rep 20
run 30

force lrck 1 0, 0 480 -rep 960
run 20

force data_in 0
force nrst 1
run 40

force data_in 1
run 60

force data_in 0
run 20

force data_in 1
run 100

force data_in 0
run 60

force data_in 1
run 40

force data_in 0
run 20

force data_in 1
run 80

force data_in 0
run 40

force data_in 1
run 20

force data_in 0
run 60

force data_in 1
run 120

force data_in 0
run 20

force data_in 1
run 100

force data_in 0
run 60

force data_in 1
run 40

force data_in 0
run 20

force data_in 1
run 80

force data_in 0
run 60

force data_in 1
run 40

force data_in 0
run 20

force data_in 0
run 100

force data_in 1
run 120

force data_in 0
run 20

force data_in 1
run 80

force data_in 0
run 240

force data_in 1
run 240

force data_in 0
run 240

force data_in 1
run 240

force data_in 0
run 240



