f0 = 100;   %resonance frequency of BPF 0
f1 = 400;   %resonance frequency of BPF 1
% f1 = 1e3;
% f2 = 1e3;
k0 = 2;     %gain of BPF 0
k1 = 2;     %gain of BPF 1
dt = 1e-6;  %sample time

t_end = 10;
t = 0:dt:t_end;
f_start = 1;    %chirp start frequency
f_end = 1e5;    %chirp end frequency
% -90 degree phase for it to be a sine
filtIn = chirp(t,f_start,t_end,f_end,'logarithmic',-90);

%Setup State-space coefficients
A0 = [-2*pi*f0 0; -k0*2*pi*f0 -2*pi*f0];
B0 = [2*pi*f0; k0*2*pi*f0];
C0 = [0 1];
D0 = 0;

A1 = [-2*pi*f1 0; -k1*2*pi*f1 -2*pi*f1];
B1 = [2*pi*f1; k1*2*pi*f1];
C1 = [0 1];
D1 = 0;

%Compute discrete State-space coefficients
Ad0=expm(A0*dt);
Bd0=((Ad0-Ad0^0)/A0)*B0;

Ad1=expm(A1*dt);
Bd1=((Ad1-Ad1^0)/A1)*B1;

%Analyze frequency response with fvtool
[num,den] = ss2tf(Ad0,Bd0,C0,D0);
fvtool(num(1,:),den, 'Fs',1/dt);

%Compute filter output
filtOut0 = zeros(2, length(filtIn));
filtOut1 = zeros(2, length(filtIn));
filtOut  = zeros(2, length(filtIn));
for n = 1:length(t)-1
    filtOut0(1, n+1) = Ad0(1,1)*filtOut0(1,n) + Ad0(1,2)*filtOut0(2,n) + Bd0(1)*filtIn(n);
    filtOut0(2, n+1) = Ad0(2,1)*filtOut0(1,n) + Ad0(2,2)*filtOut0(2,n) + Bd0(2)*filtIn(n);
    
    filtOut1(1, n+1) = Ad1(1,1)*filtOut1(1,n) + Ad1(1,2)*filtOut1(2,n) + Bd1(1)*filtIn(n);
    filtOut1(2, n+1) = Ad1(2,1)*filtOut1(1,n) + Ad1(2,2)*filtOut1(2,n) + Bd1(2)*filtIn(n);
    
    filtOut(1, n+1) = filtOut0(1, n+1) + filtOut1(1, n+1);
    filtOut(2, n+1) = filtOut0(2, n+1) + filtOut1(2, n+1);
end

%Display filter response
tiledlayout(2,1);
nexttile;
plot(t, filtIn);
nexttile;
% x_log = logspace(0,5,length(t));
% x_log = linspace(1,1e5,length(t));
plot(t, filtOut(2, 1:end));



