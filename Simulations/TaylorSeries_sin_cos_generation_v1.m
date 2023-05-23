% s1 = 2*pi;
% s3 = 2*pi/factorial(3);
% s5 = 2*pi/factorial(5);
% s7 = 2*pi/factorial(7);
% s9 = 2*pi/factorial(9);
% s11 = 2*pi/factorial(11);
% s13 = 2*pi/factorial(13);
% 
% n = 1000;
% sine = zeros(1,n);
% 
% for i = 1:1:n
%     x = (i-1)/(n-1);
%     z = x*x;
% %     sine(i) = 1;
%     sine(i) = x*(s1-z*(s3+z*(s5-z*(s7+z*(s9-z*(s11+z*(s13)))))));
% end

N = 9600;
n = 1;
sinus   = zeros(1, N);
cosinus = zeros(1, N);

% for x = 0:2*pi/N:2*pi
%     minus = 1;
%     
%     for f = 1:2:21
%         sinus(n) = sinus(n) + minus * (x^f / factorial(f));
%         minus = minus * -1;
%     end
%     
%     n = n + 1;
% end



for x = 0:1:N-1
    minus = 1;
    
    for f = 1:2:25
        sinus(n)    = sinus(n) + minus * ((2*pi*x/N)^f / factorial(f));
        cosinus(n)  = cosinus(n) + minus * ((2*pi*x/N)^(f-1) / factorial(f-1));
        minus = minus * -1;
    end
    
    n = n + 1;
end

tiledlayout(2,1);
ax1 = nexttile;
ax2 = nexttile;
plot(ax1, 0:N-1, sinus);
plot(ax2, 0:N-1, cosinus);


