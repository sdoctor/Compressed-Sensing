
function [MeasFrac,SNR]=transcodwavel3D(I,T)

[af sf]=farras;
Transformdummy=T;
[m1 m2 m3]=size(I);

Signal=sum(sum(sum(I.^2)));
    

 x=1;
   

%#######################
Transformdummy=T;
%count from 2 to 12: 11 counts in this loop



%7 times 32 32 32
for i=1:7
Transformdummy{1,1}{1,i}=zeros(32,32,32);
end
%7 times 16,16,16
for i=1:7
Transformdummy{1,2}{1,i}=zeros(16,16,16);
    
end

%7 times 888
for i=1:7
Transformdummy{1,3}{1,i}=(zeros(8,8,8));
    
end

%1 times 888  

seg1=Transformdummy{1,4};



segnew=zeros(8,8,8);
segrow=seg1(:);
y=sort(abs(segrow),'descend');

for j=4:8:32

    
factor=(pyramidal(8,8,8))<=j;
Transformdummy{1,4}=factor.*seg1;


[af sf]=farras;
       Icap=idwt3D(Transformdummy,3,sf);
    
       Errormatrix=(I-Icap);                              %% Finding error matrix

    
  Noise=sum(sum(sum(Errormatrix.^2)));
                           % calculating error
   
    
    SNR(x)=10*log10(Signal/Noise);
    MeasFrac(x)=(1+ j);
    x=x+1;   
end % end for j loop



%@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Transformdummy=T;


%x==---

% 7 times 32 32 32
for i=1:7

  Transformdummy{1,1}{1,i}=zeros(32,32,32);
end
% 7 times 16,16,16
for i=1:7
Transformdummy{1,2}{1,i}=zeros(16,16,16);
    
end

%7 times 888 WE KEEP {1,3} progressively with magnitude
for i=1:7
    eval(['seg' num2str(i) '=Transformdummy{1,3}{1,i};']);
    Transformdummy{1,3}{1,i}=zeros(8,8,8);
    
end

for i=1:7
    
eval(['segrow=seg' num2str(i) '(:);']);
y=sort(abs(segrow),'descend');

for j=1:32:64
    
eval(['factor=abs(pyramidal(8,8,8))<=j;']);

eval(['Transformdummy{1,3}{1,i}=factor.*seg' num2str(i) ';']);

for m=1:i-1
            Transformdummy{1,3}{1,m}=T{1,3}{1,m};
    end
    
    
% 1 time 888   WE KEEP

       [af sf]=farras;
       Icap=idwt3D(Transformdummy,3,sf);
    
       Errormatrix=(I-Icap);                              %% Finding error matrix

    
   Noise = sum(sum(sum(Errormatrix.^2)));

                           %% calculating error
   
    
    SNR(x)=10*log10(Signal/Noise);
    MeasFrac(x)=(513+ (i-1)*512 + j);
    x=x+1;
end % end of j loop
end % end of i loop

%%#####################33

    
Transformdummy=T;


%x==---

% 7 times 32 32 32
for i=1:7
Transformdummy{1,1}{1,i}=zeros(32,32,32);
end

% for Transformdummy{1,2} we add with magnitude
% We keep all other components

for i=1:7
    eval(['seg' num2str(i) '=Transformdummy{1,2}{1,i};']);
Transformdummy{1,2}{1,i}=zeros(16,16,16);
end

for i=1:7
    
eval(['segrow=seg' num2str(i) '(:);']);
y=sort(abs(segrow),'descend');

for j=1: 64:256
    thr=y(j);
eval(['factor=abs(pyramidal(16,16,16))<=j;']);


eval(['Transformdummy{1,2}{1,i}=factor.*seg' num2str(i) ';']);
   
% 1 time 888   WE KEEP


for m=1:i-1
            Transformdummy{1,2}{1,m}=T{1,2}{1,m};
    end
    



[af sf]=farras;
       Icap=idwt3D(Transformdummy,3,sf);
    
       Errormatrix=(I-Icap);                              %% Finding error matrix

    
   Noise = sum(sum(sum(Errormatrix.^2)));

                           %% calculating error
   
    
    SNR(x)=10*log10(Signal/Noise);
    MeasFrac(x)=(4097+(i-1)*4096 + j)/244224;
    x=x+1;
end % j loop
end % i loop
 %%##########3
 Transformdummy=T;


%x==---
% We keep everything
% We add {1,1} 7 times 32 32 32 with magnitudes
for i=1:7
    eval(['seg' num2str(i) '=Transformdummy{1,1}{1,i};']);
Transformdummy{1,1}{1,i}=zeros(32,32,32);
end

for i=1:7
    
eval(['segrow=seg' num2str(i) '(:);']);
y=sort(abs(segrow),'descend');

for j=1:64:256
    thr=y(j);
eval(['factor=abs(pyramidal(32,32,32))<=j;']);


eval(['Transformdummy{1,1}{1,i}=factor.*seg' num2str(i) ';']);


for m=1:i-1
            Transformdummy{1,1}{1,m}=T{1,1}{1,m};
    end
    

[af sf]=farras;
       Icap=idwt3D(Transformdummy,3,sf);
    
    
       Errormatrix=(I-Icap);                              %% Finding error matrix

    
    Noise=sum(sum(sum(Errormatrix.^2)));
                           %% calculating error
   
    
    
    
    
    SNR(x)=10*log10(Signal/Noise);
    MeasFrac(x)=(14849+(i-1)*32768 +j);
    x=x+1;
    
end % j loop

end % i loop
MeasFrac=MeasFrac/prod(size(I));

end

