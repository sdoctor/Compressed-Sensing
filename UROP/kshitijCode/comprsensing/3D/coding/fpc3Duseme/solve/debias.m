% De-biasing for Compressed Sensing Reconstruction
%
%--------------------------------------------------------------------------
% GENERAL DESCRIPTION & INPUTS
%-------------------------------------------------------------------------- 
%
% x = debias(m,n,x,A,b,M,nse,varargin)
%
% Identifies the non-zero components of x and solves the reduced least-
% squares problem defined by the corresponding columns of A, assuming that 
% the number of non-zeros is in the interval (0,m].
%
% m, n  - A is m x n matrix; typically m < n.
% x     - reconstructed signal x (typically sparse AND an approximate 
%         solution to Ax = b)
% A     - m x n matrix, or function handle that implements A*x and A'*x.  
%         If the latter, this function must have the form
%
%   function y = name(trans,m,n,x,inds,varargin)
%
% where
%
%   trans    - if false then y = A(:,inds)*x, if true then y = A(:,inds)'*x 
%   m, n     - A is m x n
%   x        - length(inds) x 1 vector if ~trans; m x 1 vector if trans
%   inds     - vector of indices; if empty the function should return A*x 
%              or A'*x, as appropriate
%   varargin - placeholder for additional parameters (picks)
%
% b     - m x 1 vector of measurements.  Ax \approx b.
% M     - m x m weighting matrix, unless empty.  If the former, least-
%         squares term is ||Ax - b||_M^2, if the latter, ||Ax - b||_2^2.
% nse   - noise level for distinguishing between x's zeros and non-zeros.
%         if fpc and getM_mu are used, a multiple of sigma (we use 3) is a
%         good choice.
% 
% All variables in varargin are passed to A if A is a function handle.
%--------------------------------------------------------------------------

function x = debias(m,n,x,A,b,M,nse,varargin)

% find non-zeros and count them
inds = find(abs(x) > nse);
nnz = length(inds);

if (nnz > 0) && (nnz <= m)
    % de-bias if reduced least-squares is non-trivial and full column rank
    if ~isa(A,'function_handle')
        x = zeros(n,1);
        if isempty(M)
            x(inds) = A(:,inds)\b;
        else            
            x(inds) = (A(:,inds)'*M*A(:,inds))\(A(:,inds)'*(M*b));
        end
    else
        [xpart,flag] = lsqr(@lsqrMat,b,nse/10,20,[],[],x(inds));
        if flag < 2
            x = zeros(n,1);
            x(inds) = xpart;
        else
            warning('lsqr was not able to converge.  De-biasing has been abandoned.');
        end
    end
end

function y = lsqrMat(x,transpose)
    switch transpose
        case 'transp'
            y = A(true,m,n,x,inds,varargin{:});
        case 'notransp'
            y = A(false,m,n,x,inds,varargin{:});
    end
end

return

end

% Last modified 10 July 2007.