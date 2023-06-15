clc
clear all;
close all;

[y,Fs] = audioread('sweetdis.wav');    % Read WAV file
%soundsc(y,Fs);                        % Play WAV file

index = 1:731176;
yy = y(index);
output = zeros(1,length(index));
damping = 10000;
depth = 3;     % depth parameter
factor = 4;
tone = 0.25;
depthpar = (depth*length(index));
phaser1 = depthpar/damping*sin(2*pi*(1+factor^0)*index/length(index))+length(index)/damping+5;             
phaser2 = depthpar/damping*sin(2*pi*(1+factor^1)*index/length(index))+length(index)/damping+5;
phaser3 = depthpar/damping*sin(2*pi*(1+factor^2)*index/length(index))+length(index)/damping+5;
phaser4 = depthpar/damping*sin(2*pi*(1+factor^3)*index/length(index))+length(index)/damping+5;
figure;
plot(phaser1);

for i = index
    delay_phaser1 = i-round(phaser1(i));
    delay_phaser2 = i-round(phaser2(i));
    delay_phaser3 = i-round(phaser3(i));
    delay_phaser4 = i-round(phaser4(i));
    if (delay_phaser1 < 1)
        delay_phaser1 = 1;
    end
    if (delay_phaser2 < 1)
        delay_phaser2 = 1;
    end
    if  (delay_phaser3 < 1)
        delay_phaser3 = 1;
    end
    if (delay_phaser4 < 1)
        delay_phaser4 = 1;
    end
   
    output(i) = yy(i) + tone*yy(delay_phaser1) + tone*yy(delay_phaser2) + tone*yy(delay_phaser3) + tone*yy(delay_phaser4);
end 

soundsc(output,Fs)
figure;
plot(index,output)