#DD3 hdb3enc.do
restart -f

# 10 MHz klok definieren:
force clk 1 0, 0 10 -rep 20
force nrst 0
force so 0
force syncadd_c 0
run 30

force nrst 1
force so 1
run 40

force so 0
run 80

force so 1
run 20

force so 0
run 240

force so 1
run 60

force so 0
run 100

force so 1
run 40

