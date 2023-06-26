N = 8;
n1 = zeros(1,N);
n2 = zeros(1,N);
n3 = zeros(1,N);
n4 = zeros(1,N);

a = zeros(1,N);

for i = 0:1:N-1
    for p = 1:1:log2(N)
        a(i+1) = a(i+1) + 2^(log2(N)-p) * floor(rem(i,2^p) / 2^(p-1));
    end
end