#DD3 mux.do
restart -f

force chsel_c "00000000"
force soLo 0
force soRo 0
run 20

force soLo 1
force chsel_c "00000001"
run 20

force soRo 1
run 20

force soLo 0
run 20

force soLo 1
force soRo 0
run 40

force chsel_c "00000010"
run 20

force soLo 0
force soRo 1
run 20

force soLo 1
run 20

force soRo 0
run 20

force soLo 0
run 20

force soRo 1
run 20

force chsel_c "00000011"
run 20