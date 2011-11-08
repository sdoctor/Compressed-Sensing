function [MeasFrac,SNR]= transcod(I,Trow,Trows,type)


Denominator=norm(double(I),2);      
L=size(I);
D=reshape(Trow,L(1),L(2));

[M,N]=size(D);

T1=repmat([1:M]',[1 N]);
T2=repmat([1:N],[M 1]);
T=T1+T2;

NMeas(1)=0;
for val=2:10:M+N
   NMeas(val)=sum(T(:)<=val);  
   eval(['Trearr =D.*(T(:,:)<=' num2str(val) ');']);
   MeasFrac(val)=NMeas(val)/prod(size(I));
      
switch (type)
   case {1}
      Icap=ifft2(Trearr);
   case {2}
      Icap=idct2(Trearr);
   case {3}
      Icap=waverec2(Trearr,Trows,'haar');
   case {4}
      Icap=waverec2(Trearr,Trows,'db1');
   case {5}
      Icap=waverec2(Trearr,Trows,'sym1');
   otherwise
      disp('Unknown transform.');
end
   Errormatrix=mycolon(I-Icap); 
   Numerator=norm(Errormatrix,2);
   SNR(val)=10*log10(Denominator/Numerator);
   MeasFrac(val)=NMeas(val)/prod(size(I));
   
end
   

