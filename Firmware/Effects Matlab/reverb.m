clc
clear all;
close all;


[y,Fs] = audioread('muted.wav');    % Read WAV file
%soundsc(y,Fs);                        % Play WAV file

factor = 0.15;

delay1 = round(Fs*factor^1);  
delay2 = round(Fs*factor^2);  
delay3 = round(Fs*factor^3);
delay4 = round(Fs*factor^4);

coef = 0.7;                
yy1 = filter([1 zeros(1,delay1) coef],[1 zeros(1,delay2) -coef],y);
yy2 = filter([1 zeros(1,delay3) coef],[1 zeros(1,delay4) -coef],y);

yytotal = yy1+yy2;


soundsc(yy1,Fs);