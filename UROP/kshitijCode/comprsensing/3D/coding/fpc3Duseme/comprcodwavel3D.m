
function [MeasFrac,SNR]=comprcodwavel3D(I,T)

%%%%%%%%%%%%%%%%%%%%%%%%
% Code to arrange 3D DWT as a row vector

[af sf]=farras;
Transformdummy=T;
[m1 m2 m3]=size(I);

Signal=sum(sum(sum(I.^2)));

 

 x='TEST'   
%%Outer loop

x=0;
    
%#######################
Transformdummy=T;
% count from 2 to 12: 11 counts in this loop
x=x+1;
%x==2

% 7 times 32 32 32
  



for i=1:7
eval(['a' num2str(i) '=Transformdummy{1,1}{1,i}(:);']);
end

for i=1:7
eval(['b' num2str(i) '=Transformdummy{1,2}{1,i}(:);']);
end


for i=1:7
eval(['c' num2str(i) '=Transformdummy{1,3}{1,i}(:);']);
end


i=1;
eval(['d' num2str(i) '=Transformdummy{1,4}(:);']);




Trow=[a1;a2;a3;a4;a5;a6;a7;b1;b2;b3;b4;b5;b6;b7;c1;c2;c3;c4;c5;c6;c7;d1];

la1= length(a1);
la2= length(a2);
la3= length(a3);
la4= length(a4);
la5= length(a5);
la6= length(a6);
la7= length(a7);
lb1= length(b1);
lb2= length(b2);
lb3= length(b3);
lb4= length(b4);
lb5= length(b5);
lb6= length(b6);
lb7= length(b7);
lc1= length(c1);
lc2= length(c2);
lc3= length(c3);
lc4= length(c4);
lc5= length(c5);
lc6= length(c6);
lc7= length(c7);
ld1= length(d1);

%%%%%%%%%%%%%%%%%%%%%%
d=Trow; 
xs=d(:); 

[maxmeasallowed] = prod(size(I));

limit = maxmeasallowed;

steps = 2; %% Total number of steps: Note, these steps are time expensive
meas = [ limit*0.6 limit*0.4]

SNR = zeros(1,steps);
 for z=1:steps
 
     
     
% set up the run
n = prod(size(Trow));
delta =meas(z)/n;            % m/n, m = round(delta*n)

%% Assuming k/m to be 0.25, one fourth: Should check with Ashok: Feb 15
rho = 0.25;              % k/m, k = round(rho*m)
Ameth = 6;              % see getData.m for codes
xmeth = 0;              %  "      "      "    "
opts = fpc_opts([]);    % see fpc_opts.m for options
sig1 = 0;            % std. dev. of signal noise
sig2 = 0;            %  "    "   "  measurement noise
full = false;           % whether to use a full or approximate M matrix
opts.fullMu = false;    % if false, just update mu as opts.eta*mu
mu = [];                % mu to use--[] means recommended
sig1est = sig1;         % estimate of sig1 used by getM_mu
sig2est = sig2;         %    "     "  sig2  "   "    "
alpha = 0.5;            % parameter for chi^2 value
nseMult = 3;            % in debias: nse = nseMult*sigma

% plots
xsConvergence = true;
paretoPlot = true;
paretoPlotPlusProgress = true;

% problem size
m = round(delta*n);
k = round(rho*m);

% get problem
data_t = cputime;
[A,b,xs,xsn,picks] = getData(m,n,k,Ameth,xmeth,d,sig1,sig2,1978);
xs=d;
xsn=d;
bwant=b;
data_t = cputime - data_t;
disp([num2str(data_t),' s to get the problem.']);

Mmu_t = cputime;
[M,mu,A,b,sig,kap,tau,M12] = getM_mu(full,mu,m,n,Ameth,A,b,sig1est,sig2est,alpha);
b=bwant;
if ~isempty(M), A = M12*A; b = M12*b; M = []; end
if ~isempty(tau), opts.tau = tau; end
opts.kappa = kap;
Mmu_t = cputime - Mmu_t;
disp([num2str(Mmu_t),' s to estimate M and mu.']);

opts.xs = xs;

% fpc-basic
solve_t = cputime;
Out = fpc(n,A,b,mu,M,opts,picks);
solve_t = cputime - solve_t;
disp([num2str(Out.itr),' iterations and ',num2str(solve_t),...
    ' s to solve the problem to rel. err. ',num2str(Out.n2re(end),'%5.3g'),...
    ' w/ fpc-basic.']);

% de-bias the solution
db_t = cputime;
nse = nseMult*sig;
x = debias(m,n,Out.x,A,b,M,nse,picks);
db_t = cputime - db_t;
n2re_db = norm(x - xs)/norm(xs);
disp([num2str(db_t),' s to de-bias.  Resulting rel. err. is ',...
    num2str(n2re_db),'.']);

% reconstructing wavelet tranform from recovered row coeffs



for i=1:7
eval([Transformdummy{1,1}{1,i}(:)= 'a' num2str(i) ';']);
end

for i=1:7
eval(['b' num2str(i) '=Transformdummy{1,2}{1,i}(:);']);
end


for i=1:7
eval(['c' num2str(i) '=Transformdummy{1,3}{1,i}(:);']);
end


i=1;
eval(['d' num2str(i) '=Transformdummy{1,4}(:);']);




m=[a1;a2;a3;a4;a5;a6;a7;b1;b2;b3;b4;b5;b6;b7;c1;c2;c3;c4;c5;c6;c7;d1];

SNRnondb=norm(xs,2)/norm(x-xs,2);
SNR(z) = 10*log10(SNRnondb);

MeasFrac(z)=meas(z)/limit;


 end
clear A b d xs x;
end
