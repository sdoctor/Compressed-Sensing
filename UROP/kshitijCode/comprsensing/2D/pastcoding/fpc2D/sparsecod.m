
function [MeasFrac,SNR]=sparsecod(I,Trow,Trows,type)

[M N] =size(I);

meas=[536:1000:M*N];                                        %% Initializing m
Denominator=norm(double(I),2);                                %% Error denominator norm(I)

for i=1:length(meas)                                          %% Looping m. (Ideally should between 1 to 65536)
   m=meas(i);
   %k=uint32(m/5);                                            %%  Calculating k : m=5k
    
   k=m;

    [y,idx]=sort(abs(Trow),'descend');
    
    
    z=zeros(length(y),1);
    z(idx(1:k))=Trow(idx(1:k));

    Trearr=reshape(z,sqrt(length(Trow)),sqrt(length(Trow)));                                 %% Reshape into 2D matrix
  

switch lower(type)
   case {'fft2'}
      Icap=ifft2(Trearr);
   case 'dct2'
      Icap=idct2(Trearr);
   case 'haar'
      Icap=waverec2(Trearr,Trows,'haar');
   case 'db1'
      Icap=waverec2(Trearr,Trows,'db1');
   case 'sym1'
      Icap=waverec2(Trearr,Trows,'sym1');
   otherwise
      disp('Unknown transform.')
end
    %% figure, imshow(A);
    %% figure, imshow(D);


    Errormatrix=mycolon(I-Icap);                              %% Finding eror matrix

    
    Numerator=norm(Errormatrix);

    Aerr(i)=Numerator/Denominator;                           %% calculating error
   
    
    SNR(i)=10*log10(Denominator/Numerator);
    MeasFrac(i)=meas(i)/prod(size(I));
    
    
end
