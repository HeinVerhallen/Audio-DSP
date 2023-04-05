#DD3 DAS sipo.do
restart -f

# 10 MHz klok definieren:
force clk 1 0, 0 10 -rep 20
force shift 0
force sinput 0
run 30

# parout = "110001001111001001011100"

force shift 1
force sinput 1
run 40

force sinput 0
run 60

force sinput 1
run 20

force sinput 0
run 40

force sinput 1
run 80

force sinput 0
run 40

force sinput 1
run 20

force sinput 0
run 40

force sinput 1
run 20

force sinput 0
run 20

force sinput 1
run 60

force sinput 0
run 40

force sinput 1
run 20