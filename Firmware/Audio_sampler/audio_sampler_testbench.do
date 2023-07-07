restart -f

force nrst 0
force clk_50 1 0, 0 10 -rep 20

#1000Hz
#force freq 00000000000000000000001111101000
#100Hz
#force freq 00000000000000000000000001100100
#10000Hz
force freq 00000000000000000010011100010000

#48kHz
#force bclk 1 0, 0 160 -rep 320
#run 480
#96kHz
#force bclk 1 0, 0 80 -rep 160
#run 240
#192kHz
force bclk 1 0, 0 40 -rep 80
run 120

#48kHz
#force ADC_LRCK 1 0, 0 10240 -rep 20480
#force DAC_LRCK 1 0, 0 10240 -rep 20480
#96kHz
#force ADC_LRCK 1 0, 0 5120 -rep 10240
#force DAC_LRCK 1 0, 0 5120 -rep 10240
#192kHz
force ADC_LRCK 1 0, 0 2560 -rep 5120
force DAC_LRCK 1 0, 0 2560 -rep 5120

force nrst 1

run 10000000


