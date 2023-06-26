Fs = 192000;           % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 300000;             % Length of signal
t = (0:L-1)*T;        % Time vector

tiledlayout(2,1);

ax1 = nexttile;
ax2 = nexttile;

u1 = sin(2*pi*120*t);
u2 = 0.5*sin(2*pi*300*t);
u3 = 0.3*sin(2*pi*10000*t);

x = u1 + u2 + u3;

plot(ax1, t, x);

S = fft(x);

P2 = abs(S/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f(1:30000), P1(1:30000));


