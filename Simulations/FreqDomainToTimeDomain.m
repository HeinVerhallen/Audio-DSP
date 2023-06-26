% Fs = 1000;           % Sampling frequency                    
% T = 1/Fs;             % Sampling period       
% L = 1500;             % Length of signal
% t = (0:L-1)*T;        % Time vector
% 
% f1 = figure;
% f2 = figure;
% 
% t1 = tiledlayout(f1, 2, 1);
% 
% t1_ax1 = nexttile(t1);
% t1_ax2 = nexttile(t1);
% 
% u1 = 0.7*sin(2*pi*50*t);
% u2 = sin(2*pi*120*t);

% a = [1 3 5; 2 4 6; 7 8 10]
% 
% p = a*inv(a)

close all;
clc;

len = 1000;
A = 1;
x = zeros(1,len/2);

for i = 1:(len/2)
    if (rem(i,2) > 0)
        x(i) = A*(1/i);
    end
end

x_mirror = flip(x,2);

s = [x,x_mirror];

figure;
stem(s);

Y = ifft(s);

figure;
plot(Y);

