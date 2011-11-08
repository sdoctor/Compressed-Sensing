function [MeasFrac,SNR] = comprcod (I,Trow,Trows,type)
%% This is Compressive Inversion code
%% It uses k=m, but solves using compressive inversion FPC program
%% It does not add any NOISE#

[maxmeasallowed] = prod(size(I));

limit = maxmeasallowed;
steps = 4; %% Total number of steps: Note, these steps are time expensive
meas = [ limit*0.8 limit*0.6 limit*0.4 limit*0.2]

if type >=2
    MeasFrac =zeros(1,steps);
    SNR =zeros(1,steps);
    
else
    
disp('Solving for type:');
type


d=Trow; 
xs=d(:); 


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

SNRnondb=norm(xs,2)/norm(x-xs,2);
SNR(z) = 10*log10(SNRnondb);

MeasFrac(z)=meas(z)/limit;


 end
clear A b d xs x;
end

end

