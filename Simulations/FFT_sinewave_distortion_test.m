close all;
clc;
clear all;

fs = 192000;
f1 = 1000;
% f2 = 50000;
t_end = 9600 * 1/fs; %9600*1/fs; %3*1/f1;
t = 0:1/fs:t_end-1/fs;
x = 1*sin(2*pi*f1*t) + 1/3*sin(2*pi*3*f1*t) + 1/5*sin(2*pi*5*f1*t) + 1/7*sin(2*pi*7*f1*t); %+ 1*sin(2*pi*f2*t);
% x = square(2 * pi * f1 * t, 50);

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

[maximum, index] = max(P1);

% P1(index) = maximum * (4/pi);

for i = 3:2:60
    P1(i*(index-1)+1) = maximum*1/i;
end

% P1(3*(index-1)+1) = maximum*1/3;
% P1(5*(index-1)+1) = maximum*1/5;
% P1(7*(index-1)+1) = maximum*1/7;

% P = [P1(1:(length(X)/2)+1),flip(P1(2:(length(X)/2)))] / 2;
% X = complex(0, P);

% Reconstruct the complex spectrum
X_reconstructed = zeros(size(X));
X_reconstructed(1:(length(X)/2) + 1) = P1;
X_reconstructed((length(X)/2) + 2:end) = flip(P1(2:end-1));
figure;
plot(X_reconstructed);

X_reconstructed = X_reconstructed * length(X)/2;
% X_reconstructed = complex(1e-16, -X_reconstructed);

% Perform inverse FFT
x_reconstructed = ifft(X_reconstructed);

% Plot the reconstructed signal
figure;
plot(t, x_reconstructed, '.-');
xlabel('Time');
ylabel('Amplitude');

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
