% y = pfft_wrap_part(trans,m,n,x,inds,varargin) 
% varargin{1} = picks
%
% Implements A(:,inds)*x(inds) if trans == false, and A(:,inds)'*x if 
% trans == true, where A is the m x n partial FFT matrix specified by 
% picks (an m x 1 vector that lists the rows of the n x n FFT matrix that 
% comprise A) divided by sqrt(n).
%
% If inds = [], A*x or A'*x is computed.
%
% A = fft(eye(n)) has AA' = nI, and ifft(eye(n)) = 1/n A'.  Thus, to get 
% the proper scaling (Ahat = A/sqrt(n)), fft(x) is divided by sqrt(n) and 
% ifft(x) is multiplied by sqrt(n).

function y = pfft_wrap_part(trans,m,n,x,inds,varargin) 

picks = varargin{1};
if trans
    % y = (A(:,inds))'*x
    y = zeros(n,1);
    y(picks) = x;
    y = ifft(y)*sqrt(n);
    if ~isempty(inds), y = y(inds); end
else
    % y = A(:,inds)*x
    if ~isempty(inds), y = zeros(n,1); y(inds) = x; y = fft(y);
    else y = fft(x); end
    y = y(picks)/sqrt(n);
end

return