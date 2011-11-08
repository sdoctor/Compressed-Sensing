
clc                                                       %% Clearing up command window and workspace
clear
clear all;
close all;


I=ones(212,212);
% 
% for j=1:64
% 
%  
%     
% eval(['K' num2str(j) '=K' num2str(j) '(1:212,1:212);']);                       %% Image Intake
% 
% end
% 
%  for i=1:64
%     
% eval(['I(:,:,i )= double(K' num2str(i) ');']);
%  end



I=randn(212,212);

for i=1:2
    
    switch i
   case {1}
      str1='dct2';
      case {2}
      str2='dwt3D';
        case {3}
            str3='fft2'
        otherwise
      disp('Unknown transform.')
    end                  

 eval(['[Transform' num2str(i) ']= transform2D(I,str' num2str(i) ' );']);;
  
 eval(['[MeasFracTC' num2str(i) ',SNRTC' num2str(i) ', MeasFracSC' num2str(i) ',SNRSC' num2str(i) ', MeasFracCC' num2str(i) ',SNRCC' num2str(i) ' ]= cod2D(I,Transform' num2str(i) ',' num2str(i) ');' ]);

end


plot(MeasFracTC1,SNRTC1,'*', MeasFracSC1,SNRSC1,'*',MeasFracCC1,SNRCC1,'*',MeasFracTC2,SNRTC2,'*', MeasFracSC2,SNRSC2,'*',MeasFracCC2,SNRCC2,'*');
xlabel('SNR in DB');
ylabel('Measurement Fraction m/n');
legend('DCT3 Transform coding','DCT2 Sparse coding','DCT2 Compressive coding','DWT2 Transform coding','DWT2 Sparse coding','DWT2 Compressive coding');

