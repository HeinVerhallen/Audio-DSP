restart -f

force clk 1 0, 0 10 -rep 20
force reset_n 0
force sw_read 1
force sw_write 1
run 30

force reset_n 1
run 20

force sw_write 0
run 20

force sw_write 1
run 20

force sw_read 0
run 20

force sw_read 1
run 40

