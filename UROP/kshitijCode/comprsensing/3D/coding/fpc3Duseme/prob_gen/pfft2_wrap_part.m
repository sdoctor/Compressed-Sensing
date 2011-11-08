% y = pfft2_wrap_part(trans,m,n,x,inds,varargin) 
% varargin{1} = picks
%
% Implements A(:,inds)*x(inds) if trans == false, and (1/n)*A(:,inds)'*x if 
% trans == true, where A is the m x n partial FFT matrix specified by 
% picks (an m x 1 vector that lists the rows of the n x n FFT matrix that 
% comprise A) divided by n.
%
% If inds = [], A*x or A'*x is computed.  
%
% A = fft2(eye(n)) has AA' = n^2 I, and ifft(eye(n)) = 1/n^2 A'.  Thus, to 
% get the proper scaling (Ahat = A/n), fft(x) is divided by n and ifft(x) 
% is multiplied by n.

function y = pfft2_wrap_part(trans,m,n,x,inds,varargin) 

picks = varargin{1};
if trans
    % y = (A(:,inds))'*x
    y = zeros(n,1);
    y(picks) = x;
    y = ifft2(y)*n;
    if ~isempty(inds), y = y(inds); end
else
    % y = A(:,inds)*x
    if ~isempty(inds), y = zeros(n,1); y(inds) = x; y = fft2(y);
    else y = fft2(x); end
    y = y(picks)/n;
end

return