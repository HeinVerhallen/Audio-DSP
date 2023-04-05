#DD3 DAS piso.do
restart -f

# 10 MHz klok definieren:
force clk 1 0, 0 10 -rep 20
force shift_c 0
force loadpiso_c 0
force encrypteddatain "110010100011100110011100"
run 30

force loadpiso_c 1
run 40

force encrypteddatain "101010101000101010111000"
force loadpiso_c 0
force shift_c 1
run 600

#force loadpiso_c 1
#run 20

#force encrypteddatain "000000000000000000000000"
#force loadpiso_c 0
#force shift_c 1
#run 500