f1 = 1e1;
f2 = 1e1;
k = 1;
dt = 1e-5;

A = [-2*pi*f1 2*pi*f1;-2*pi*f2 k*2*pi*f2];
B = [2*pi*f1;0];
C = [0 k];
D = 0;

Ad=expm(A*dt);
Bd=((Ad-Ad^0)/A)*B;

[num,den] = ss2tf(Ad,Bd,C,D);
fvtool(num(1,:),den);

