Fs = 1000;           % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector

f1 = figure;
f2 = figure;

t1 = tiledlayout(f1, 2, 1);

t1_ax1 = nexttile(t1);
t1_ax2 = nexttile(t1);

u1 = 0.7*sin(2*pi*50*t);
u2 = sin(2*pi*120*t);

plot(t1_ax1, 1000*t(1:100), u1(1:100));
plot(t1_ax2, 1000*t(1:100), u2(1:100));

t2 = tiledlayout(f2, 3, 1);

t2_ax1 = nexttile(t2);
t2_ax2 = nexttile(t2);
t2_ax3 = nexttile(t2);

X = u1 + u2;

% X = S + 2*randn(size(t));

plot(t2_ax1, 1000*t(1:100),X(1:100))
title(t2_ax1, 'Signal Corrupted with Zero-Mean Random Noise')
xlabel(t2_ax1, 't (milliseconds)')
ylabel(t2_ax1, 'X(t)')

% Y = fft(X);
% 
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% f = Fs*(0:(L/2))/L;
% plot(ax2, f,P1) 
% title(ax2, 'Single-Sided Amplitude Spectrum of X(t)')
% xlabel(ax2, 'f (Hz)')
% ylabel(ax2, '|P1(f)|')

S = fft(X);

S(1:100) = 0;
S(900:end-1) = 0;

P2 = abs(S/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
% plot(t2_ax2, f,P1)
stem(t2_ax2, P1);
title(t2_ax2, 'Single-Sided Amplitude Spectrum of S(t)')
xlabel(t2_ax2, 'f (Hz)')
ylabel(t2_ax2, '|P1(f)|')

Y = 2*ifft(S);

plot(t2_ax3, 1000*t(1:100),Y(1:100))
title(t2_ax3, 'Signal Corrupted with Zero-Mean Random Noise')
xlabel(t2_ax3, 't (milliseconds)')
ylabel(t2_ax3, 'Y(t)')



