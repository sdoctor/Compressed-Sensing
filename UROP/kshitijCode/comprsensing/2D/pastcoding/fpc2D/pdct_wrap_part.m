% y = pdct_wrap_part(trans,m,n,x,inds,varargin) 
% varargin{1} = picks
%
% Implements A(:,inds)*x(inds) if trans == false, and A(:,inds)'*x if 
% trans == true, where A is the m x n partial DCT matrix specified by 
% picks (an m x 1 vector that lists the rows of the n x n DCT matrix that 
% comprise A).
%
% If inds = [], A*x or A'*x is computed.  

function y = pdct_wrap_part(trans,m,n,x,inds,varargin)

picks = varargin{1};
if trans
    % y = (A(:,inds))'*x
    y = zeros(n,1);
    y(picks) = x;
    y = idct(y);
    if ~isempty(inds), y = y(inds); end
else
    % y = A(:,inds)*x
    if ~isempty(inds), y = zeros(n,1); y(inds) = x; y = dct(y);
    else y = dct(x); end
    y = y(picks);
end

return