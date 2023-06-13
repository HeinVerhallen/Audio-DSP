N = 16;
n = 0:N-1;
x = sin(2*pi*n/(N-1));

sine   = 1j*sin(2*pi*n/(N-1));
cosine = cos(2*pi*n/(N-1));

tiledlayout(2,1);
ax1 = nexttile;
ax2 = nexttile;
plot(ax1, x);

X = zeros(1,N);

for k = 0:1:N-1
    for n4 = 0:1:1
        for n3 = 0:1:1
            for n2 = 0:1:1
                for n1 = 0:1:1
                    n_res = 8*n1+4*n2+2*n3+n4;
                    p = mod(k * n_res,N);
%                     X(k+1) = X(k+1) + x(n_res+1)*exp(-1j*2*pi*p/N);
                    X(k+1) = X(k+1) + x(n_res+1)*(cosine(p+1)+sine(p+1));
                end
            end
        end
    end 
end

Y = abs(X)*2/N;
plot(ax2, Y, '.-');