wr1 = 2*pi*100;
wr2 = 2*pi*1000;
k = 3;

bpf1 = tf([k*wr1 0],[1 wr1 wr1^2]);
bpf2 = tf([k*wr2 0],[1 wr2 wr2^2]);

plot = bodeplot(bpf1, bpf2, bpf1*bpf2, 'g');
setoptions(plot,'FreqUnits','Hz','PhaseVisible','off');
grid on;
