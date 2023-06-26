factor = 4;
wr1 = 2*pi*40;
wr2 = wr1*factor;
wr3 = wr2*factor;
wr4 = wr3*factor;
wr5 = wr4*factor;
% wr_lpf = 2*pi*10;
% wr_hpf = 2*pi*100000;
k1 = 1;
k2 = 1;
k3 = 1;
Q = 1;

bpf1 = tf([k1*wr1/Q 0],[1 wr1/Q wr1^2]);
bpf2 = tf([k2*wr2/Q 0],[1 wr2/Q wr2^2]);
bpf3 = tf([k3*wr3/Q 0],[1 wr3/Q wr3^2]);
bpf4 = tf([k3*wr4/Q 0],[1 wr4/Q wr4^2]);
bpf5 = tf([k3*wr5/Q 0],[1 wr5/Q wr5^2]);
% lpf = tf(wr_lpf, [1 wr_lpf]);
% hpf = tf([1 0], [1 wr_hpf]);
% inv_lpf = tf([1 wr2*2], wr2*2);
% inv_hpf = tf([1 wr2/2], [1 0]);
inv_lpf = tf([1 wr2], wr2);
inv_hpf = tf([1 wr2], [1 0]);

% plot = bodeplot(bpf1, bpf2, bpf3,inv_lpf, inv_hpf, bpf1*bpf2*bpf3*inv_lpf*inv_hpf, 'g');
plot = bodeplot(bpf1, bpf2, bpf3, bpf4, bpf5, bpf1^1+bpf2^1+bpf3^1+bpf4^1+bpf5^1, 'g');
setoptions(plot,'FreqUnits','Hz','PhaseVisible','off');
grid on;
