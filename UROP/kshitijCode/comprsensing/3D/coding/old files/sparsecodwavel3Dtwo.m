
function [MeasFrac,SNR]=sparsecodwavelThreeDtwo(I,T)

[af sf]=farras;
Transformdummy=T;
[m1 m2 m3]=size(I);

    Denominator2=sum(sum(sum(I.^2)));

 

 x='TEST'   
%%Outer loop

x=1;
    
    
Transformdummy=T;


%#######################
if x==1

% 1 times 888  
Transformdummy{1,4}=(zeros(8,8,8));

%7 times 888
for i=1:7
Transformdummy{1,3}{1,i}=(zeros(8,8,8));
    
end

% 7 times 16,16,16
for i=1:7
Transformdummy{1,2}{1,i}=zeros(16,16,16);
    
end

% 7 times 32 32 32
for i=1:7
Transformdummy{1,1}{1,i}=zeros(32,32,32);
end

end % end of if x<1

[af sf]=farras;
       Icap=idwt3D(Transformdummy,3,sf);
      
       Errormatrix=(I-Icap);                              %% Finding error matrix

    
    Numerator2=sum(sum(sum(Errormatrix.^2)));
   
  

                           %% calculating error
   
    
    SNR(x)=10*log10(Denominator2/Numerator2);
    MeasFrac(x)=1;
  
   


%#######################
Transformdummy=T;
% count from 2 to 12: 11 counts in this loop
x=x+1;
%x==2

% 7 times 32 32 32
  



for i=1:7
eval(['a' num2str(i) '=Transformdummy{1,1}{1,i};']);
end

for i=1:7
eval(['b' num2str(i) '=Transformdummy{1,2}{1,i};']);
end


for i=1:7
eval(['c' num2str(i) '=Transformdummy{1,3}{1,i};']);
end


i=1;
eval(['d' num2str(i) '=Transformdummy{1,4};']);




m=cat(22,a1,a2,a3,a4,a5,a6,a7,b1,b2,b3,b4,b5,b6,b7,c1,c2,c3,c4,c5,c6,c7,d1);

segrow=m(:);
y=sort(abs(segrow),'descend');

for j=1: 40000:220000

    thr=y(j);
    
 

for i=1:7
Transformdummy{1,1}{1,i}=Transformdummy{1,1}{1,i}*[Transformdummy{1,2}{1,i}>=thr];
end


for i=1:7
Transformdummy{1,1}{1,i}=Transformdummy{1,2}{1,i}*[Transformdummy{1,2}{1,i}>=thr];
end


for i=1:7
Transformdummy{1,1}{1,i}=Transformdummy{1,3}{1,i}*[Transformdummy{1,2}{1,i}>=thr];
end



Transformdummy{1,1}{1,1}=Transformdummy{1,4}{1,1}*[Transformdummy{1,2}{1,1}>=thr];

    
    
    
    
    

[af sf]=farras;
       Icap=idwt3D(Transformdummy,3,sf);
    
       Errormatrix=(I-Icap);                              %% Finding error matrix

     Numerator2=sum(sum(sum(Errormatrix.^2)));
                           %% calculating error
   
    
    SNR(x)=10*log10(Denominator2/Numerator2);
    MeasFrac(x)=x;
    x=x+1;   
end % end for j loop



%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
