
clc                                                       %% Clearing up command window and workspace
clear
clear all;
close all;

for count =0:1

n=64;
SNRTC1sum=0;
SNRSC1sum=0;
SNRCC1sum=0;


SNRTC2sum=0;
SNRSC2sum=0;
SNRCC2sum=0;

for j=0:64

 
    
eval(['K' num2str(j) '=double(256*rgb2gray(imread(''C:\Users\Rohit\Desktop\Matlabwork\comprsensing\3Ddatabase\01\01' num2str(count*64 + floor(j/4)) '.png'')));']);                       %% Image Intake

%s=size(K0); %% Storing dimensions of image
end

I=ones(64,64,64);

for j=1:64

 
    
eval(['K' num2str(j) '=K' num2str(j) '(101:164,101:164);']);                       %% Image Intake

end

 for i=1:64
    
eval(['I(:,:,i )= double(K' num2str(i) ');']);
 end



for i=1:1:2
    
    switch i
   case {1}
      str1='dct3';
      case {2}
      str2='dwt3D';
        case {3}
            str3='fft3'
        otherwise
      disp('Unknown transform.')
    end                  

 eval(['[Transform' num2str(i) ']= transform3D(I,i );']);
  
 eval(['[MeasFracTC' num2str(i) ',SNRTC' num2str(i) ', MeasFracSC' num2str(i) ',SNRSC' num2str(i) ', MeasFracCC' num2str(i) ',SNRCC' num2str(i) ' ]= cod3D(I,Transform' num2str(i) ',' num2str(i) ');' ]);

end

SNRTC1sum=SNRTC1sum + SNRTC1;
SNRSC1sum=SNRSC1sum + SNRSC1;
SNRCC1sum=SNRCC1sum + SNRCC1;


SNRTC2sum=SNRTC2sum + SNRTC2;
SNRSC2sum=SNRSC2sum + SNRSC2;
SNRCC2sum=SNRCC2sum + SNRCC2;
end


SNRTC1avg=SNRTC1sum/count;
SNRSC1avg=SNRSC1sum/count;
SNRCC1avg=SNRCC1sum/count;


SNRTC2avg=SNRTC2sum/count;
SNRSC2avg=SNRSC2sum/count;
SNRCC2avg=SNRCC2sum/count;

%plot(MeasFracTC1,SNRTC1avg,'*', MeasFracSC1,SNRSC1avg,'*',MeasFracCC1,SNRCC1avg,'*',MeasFracTC2,SNRTC2avg,'*', MeasFracSC2,SNRSC2avg,'*',MeasFracCC2,SNRCC2avg,'*');
plot(MeasFracTC1,SNRTC1avg,'*', MeasFracSC1,SNRSC1avg,'*',MeasFracCC1,SNRCC1avg,'*');



ylabel('SNR in DB (averaged over numel ''n'' dataset)');
xlabel('Measurement Fraction m/n');
%legend('DCT3 Transform coding','DCT3 Sparse coding','DCT3 Compressive coding','DWT3 Transform coding','DWT3 Sparse coding','DWT3 Compressive coding');
legend('DCT4 Transform coding','DCT4 Sparse coding','DCT4 Compressive coding');

