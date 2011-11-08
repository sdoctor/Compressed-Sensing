
function [MeasFrac,SNR]=sparsecod1(I,Trow,Trows,type)
%% SPARSECOD1 means k=m peaks, m=number of measurements, k=number of
%% measurements actually used

[M N] =size(I);

meas=[50:1000:M*N];                                      %% Initializing m
Signal=norm(double(I),2);                                %% Error denominator norm(I)

for i=1:length(meas)                                          %% Looping m. (Ideally should between 1 to 65536)
   m=meas(i);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
   k=m;

   [y,idx]=sort(abs(Trow),'descend');
    
    
   z=zeros(length(y),1);
   z(idx(1:k))=Trow(idx(1:k));

   Trearr=reshape(z,sqrt(length(Trow)),sqrt(length(Trow)));                                 %% Reshape into 2D matrix
  

switch lower(type)
   case {1}
      Icap=ifft2(Trearr);
   case {2}
      Icap=idct2(Trearr);
   case {3}
      Icap=waverec2(Trearr,Trows,'haar');
    case{4}
      Icap=waverec2(Trearr,Trows,'db1');
   case {5}
      Icap=waverec2(Trearr,Trows,'sym1');
   otherwise
      disp('Unknown transform.');
end
    
    Errormatrix=mycolon(I-Icap);                              %% Finding eror matrix
 
    Noise=norm(Errormatrix);

    Aerr(i)=Noise/Signal;                           %% calculating error
   
    
    SNR(i)=10*log10(Signal/Noise);
    MeasFrac(i)=meas(i)/prod(size(I));
      
    
end
