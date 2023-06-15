close all;
clc;
clear all;

samples_per_cycles = 256;
n = 0:1:samples_per_cycles-1;
sine = round(samples_per_cycles*sin(2*pi*n/samples_per_cycles));
cosine = round(samples_per_cycles*cos(2*pi*n/samples_per_cycles));
% inp = cos(2*pi*1*n/samples_per_cycles+pi/4);
amplitude = 256;
inp = round(amplitude*sin(2*pi*1*n/samples_per_cycles+pi/2));

tiledlayout(2,1);
ax1 = nexttile;
ax2 = nexttile;
plot(ax1, n, inp);
plot(ax2, n, sine, n, cosine);

real = round(round(sum(cosine.*inp) * 2)/samples_per_cycles/samples_per_cycles);
imag = round(round(sum(sine.*inp) * 2)/samples_per_cycles/samples_per_cycles);
disp(["Real: ", real]);
disp(["Imag: ", imag]);