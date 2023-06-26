close all;
clc;

t = linspace(0,2*pi)';
h = square(t);

figure;
plot(t/pi,h,'.-',t/pi,sin(t))
xlabel('t / \pi')
grid on

N = length(h);

z = fft(h);
figure;
stem(z);

Z = abs(z/N);
figure;
stem(Z);

H = ifft(z);
figure;
plot(H, '.-');
