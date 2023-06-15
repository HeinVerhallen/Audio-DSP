N = 256;
n = 0:N-1;
x = sin(2*pi*20*n/(N-1))+sin(2*pi*75*n/(N-1));

% Create sine and cosine lookup tables
sine   = sin(2*pi*n/(N-1));
cosine = cos(2*pi*n/(N-1));

tiledlayout(2,1);
ax1 = nexttile;
ax2 = nexttile;
plot(ax1, 0:N-1, x);

X = zeros(1,N);

% reverse bits so we get shuffled input samples
reg = bitrevorder(0:2^ceil(log2(N))-1);

% disp(dec2bin(reg));

for k = 0:1:N-1
    for n = reg
        % Take modulo of k*n
        p = mod(k * n, N);
        
        % Compute frequency coefficients
%         X(k+1) = X(k+1) + x(n_res+1)*exp(-1j*2*pi*p/N); %compute with e^x
        X(k+1) = X(k+1) + x(mod(n,N)+1)*(cosine(p+1)+1j*sine(p+1)); %compute with cos and j*sin (like we need to do in firmware)
    end
end

Y_full = abs(X)*2/N;
Y_sideL = Y_full(1:N/2);
plot(ax2, 0:N/2-1, Y_sideL, '.-');
% semilogx(ax2, 0:N/2-1, Y_sideL);

