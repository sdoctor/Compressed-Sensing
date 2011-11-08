
rand('twister',0); randn('state',0);
m = 50; n = 128; k = 14;                   % No. of rows (m), columns (n), and nonzeros (k)
[A,Rtmp] = qr(randn(n,m),0);               % Random encoding matrix with orthogonal rows
A  = A';                                   % ... A is m-by-n
p  = randperm(n); p = p(1:k);              % Location of k nonzeros in x
x0 = zeros(n,1); x0(p) = randn(k,1);       % The k-sparse solution
b  = A*x0;                                 % The right-hand side corresponding to x0

opts = spgSetParms('verbosity',0);         % Turn off the SPGL1 log output
x = spg_bp(A, b, opts);

plot(x0,'r*'); hold on
stem(x ,'b '); hold off
legend('Original coefficients','Recovered coefficients');
title('Basis Pursuit');
