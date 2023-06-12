freq = 1e2;
w0 = 1e3;
% f1 = 1e3;
% f2 = 1e3;
k = 1;
dt = 1e-6;
t = 0:dt:1/freq*5;
filtIn = sin(2*pi*freq*t);

A = [-2*pi*w0 0; -k*2*pi*w0 -2*pi*w0];
B = [2*pi*w0; k*2*pi*w0];
C = [0 1];
D = 0;

Ad=expm(A*dt);
Bd=((Ad-Ad^0)/A)*B;

[num,den] = ss2tf(Ad,Bd,C,D);
fvtool(num(1,:),den, 'Fs',1/dt);

filtOut = zeros(2, length(filtIn));
for n = 1:length(t)-1
    filtOut(1, n+1) = Ad(1,1)*filtOut(1,n) + Ad(1,2)*filtOut(2,n) + Bd(1)*filtIn(n);
    filtOut(2, n+1) = Ad(2,1)*filtOut(1,n) + Ad(2,2)*filtOut(2,n) + Bd(2)*filtIn(n);
end

tiledlayout(2,1);
nexttile;
plot(t, filtIn);
nexttile;
plot(t, filtOut(2, 1:end));