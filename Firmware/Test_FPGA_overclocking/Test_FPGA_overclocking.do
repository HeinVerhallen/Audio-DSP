restart -f

force mclk 1 0, 0 10000 -rep 20000
force pll_clk 1 0, 0 312 -rep 625
run 1200000