function Z=pyramidal(a,b,c)

M=a;
N=b;
O=c;
T1=repmat([1:M]',[1 N]);
T2=repmat([1:N],[M 1]);
T=T1+T2;
T3=T1+T2;

T4=T3;

for i=1:a
 for   j=1:b
    for k=1:c
    Z(i,j,k)=T3(i,j)+T4(i,k);
    end
 end
end
