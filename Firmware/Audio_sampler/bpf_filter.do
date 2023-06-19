restart -f

force d_in "11100110"
force ready 0
run 20

force d_in "11111010"
force ready 1
run 20

force d_in "11110100"
force ready 0
run 20

force d_in "11111111"
force ready 1
run 20

force d_in "10000000"
force ready 0
run 20

force d_in "00001101"
force ready 1
run 20

force d_in "10110000"
force ready 0
run 20

force d_in "00000000"
force ready 1
run 20

force d_in "00000110"
force ready 0
run 20