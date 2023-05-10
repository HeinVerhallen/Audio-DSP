Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector

tiledlayout(3,1)

ax1 = nexttile;
ax2 = nexttile;
ax3 = nexttile;

S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);

X = S + 2*randn(size(t));

plot(ax1, 1000*t(1:50),X(1:50))
title(ax1, 'Signal Corrupted with Zero-Mean Random Noise')
xlabel(ax1, 't (milliseconds)')
ylabel(ax1, 'X(t)')

Y = fft(X);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(ax2, f,P1) 
title(ax2, 'Single-Sided Amplitude Spectrum of X(t)')
xlabel(ax2, 'f (Hz)')
ylabel(ax2, '|P1(f)|')

Y = fft(S);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

plot(ax3, f,P1) 
title(ax3, 'Single-Sided Amplitude Spectrum of S(t)')
xlabel(ax3, 'f (Hz)')
ylabel(ax3, '|P1(f)|')


