#DD3 demux.do
restart -f

force chdesel_c "00000000"
force sbits 0
run 20

force chdesel_c "00000001"
run 20

force sbits 1
run 40

force sbits 0
run 20

force sbits 1
run 20

force chdesel_c "00000010"
run 20

force sbits 1
run 20

force sbits 0
run 40

force sbits 1
run 40

force sbits 0
run 20

force chdesel_c "00000011"
run 20