restart -f

force sck 1 0, 0 10 -rep 20
force mclk 1 0, 0 1 -rep 2
force nrst 0
run 20

force nrst 1
force ws 1 0, 0 480 -rep 960
force data_left 000011110000111100001111
force data_right 111100001111000011110000
run 960

force data_left 110001111100011101000111
force data_right 010011001100000001111010
run 960

force data_left 000101011011111000100001
force data_right 101001111111100000110101
run 480

force data_left 010010101101110001110100
force data_right 110011000001110001111001
run 480

force data_left 101110111001110010110100
force data_right 011110010011001010010110
run 120
