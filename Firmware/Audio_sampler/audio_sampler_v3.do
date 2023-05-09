restart -f

force nrst 0
force bclk 1 0, 0 160 -rep 320
run 480

force ADC_LRCK 1 0, 0 10240 -rep 20480
force DAC_LRCK 1 0, 0 10240 -rep 20480
force nrst 1
run 320

force ADC_DAT 0
run 640

force ADC_DAT 1
run 960

force ADC_DAT 0
run 320

force ADC_DAT 1
run 1600

force ADC_DAT 0
run 960

force ADC_DAT 1
run 640

force ADC_DAT 0
run 320

force ADC_DAT 1
run 1280

force ADC_DAT 0
run 640

force ADC_DAT 1
run 320

force ADC_DAT 0
run 960

force ADC_DAT 1
run 1920

force ADC_DAT 0
run 320

force ADC_DAT 1
run 1600

force ADC_DAT 0
run 960

force ADC_DAT 1
run 640

force ADC_DAT 0
run 320

force ADC_DAT 1
run 1280

force ADC_DAT 0
run 960

force ADC_DAT 1
run 640

force ADC_DAT 0
run 320

force ADC_DAT 0
run 1600

force ADC_DAT 1
run 1920

force ADC_DAT 0
run 320

force ADC_DAT 1
run 1280

force ADC_DAT 0
run 3840

force ADC_DAT 1
run 3840

force ADC_DAT 0
run 3840

force ADC_DAT 1
run 3840

force ADC_DAT 0
run 3840

force ADC_DAT 0
run 640

force ADC_DAT 1
run 960

force ADC_DAT 0
run 320

force ADC_DAT 1
run 1600

force ADC_DAT 0
run 960

force ADC_DAT 1
run 640

force ADC_DAT 0
run 320

force ADC_DAT 1
run 1280

force ADC_DAT 0
run 640

force ADC_DAT 1
run 320

force ADC_DAT 0
run 960

force ADC_DAT 1
run 1920

force ADC_DAT 0
run 320

force ADC_DAT 1
run 1600

force ADC_DAT 0
run 960

force ADC_DAT 1
run 640

force ADC_DAT 0
run 320

force ADC_DAT 1
run 1280

force ADC_DAT 0
run 960

force ADC_DAT 1
run 640

force ADC_DAT 0
run 320

force ADC_DAT 0
run 1600

force ADC_DAT 1
run 1920

force ADC_DAT 0
run 320

