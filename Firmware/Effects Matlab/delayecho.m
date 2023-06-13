clc
clear all;
close all;

[y,Fs] = audioread('pen15.wav');    % Read WAV file
%soundsc(y,Fs);                        % Play WAV file

index = 1:1000000;
yy = y(index);
output = zeros(1,length(index));
phaser = 50000;
gain = 0.5;

for i = index
    delay = i-phaser;
    if (delay < 1)
        delay = 1;
    end
    output(i) = yy(i) + gain*yy(delay);
end 



soundsc(output,Fs)
figure;
plot(index,output)
