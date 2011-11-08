function [lo, hi] = afb4D(x, af1, af2, af3, af4)

% COPIED from afd3d file comments::
%3D Analysis Filter Bank
%
% USAGE:
%    [lo, hi] = afb3D(x, af1, af2, af3);
% INPUT:
%    x - N1 by N2 by N3 array matrix, where
%        1) N1, N2, N3 all even
%        2) N1 >= 2*length(af1)
%        3) N2 >= 2*length(af2)
%        4) N3 >= 2*length(af3)
%    afi - analysis filters for dimension i
%       afi(:, 1) - lowpass filter
%       afi(:, 2) - highpass filter
% OUTPUT:
%    lo - lowpass subband
%    hi{d}, d = 1..7 - highpass subbands
% EXAMPLE:
%    x = rand(32,64,16);
%    [af, sf] = farras;
%    [lo, hi] = afb3D(x, af, af, af);
%    y = sfb3D(lo, hi, sf, sf, sf);
%    err = x - y;
%    max(max(max(abs(err))))
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

if nargin < 4
   af2 = af1;
   af3 = af1;
   af4 = af1;
end

% filter along dimension 1
[L, H] = afb4D_A(x, af1, 1);



% filter along dimension 2
[LL LH] = afb4D_A(L, af2, 2);

[HL HH] = afb4D_A(H, af2, 2);


% filter along dimension 3
[LLL LLH] = afb4D_A(LL, af3, 3);
[LHL LHH] = afb4D_A(LH, af3, 3);
[HLL HLH] = afb4D_A(HL, af3, 3);
[HHL HHH] = afb4D_A(HH, af3, 3);

LLL1=1
% filter along dimension 4
[LLLL LLLH] = afb4D_A(LLL, af4, 4);
[LLHL LLHH] = afb4D_A(LLH, af4, 4);

[LHLL LHLH] = afb4D_A(LHL, af4, 4);
[LHHL LHHH] = afb4D_A(LHH, af4, 4);


[HLLL HLLH] = afb4D_A(HLL, af4, 4);
[HLHL HLHH] = afb4D_A(HLH, af4, 4);

[HHLL HHLH] = afb4D_A(HHL, af4, 4);
[HHHL HHHH] = afb4D_A(HHH, af4, 4);

HHHH1=1

lo    = LLLL;
hi{1} = LLLH;
hi{2} = LLHL;
hi{3} = LLHH;
hi{4} = LHLL;
hi{5} = LHLH;
hi{6} = LHHL;
hi{7} = LHHH;
hi{8} = HLLL;
hi{9} = HLLH;
hi{10}= HLHL;
hi{11}= HLHH;
hi{12}= HHLL;
hi{13}= HHLH;
hi{14}= HHHL;
hi{15} =HHHH;

% LOCAL FUNCTION

function [lo, hi] = afb4D_A(x, af, d)

% PASTED from afb3d-A::3D Analysis Filter Bank
% (along one dimension only)
%
% [lo, hi] = afb3D_A(x, af, d);
% INPUT:
%    x - N1xN2xN2 matrix, where min(N1,N2,N3) > 2*length(filter)
%           (Ni are even)
%    af - analysis filter for the columns
%    af(:, 1) - lowpass filter
%    af(:, 2) - highpass filter
%    d - dimension of filtering (d = 1, 2 or 3)
% OUTPUT:
%     lo, hi - lowpass, highpass subbands
%
% % Example
% x = rand(32,64,16);
% [af, sf] = farras;
% d = 2;
% [lo, hi] = afb3D_A(x, af, d);
% y = sfb3D_A(lo, hi, sf, d);
% err = x - y;
% max(max(max(abs(err))))

lpf = af(:, 1);     % lowpass filter
hpf = af(:, 2);     % highpass filter



% permute dimensions of x so that dimension d is first.


p = mod(d-1+[0:3], 4) + 1;
x = permute(x, p);



% filter along dimension 1
[N1, N2, N3, N4] = size(x);
L = size(af, 1)/2;
x = cshift4D(x, -L, 1);
lo = zeros(N1/2+L, N2, N3, N4);
hi = zeros(N1/2+L, N2, N3, N4);


for i =1:N2
    for j=1:N3
        for k=1:N4


            lo(:,i,j, k) = upfirdn(x(:,i,j, k), lpf, 1, 2)';


        end
    end
end



lo(1:L, :, :, :) = lo(1:L, :, :, :) + lo([1:L]+N1/2, :, :, :);
lo = lo(1:N1/2, :, :, :);
% 
% for k = 1:N4
%    hi(:, :, :, k) = upfirdn(x(:, :, :, k), hpf, 1, 2);
% end



for i =1:N2  
    for j=1:N3 
        for k=1:N4
hi(:, i, j,  k) = upfirdn(x(:, i, j,  k), hpf, 1, 2)';
        end
    end
end

hi(1:L, :, :,:) = hi(1:L, :, :, :) + hi([1:L]+N1/2, :, :, :);
hi = hi(1:N1/2, :, :, :);

% permute dimensions of x (inverse permutation)
 lo = ipermute(lo, p);
 hi = ipermute(hi, p);
size(x)
