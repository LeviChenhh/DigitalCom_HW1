%% This program plots sensitivity of OFDM subcarriers with Carrier
%% frequency offset(CFO)
% Prepared by Hiren Gami (gamihiren@yahoo.com)


% Suggested Reference:
% Morelli et al, "Synchronizaton Techniques for OFDMA : 
% A Tutorial Review", Proc. of IEEE, vol. 95, No. 7, July 2007 


clc
clear all

e = 0;          % Normalized CFO
N = 16;         % Total Subcarriers
Indx = 0.01;    % Over sampling index
vi = 1;         % counter index
for k = 0:Indx:N-1
    hi = 1;     % counter index
    for l = 0:N-1
       % this function calculates effect of CFO. Bias 1 is deliberately 
       % added in order to evaluate function at zero CFO.
       f(vi,hi) = 1 +(sin(pi*(l+e-k))*exp(1i*pi*(N-1)*(l+e-k)/N))...
                  /(N*sin(pi*(l+e-k)/N));
       hi = hi+1;
    end
    vi = vi+1;
end

plot([0:Indx:N-1],abs(f(:,1)),'r'); 
hold on; grid on; 
title('Consecutive OFDM Subcarriers in Time domain');
xlabel('Subcarrier index');ylabel('Amplitude');

for n = 1:N-1
    plot([0:Indx:N-1],abs(f(:,n+1)));
end