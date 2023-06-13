clc
clear all;
close all;

[y,Fs] = audioread('pen15.wav');    % Read WAV file
%soundsc(y,Fs);                        % Play WAV file

index = 1:1000000;
yy = y(index);
output = zeros(1,length(index));
damping = 10000;
phaser = length(index)/damping*sin(2*pi*10*index/length(index))+length(index)/damping+5;
figure;
plot(phaser);

for i = index
    delay_phaser = i-round(phaser(i));
    if (delay_phaser < 1)
        delay_phaser = 1;
    end
    output(i) = yy(i) + yy(delay_phaser);
end 

soundsc(output,Fs)
figure;
plot(index,output)


