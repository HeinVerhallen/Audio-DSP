restart -f

force sck 1 0, 0 10 -rep 20
force nrst 0
force data_left 000011110000111100001111
force data_right 111100001111000011110000
run 30

force nrst 1
run 2000