restart -f


force reset 1 
run 10



force clk 1 0, 0 2 -r 3
force enable 1
force reset 0
force I2C_RW  1 0, 0 5 -r 10
force I2C_ADDRESS 0001110
force I2C_DATA 00011101
run 90
force I2C_ADDRESS 1111111
force I2C_DATA 11111111
run 20


force present IDLE
run 10

force present ADDR
force I2C_ADDRESS 0110000
run 10

force present R_DATA 
run 10


force I2C_ADDRESS 0101101
force I2C_DATA 10100101
run 20

force I2C_ADDRESS 0011010
force I2C_DATA 01011010
run 20

force I2C_ADDRESS 1110001
force I2C_DATA 11100011
run 20

force I2C_ADDRESS 1001000
force I2C_DATA 00110011
run 20

force I2C_ADDRESS 0110011
force I2C_DATA 10010100
run 20

force I2C_ADDRESS 1010101
force I2C_DATA 01101110
run 20










