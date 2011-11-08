
%{
Comparison of Compressive Sensing and Transform Coding Performances on different imaging signals

Problem:
Use multiple 64 64 64 videos, [Uisng randn generated for test run]

Write a generalized program:

1. That reads vids from a  folder of database vids
2. Gives the vid as input to a generalized transform function
3. Takes out the transformed output and gives it to a generalised compression function
4. Takes the output as a row vector form for both sparse coding and compressive sensinga nd transform coding
5. plots the curves of SNR vs Fraction of measurements
%}


clc                                                       %% Clearing up command window and workspace
clear
clear all;
close all;

for count=1:1;
% i = IcounththVideo for test run
I =randn(64,64,64);

s=size(I);                                               %% Storing dimensions of image



% Only 2 basis types DCT and DWT, each has 4 coding methods

% pre- allocation

for i=1:8
    eval(['SNR' num2str(i) ' = 0;']);
end

for i=1:8
    eval(['SNR' num2str(i) 'sum = 0;']);
end


for i=1:8
    eval(['MeasFrac' num2str(i) ' = 0;']);
end


for i=1:2
    
    switch i
      case {1}
      str1='dct3';
      case {2}
      str3='dwt3D';
      %% Example: SIZE 64 64 64 3rd level decomposition: Uses farras DWT3D a = randn(64,64,64); z= dwt3D(a, 3,af);
      
      otherwise
      disp('Unknown transform.')
    end
  
 eval(['[Transform' num2str(i) ']= transform3D(I,' num2str(i) ' );']);
 
 eval(['[MeasFrac' num2str(i) ',SNR' num2str(i) ',MeasFrac' num2str(i+2) ',SNR' num2str(i+2) ',MeasFrac' num2str(i+4) ',SNR' num2str(i+4) ',MeasFrac' num2str(i+6) ',SNR' num2str(i+6) ']= cod3D(I,Transform' num2str(i) ',' num2str(i) ');']);
end


%% These variables store sums of SNRs for each count
for i=1:8
    eval(['SNR' num2str(i) 'sum =  SNR' num2str(i) 'sum + SNR' num2str(i) ';']);
end

 
end

% pre allocation
for i=1:8
    eval(['SNR' num2str(i) 'avg = 0;']);
end
%% These variables store avegrage from sums of SNRs for all counts
for i=1:8
    eval(['SNR' num2str(i) 'avg =  SNR' num2str(i) 'sum/count;']);
end


figure;
plot(MeasFrac1,SNR1avg,'*',MeasFrac2,SNR2avg,'*',MeasFrac3,SNR3avg,'*',MeasFrac4,SNR4avg,'*',MeasFrac5,SNR5avg,'*',MeasFrac6,SNR6avg,'*',MeasFrac7,SNR7avg,'*',MeasFrac8,SNR8avg,'*');                               %% Plot Aerr: Error fraction vs measurements used
axis([0 1 5 60]);
legend('dct3 TC','dwt3TC','dct3 SC1','dwt3SC1','dct3 SC4','dwt3SC4','dct3 CI','dwt3 CI');
xlabel('Fraction of Measurements used');
ylabel('SNR of Reconstruction');

%% Finding conex ulls of best performance of each method of codingw ith any basis

SNRTCconvex = max( [SNR1avg; SNR2avg]);
SNRSC1convex = max([SNR3avg; SNR4avg]);
SNRSC4convex = max([SNR5avg; SNR6avg]);
SNRCIconvex = max([SNR7avg; SNR8avg]);

figure;
plot(MeasFrac1,SNRTCconvex,'*',MeasFrac3,SNRSC1convex,'*',MeasFrac5,SNRSC4convex,'*',MeasFrac7,SNRCIconvex);                               %% Plot Aerr: Error fraction vs measurements used
axis([0 1 5 60]);
legend('Convex hull TC','Convex hull SC1','Convex hull SC4','Convex hull CI');
xlabel('Fraction of Measurements used');
ylabel('SNR of Reconstruction')
