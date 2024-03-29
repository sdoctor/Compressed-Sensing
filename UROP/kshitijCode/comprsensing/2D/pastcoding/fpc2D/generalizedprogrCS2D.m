
%{
Comparison of Compressive Sensing and Transform Coding Performances on different imaging signals

Assignment 2:
Use multiple 512*512 images, [Using 256*256 for test run]

Write a generalized program:

1. That reads images from a  folder of database images
2. Gives the image as input to a generalized transform function
3. Takes out the transformed output and gives it to a generalised compression function
4. Takes the output as a row vector form for both sparse coding and compressive sensinga nd transform coding
5. plots the curves of SNR vs Fraction of measurements
%}


clc                                                       %% Clearing up command window and workspace
clear
clear all;
close all;

for count=1:1
%eval(['I=double(256*rgb2gray(imread(''E:\comprsensing\2Ddatabase\1_' num2str(count) '_s.bmp'')));']);                       %% Image Intake                       %% Image Intake
%I =I(1:212,1:212);

I=double(imread('cameraman.tif'));
I =I(1:212,1:212);
s=size(I);                                               %% Storing dimensions of image


% pre- allocation

for i=1:20
    eval(['SNR' num2str(i) ' = 0;']);
end

for i=1:20
    eval(['SNR' num2str(i) 'sum = 0;']);
end


for i=1:20
    eval(['MeasFrac' num2str(i) ' = 0;']);
end

test = [1 1 1 1 1];% REMOVE

for i=1:5
    
    switch i    % chenge l to i later
   case {1}
      str1='fft2';
      case {2}
      str2='dct2';
      case {3}
      str3='haar';
      case {4}
      str4='db1';
      case {5}
      str5='sym1';
      otherwise
      disp('Unknown transform.')
    end
  
 eval(['[Transformrow' num2str(i) ',Transformapp' num2str(i) ']= transform(I,' num2str(i) ' );']);
 
 eval(['[MeasFrac' num2str(i) ',SNR' num2str(i) ',MeasFrac' num2str(i+5) ',SNR' num2str(i+5) ',MeasFrac' num2str(i+10) ',SNR' num2str(i+10) ',MeasFrac' num2str(i+15) ',SNR' num2str(i+15) ']= cod(I,Transformrow' num2str(i) ',Transformapp' num2str(i) ',' num2str(i) ' );']);
end


%% These variables store sums of SNRs for each count
for i=1:20
    eval(['SNR' num2str(i) 'sum =  SNR' num2str(i) 'sum + SNR' num2str(i) ';']);
end

 
end

% pre allocation
for i=1:20
    eval(['SNR' num2str(i) 'avg = 0;']);
end
%% These variables store avegrage from sums of SNRs for all counts
for i=1:20
    eval(['SNR' num2str(i) 'avg =  SNR' num2str(i) 'sum/count;']);
end


figure;
plot(MeasFrac1,SNR1avg,'*',MeasFrac2,SNR2avg,'*',MeasFrac3,SNR3avg,'*',MeasFrac4,SNR4avg,'*',MeasFrac5,SNR5avg,'*',MeasFrac6,SNR6avg,'*',MeasFrac7,SNR7avg,'*',MeasFrac8,SNR8avg,'*',MeasFrac9,SNR9avg,'*',MeasFrac10,SNR10avg,'*',MeasFrac11,SNR11avg,'*',MeasFrac12,SNR12avg,'*',MeasFrac13,SNR13avg,'*',MeasFrac14,SNR14avg,'*',MeasFrac15,SNR15avg,'*',MeasFrac16,SNR16avg,'*',MeasFrac17,SNR17avg,'*',MeasFrac18,SNR18avg,'*',MeasFrac19,SNR19avg,'*',MeasFrac20,SNR20avg,'*');                               %% Plot Aerr: Error fraction vs measurements used
axis([0 1 5 60]);
legend('fft2 TC','dct2 TC','haar TC','db1 TC','sym1 TC','fft2 SC1','dct2 SC1','haar SC1','db1 SC1','sym1 SC1', 'fft2 SC4','dct2 SC4','haar SC4','db1 SC4','sym1 SC4','fft2 CI','dct2 CI','haar CI','db1 CI','sym1 CI');
xlabel('Fraction of Measurements used');
ylabel('SNR of Reconstruction');

%% Finding conex ulls of best performance of each method of codingw ith any basis

SNRTCconvex = max( [SNR1avg; SNR2avg;SNR3avg;SNR4avg;SNR5avg]);
SNRSC1convex = max([SNR6avg; SNR7avg;SNR8avg;SNR9avg;SNR10avg]);
SNRSC4convex = max([SNR11avg; SNR12avg;SNR13avg;SNR14avg;SNR15avg]);
SNRCIconvex = max([SNR16avg; SNR17avg;SNR18avg;SNR19avg;SNR20avg]);

figure;
plot(MeasFrac1,SNRTCconvex,'*',MeasFrac6,SNRSC1convex,'*',MeasFrac11,SNRSC4convex,'*',MeasFrac16,SNRCIconvex);                               %% Plot Aerr: Error fraction vs measurements used
axis([0 1 5 60]);
legend('Convex hull TC','Convex hull SC1','Convex hull SC4','Convex hull CI');
xlabel('Fraction of Measurements used (2D Signals)');
ylabel('SNR of Reconstruction')
