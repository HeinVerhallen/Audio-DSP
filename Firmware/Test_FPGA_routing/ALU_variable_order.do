restart -f

#10 MHz clock:
force clk 1 0, 0 10 -rep 20

force nrst 0
force input 1010
run 30

force nrst 1
run 80

force input 0101
run 40

force func 001
force position 01
run 20

force enData 1
run 20

force position 10
run 20

force position 11
run 20

force enData 0
run 80

force input 0000
run 100