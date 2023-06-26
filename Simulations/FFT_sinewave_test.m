close all;
clc;
clear all;

fs = 192000;
f1 = 20;
f2 = 50000;
t_end = 9600 * 1/fs; %9600*1/fs; %3*1/f1;
t = 0:1/fs:t_end-1/fs;
x = 0.2*sin(2*pi*f1*t) + 1*sin(2*pi*f2*t);

figure;
plot(t,x,'.-')
xlabel('t [s]')
grid on

% X = fft(x, 100);
X = fft(x);
P = abs(X)/length(X);
P1 = 2*P(1:(length(X)/2)+1);
f = fs*(0:(length(X)/2))/length(X);
figure;
plot(f,P1, '.-');
xlabel('frequency [Hz]');
ylabel('Magnitude');

Y = ifft(X);
figure;
plot(Y, '.-');

% X = abs(fft(x))/N;
% figure;
% plot(0:N-1,X);

% Ohmega = ((0:N-1)*pi)/N;
% figure;
% plot(Ohmega(1:N/2),X(1:N/2)); 
