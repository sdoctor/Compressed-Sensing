function w = dwt4D(x, J, af)

% COPIED FROM DWT3D::3-D Discrete Wavelet Transform
%
% USAGE:
%   w = dwt3D(x, stages, af)
% INPUT:
%   x - N1 by N2 by N3 matrix
%       1) Ni all even
%       2) min(Ni) >= 2^(J-1)*length(af)
%   J - number of stages
%   af  - analysis filters
% OUTPUT:
%   w - cell array of wavelet coefficients
% EXAMPLE:
%   [af, sf] = farras;
%   x = rand(128,64,64);
%   w = dwt3D(x,3,af);
%   y = idwt3D(w,3,sf);
%   err = x-y; 
%   max(max(max(abs(err))))
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

for k = 1:J
    k
    [x w{k}] = afb4D(x, af, af, af, af);
   
end
w{J+1} = x;

