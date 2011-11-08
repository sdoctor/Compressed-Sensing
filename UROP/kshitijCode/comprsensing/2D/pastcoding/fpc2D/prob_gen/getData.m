% COMPRESSED SENSING PROBLEMS
%
%--------------------------------------------------------------------------
% GENERAL DESCRIPTION AND OUTPUTS
%--------------------------------------------------------------------------
%
% function [A,b,xs,xsn,picks] = getData(m,n,k,Ameth,xmeth,varargin)
%
% Generates data for compressed sensing problems.
%
% A     - m x n matrix if A is explicit; empty otherwise
% b     - m x 1 vector equal to A*(xs+noise) + noise
% xs    - n x 1 vector with k nonzeros
% xsn   - n x 1 vector xs + noise
% picks - vector of row indices if A is implicit; empty otherwise
% 
% For compressed sensing, m <= n, and if k is small enough l1 regularized
% least squares applied to A and b will recover xs.
%
%--------------------------------------------------------------------------
% INPUTS
%--------------------------------------------------------------------------
% 
% Ameth determines how A is generated
%   0 - randn(m,n)
%   1 - randn then columns scaled to unit norm
%   2 - randn then QR to get orthonormal rows
%   3 - bernoulli +/- 1 distribution
%   4 - partial Hadamard matrix
%   5 - picks for partial fourier matrix
%   6 - picks for partial discrete cosine transform matrix 
%       REQUIRES Signal Processing Toolbox
%   7 - picks for partial 2-d discrete cosing transform matrix
%       REQUIRES Image Processing Toolbox
%
% xmeth determines how xs is generated
%   0 - randperm for support, 2*randn for values
%   1 - randperm for support, 2*(rand - 0.5) for values
%   2 - randperm for support, ones for values
%   3 - randperm for support, sign(randn) for values
%
% varargin{1} = sigma1 - standard deviation of signal noise (added to xs)
% varargin{2} = sigma2 - standard deviation of meas. noise (added to b)
% varargin{3} = state - state used to initialize rand and randn (scalar
%                       integer 0 to 2^32-1)
%--------------------------------------------------------------------------

function [A,b,xs,xsn,picks] = getData(m,n,k,Ameth,xmeth,d,varargin)

if nargin == 8
    randn('state',varargin{3});
    rand('state',varargin{3});
end

picks = [];
switch Ameth
    case 0
        % randn, no scaling
        A = randn(m,n);
    case 1
        % randn, column scaling
        A = randn(m,n);
        for i = 1:n
            A(:,i) = A(:,i)/norm(A(:,i));
        end
    case 2
        % randn, orthonormal rows
        A = randn(m,n);
        [A,R] = qr(A',0);
        A = A';
    case 3
        % bernoulli +/- 1
        A = sign(rand([m,n]) - 0.5);
        ind = find(A == 0);
        A(ind) = ones(size(ind));
    case 4
        % partial hadamard
        A = hadamard(n);
        picks = randperm(n);
        picks = sort(picks(1:m));
        A = A(picks,:); picks = [];
    case 5
        % partial 1-d fourier transform
        A = @pfft_wrap_part;
        picks = randperm(n);
        picks = sort(picks(1:m));
    case 6
        % partial 1-d discrete cosine transform
        A = @pdct_wrap_part;
        picks = randperm(n);
        picks = sort(picks(1:m));
    case 7
        % partial 2-d discrete cosine transform
        A = @pdct2_wrap_part;
        picks = randperm(n);
        picks = sort(picks(1:m));
end

% get original signal
p = randperm(n);
xs = zeros(n,1);
switch xmeth
    case 0, xs(p(1:k)) = 2*randn(k,1);
    case 1, xs(p(1:k)) = 2*(rand(k,1) - 0.5);
    case 2, xs(p(1:k)) = ones(k,1);
    case 3, xs(p(1:k)) = sign(randn(k,1));
end

% add signal noise
if nargin > 5 && varargin{1} > 0
xsn = imnoise(xs,'gaussian',varargin{1});
else
xsn = xs;
end

% get noiseless measurments
switch Ameth
    case {5,6,7}, b = A(false,m,n,d,[],picks);
    otherwise, b = A*d;
end
% 
% % add measurement noise
 if nargin > 6 && varargin{2} > 0
    b = imnoise(b,'gaussian',varargin{2}); 
end

return