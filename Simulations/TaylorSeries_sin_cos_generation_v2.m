N = 9600;
sinus   = zeros(1, N);
cosinus = zeros(1, N);

for n = -N/2:1:N/2-1
    minus = -1;
    
    for f = 1:2:9
        sinus(n+1+N/2)    = sinus(n+1+N/2) + minus * ((2*pi*n/N)^f / factorial(f));
        cosinus(n+1+N/2)  = cosinus(n+1+N/2) + minus * ((2*pi*n/N)^(f-1) / factorial(f-1));
        minus = minus * -1;
    end
end

tiledlayout(2,1);
ax1 = nexttile;
ax2 = nexttile;
plot(ax1, 0:N-1, sinus);
plot(ax2, 0:N-1, cosinus);


