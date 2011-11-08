function y = sfb4D(lo, hi, sf1, sf2, sf3, sf4)

% 3D Synthesis Filter Bank
%
% USAGE:
%   y = sfb3D(lo, hi, sf1, sf2, sf3);
% INPUT:
%   lo, hi - lowpass subbands
%   sfi - synthesis filters for dimension i
% OUPUT:
%   y - output array
% See afb3D
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

if nargin < 5
   sf2 = sf1;
   sf3 = sf1;
   sf4=sf1;
end


LLLL = lo;
LLLH = hi{1};
LLHL = hi{2};
LLHH = hi{3};
LHLL = hi{4};
LHLH = hi{5};
LHHL = hi{6};
LHHH = hi{7};
HLLL = hi{8};
HLLH = hi{9};
HLHL = hi{10};
HLHH = hi{11};
HHLL = hi{12};
HHLH = hi{13};
HHHL = hi{14};
HHHH = hi{15};


% filter along dimension 4
LLL = sfb4D_A(LLLL, LLLH, sf3, 4);
LLH = sfb4D_A(LLHL, LLHH, sf3, 4);
LHL = sfb4D_A(LHLL, LHLH, sf3, 4);
LHH = sfb4D_A(LHHL, LHHH, sf3, 4);
HLL = sfb4D_A(HLLL, HLLH, sf3, 4);


HLH = sfb4D_A(HLHL, HLHH, sf3, 4);
HHL = sfb4D_A(HHLL, HHLH, sf3, 4);
HLH = sfb4D_A(HLHL, HLHH, sf3, 4);

HLH = sfb4D_A(HLHL, HLHH, sf3, 4);

HHL = sfb4D_A(HHLL, HHLH, sf3, 4);
HHH = sfb4D_A(HHHL, HHHH, sf3, 4);

LLLfull=1;

% filter along dimension 3
LL = sfb4D_A(LLL, LLH, sf3, 3);
LH = sfb4D_A(LHL, LHH, sf3, 3);
HL = sfb4D_A(HLL, HLH, sf3, 3);
HH = sfb4D_A(HHL, HHH, sf3, 3);

% filter along dimension 3
L = sfb4D_A(LL, LH, sf2, 2);
H = sfb4D_A(HL, HH, sf2, 2);

% filter along dimension 1
y = sfb4D_A(L, H, sf1, 1);


% LOCAL FUNCTION

function y = sfb4D_A(lo, hi, sf, d)

% 3D Synthesis Filter Bank
% (along single dimension only)
%
% y = sfb3D_A(lo, hi, sf, d);
% sf - synthesis filters
% d  - dimension of filtering
% see afb2D_A

lpf = sf(:, 1);     % lowpass filter
hpf = sf(:, 2);     % highpass filter

% permute dimensions of lo and hi so that dimension d is first.
p = mod(d-1+[0:3], 4) + 1;
lo = permute(lo, p);
hi = permute(hi, p);

[N1, N2, N3, N4] = size(lo);
N = 2*N1;
L = length(sf);
y = zeros( N+L-2, N2,N3, N4);


size(lo)
size(hi)
for i =1:N2  for j=1:N3 for k=1:N4
            
        
y( :, i, j, k) = upfirdn(lo(:, i, j, k), lpf, 2, 1)'+ upfirdn(hi(:, i, j, k), hpf, 2, 1)';
 

end
end
end





y(1:L-2, :, :,:) = y(1:L-2, :, :,:) + y(N+[1:L-2], :, :,:);
y = y(1:N, :, :,:);


y = cshift4D(y, 1-L/2, 1);


% permute dimensions of y (inverse permutation)
y = ipermute(y, p);
% 
  
% 
% 

%%%%%%%%%%%%%%%%%%%%%%

