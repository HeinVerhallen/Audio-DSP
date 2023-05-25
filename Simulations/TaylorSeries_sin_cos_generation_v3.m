N = 9600;
sinus   = zeros(1, N);
cosinus = zeros(1, N);

s = zeros(1,9);

for i = 1:21
%     s(i) = ((2*pi/N)^2)/factorial(i);
%     s(i) = (2*pi)/factorial(i);
    s(i) = 1/factorial(i);
    
    %met 2*pi factor erin werkt het niet. Zonder werkt het wel.
end

index = 1;
for n = -pi:2*pi/N:pi-(2*pi/N)
% for n = 0:1/N:1-1/N
    z = n^2;

    %inverteer alles omdat je van -pi tot +pi kijkt.
    %ipv alle z te inverteren de s(n) inverteren, anders werkt het niet.
    %Dit komt omdat de berekening de min meeneemt en vervolgens alles min
    %maakt.
    sinus(index) = -n*(1+z*(-s(3)+z*(s(5)+z*(-s(7)+z*(s(9)+z*(-s(11)+z*(s(13)+z*(-s(15)+z*(s(17)+z*(-s(19)+z*(s(21))))))))))));
    
    index = index + 1;
end

for n = -N/2:1:N/2-1
    minus = -1;
    
    z = n*n;
    
%     sinus(n+1+N/2) = n*((2*pi/N)+z*(-s(3)+z*(s(5)+z*(-s(7)+z*(s(9))))));
    
    for f = 1:2:9
%         sinus(n+1+N/2)    = sinus(n+1+N/2) + minus * ((2*pi*n/N)^f / factorial(f));
        cosinus(n+1+N/2)  = cosinus(n+1+N/2) + minus * ((2*pi*n/N)^(f-1) / factorial(f-1));
        minus = minus * -1;
    end
end

tiledlayout(2,1);
ax1 = nexttile;
ax2 = nexttile;
% plot(ax1, 0:N-1, sinus);
plot(ax1, 0:2/N:2-(2/N), sinus);
plot(ax2, 0:N-1, cosinus);


