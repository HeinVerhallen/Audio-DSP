#DD3 addsync.do
restart -f

# 10 MHz klok definieren:
force clk 1 0, 0 10 -rep 20
force nrst 0

force hmino 0
force hpluso 0
force hnulo 0
force syncaddo 0
force Lwino 1
run 30

force nrst 1
force hnulo 1
run 40

force hpluso 1
force hnulo 0
run 20

force hpluso 0
force hmino 1
run 20

force hpluso 1
force hmino 0
force Lwino 0
run 20

force hpluso 0
force hmino 1
force Lwino 1
run 20

force hpluso 0
force hmino 0
force hnulo 1
force Lwino 0
run 40

force hpluso 0
force hmino 1
force hnulo 0
run 20

force hpluso 1
force hmino 0
force hnulo 0
run 20

force hpluso 0
force hmino 0
force hnulo 1
force Lwino 1
force syncaddo 1
run 60

force hpluso 1
force hmino 0
force hnulo 0
run 20

force hpluso 0
force hmino 1
force hnulo 0
force syncaddo 0
run 20

force hpluso 0
force hmino 0
force hnulo 1
force Lwino 0
run 40

force hpluso 0
force hmino 1
force hnulo 0
run 20

force hpluso 1
force hmino 0
force hnulo 0
run 20

force hpluso 0
force hmino 0
force hnulo 1
force Lwino 1
run 40

force hpluso 1
force hmino 0
force hnulo 0
run 20

force hpluso 0
force hmino 1
run 20

force hpluso 1
force hmino 0
force Lwino 0
run 20

force hpluso 0
force hmino 1
force Lwino 1
run 20

force hpluso 0
force hmino 0
force hnulo 1
force Lwino 0
force syncaddo 1
run 60

force hpluso 0
force hmino 1
force hnulo 0
force Lwino 0
run 20

force hpluso 1
force hmino 0
force Lwino 1
force syncaddo 0
run 20

