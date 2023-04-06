EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Audio_DSP:OPA1632DR IC1
U 1 1 642F4571
P 2100 2450
F 0 "IC1" H 2175 3231 50  0000 C CNN
F 1 "OPA1632DR" H 2175 3140 50  0000 C CNN
F 2 "Audio_DSP:VSSOP-8_3.0x3.0mm_P0.65_TP1.8x1.5" H 1600 3150 39  0001 L CNN
F 3 "https://eu.mouser.com/ProductDetail/Texas-Instruments/OPA1632DGNR?qs=7nS3%252BbEUL6t46Xk02kKOHg%3D%3D" H 2200 2850 50  0001 L CNN
	1    2100 2450
	1    0    0    -1  
$EndComp
$Comp
L Audio_DSP:LM4562 U1
U 1 1 642F5979
P 4550 2550
F 0 "U1" H 4600 2917 50  0000 C CNN
F 1 "LM4562" H 4600 2826 50  0000 C CNN
F 2 "Package_SO:SOIC-8_3.9x4.9mm_P1.27mm" H 4600 2800 50  0001 C CNN
F 3 "https://nl.farnell.com/texas-instruments/lm4562max-nopb/audio-amplifier-55mhz-20v-us-soic/dp/3004534?st=lm4562" H 4600 2800 50  0001 C CNN
	1    4550 2550
	1    0    0    -1  
$EndComp
$Comp
L Audio_DSP:LM4562 U1
U 2 1 642F6721
P 4650 3150
F 0 "U1" H 4700 3517 50  0000 C CNN
F 1 "LM4562" H 4700 3426 50  0000 C CNN
F 2 "Package_SO:SOIC-8_3.9x4.9mm_P1.27mm" H 4700 3400 50  0001 C CNN
F 3 "https://nl.farnell.com/texas-instruments/lm4562max-nopb/audio-amplifier-55mhz-20v-us-soic/dp/3004534?st=lm4562" H 4700 3400 50  0001 C CNN
	2    4650 3150
	1    0    0    -1  
$EndComp
$Comp
L Audio_DSP:LM4562 U1
U 3 1 642F7165
P 4700 3850
F 0 "U1" H 4758 3896 50  0000 L CNN
F 1 "LM4562" H 4758 3805 50  0000 L CNN
F 2 "Package_SO:SOIC-8_3.9x4.9mm_P1.27mm" H 4750 4100 50  0001 C CNN
F 3 "https://nl.farnell.com/texas-instruments/lm4562max-nopb/audio-amplifier-55mhz-20v-us-soic/dp/3004534?st=lm4562" H 4750 4100 50  0001 C CNN
	3    4700 3850
	1    0    0    -1  
$EndComp
$Comp
L Audio_DSP:PCM1789-Q1 IC2
U 1 1 642F8149
P 7900 1750
F 0 "IC2" H 7850 2881 50  0000 C CNN
F 1 "PCM1789-Q1" H 7850 2790 50  0000 C CNN
F 2 "Package_SO:TSSOP-24_4.4x7.8mm_P0.65mm" H 8650 2550 50  0001 L CNN
F 3 "https://eu.mouser.com/ProductDetail/Texas-Instruments/PCM1789TPWRQ1?qs=cBe3DO7yhR4lgqDaXbktkg%3D%3D" H 8650 2150 50  0001 L CNN
	1    7900 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 642F9793
P 6300 3700
F 0 "R1" H 6370 3746 50  0000 L CNN
F 1 "1k" H 6370 3655 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 6230 3700 50  0001 C CNN
F 3 "~" H 6300 3700 50  0001 C CNN
	1    6300 3700
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 642F9E94
P 7000 3650
F 0 "C1" H 7115 3696 50  0000 L CNN
F 1 "C" H 7115 3605 50  0000 L CNN
F 2 "" H 7038 3500 50  0001 C CNN
F 3 "~" H 7000 3650 50  0001 C CNN
	1    7000 3650
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x03 J1
U 1 1 642FB268
P 1600 1250
F 0 "J1" H 1518 1567 50  0000 C CNN
F 1 "Conn_01x03" H 1518 1476 50  0000 C CNN
F 2 "Connector_JST:JST_PH_B3B-PH-K_1x03_P2.00mm_Vertical" H 1600 1250 50  0001 C CNN
F 3 "~" H 1600 1250 50  0001 C CNN
	1    1600 1250
	-1   0    0    -1  
$EndComp
$EndSCHEMATC