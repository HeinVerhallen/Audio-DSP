factor = 4;
f0 = 100;        %resonance frequency of BPF 0
f1 = f0*factor; %resonance frequency of BPF 1
f2 = f1*factor; %resonance frequency of BPF 2
f3 = f2*factor; %resonance frequency of BPF 3
% f1 = 1e3;
% f2 = 1e3;
k0 = 0;     %gain of BPF 0
k1 = 0;     %gain of BPF 1
k2 = 0;     %gain of BPF 2
k3 = 0;     %gain of BPF 3
% dt = 1e-6;  %sample time
dt = 1/192000;

t_end = 10;
t = 0:dt:t_end;
f_start = 1;    %chirp start frequency
f_end = 1e5;    %chirp end frequency
% -90 degree phase for it to be a sine
filtIn = chirp(t,f_start,t_end,f_end,'logarithmic',-90);
% filtIn = sin(2*pi*f1*t);

%Setup State-space coefficients
A0 = [-2*pi*f0 0; -k0*2*pi*f0 -2*pi*f0];
B0 = [2*pi*f0; k0*2*pi*f0];
C0 = [0 1];
D0 = 0;

A1 = [-2*pi*f1 0; -k1*2*pi*f1 -2*pi*f1];
B1 = [2*pi*f1; k1*2*pi*f1];
C1 = [0 1];
D1 = 0;

A2 = [-2*pi*f2 0; -k2*2*pi*f2 -2*pi*f2];
B2 = [2*pi*f2; k2*2*pi*f2];
C2 = [0 1];
D2 = 0;

A3 = [-2*pi*f3 0; -k3*2*pi*f3 -2*pi*f3];
B3 = [2*pi*f3; k3*2*pi*f3];
C3 = [0 1];
D3 = 0;

%Compute discrete State-space coefficients
Ad0=expm(A0*dt);
Bd0=((Ad0-Ad0^0)/A0)*B0;

Ad1=expm(A1*dt);
Bd1=((Ad1-Ad1^0)/A1)*B1;

Ad2=expm(A2*dt);
Bd2=((Ad2-Ad2^0)/A2)*B2;

Ad3=expm(A3*dt);
Bd3=((Ad3-Ad3^0)/A3)*B3;

%Analyze frequency response with fvtool
% [num,den] = ss2tf(Ad1,Bd1,C1,D1);
% fvtool(num(1,:),den, 'Fs',1/dt);

%Compute filter output
filtOut0 = zeros(2, length(filtIn));
filtOut1 = zeros(2, length(filtIn));
filtOut2 = zeros(2, length(filtIn));
filtOut3 = zeros(2, length(filtIn));

filtOut  = zeros(2, length(filtIn));
for n = 1:length(t)-1
    filtOut0(1, n+1) = Ad0(1,1)*filtOut0(1,n) + Ad0(1,2)*filtOut0(2,n) + Bd0(1)*filtIn(n);
    filtOut0(2, n+1) = Ad0(2,1)*filtOut0(1,n) + Ad0(2,2)*filtOut0(2,n) + Bd0(2)*filtIn(n);
    
    filtOut1(1, n+1) = Ad1(1,1)*filtOut1(1,n) + Ad1(1,2)*filtOut1(2,n) + Bd1(1)*filtIn(n);
    filtOut1(2, n+1) = Ad1(2,1)*filtOut1(1,n) + Ad1(2,2)*filtOut1(2,n) + Bd1(2)*filtIn(n);
    
    filtOut2(1, n+1) = Ad2(1,1)*filtOut2(1,n) + Ad2(1,2)*filtOut2(2,n) + Bd2(1)*filtIn(n);
    filtOut2(2, n+1) = Ad2(2,1)*filtOut2(1,n) + Ad2(2,2)*filtOut2(2,n) + Bd2(2)*filtIn(n);
    
    filtOut3(1, n+1) = Ad3(1,1)*filtOut3(1,n) + Ad3(1,2)*filtOut3(2,n) + Bd3(1)*filtIn(n);
    filtOut3(2, n+1) = Ad3(2,1)*filtOut3(1,n) + Ad3(2,2)*filtOut3(2,n) + Bd3(2)*filtIn(n);
    
    filtOut(1, n+1) = filtOut0(1, n+1) + filtOut1(1, n+1) + filtOut2(1, n+1) + filtOut3(1, n+1);
    filtOut(2, n+1) = filtOut0(2, n+1) + filtOut1(2, n+1) + filtOut2(2, n+1) + filtOut3(2, n+1);
end

%Display filter response
fig2 = figure(1);
tiledlayout(fig2,2,1);
ax1 = nexttile;
ax2 = nexttile;

plot(ax1, t, filtIn);
title(ax1, 'Input chirp');
ylabel(ax1, 'Amplitude');
xlabel(ax1, 'Time [s]');
% x_log = logspace(0,5,length(t));
% x_log = linspace(1,1e5,length(t));
plot(ax2, t, filtOut(2, 1:end));
title(ax2, 'Filtered chirp');
ylabel(ax2, 'Amplitude');
xlabel(ax2, 'Time [s]');

% f2 = figure(2);
% plot(tfestimate(filtIn, filtOut(2, 1:end)));




