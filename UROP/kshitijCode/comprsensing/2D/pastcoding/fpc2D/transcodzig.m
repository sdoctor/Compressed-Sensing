clc 
clear

I=double(randn(256,256));
Denominator=norm(double(I),2);      
D=dct2(I);

[M,N]=size(D);

T1=repmat([1:M]',[1 N]);
T2=repmat([1:N],[M 1]);
T=T1+T2;

NMeas(1)=0
for val=2:10:M+N
   NMeas(val)=sum(T(:)<=val);  
   eval(['Dnew' num2str(val) '=D.*(T(:,:)<=' num2str(val) ')']);
   MeasFrac(val)=NMeas(val)/prod(size(I));
   eval(['Icap=idct2(Dnew' num2str(val) ');']);
   Errormatrix=mycolon(I-Icap); 
   Numerator=norm(Errormatrix,2);
   SNR(val)=10*log10(Denominator/Numerator);
   MeasFrac(val)=NMeas(val)/prod(size(I));
end
plot(MeasFrac,SNR)