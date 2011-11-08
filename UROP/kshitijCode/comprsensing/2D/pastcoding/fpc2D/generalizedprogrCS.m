
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


I=double(imread('cameraman.tif'));                       %% Image Intake
s=size(I);                                               %% Storing dimensions of image

for i=1:5
    
    switch i
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
  
 eval(['[Transformrow' num2str(i) ',Transformapp' num2str(i) ']= transform(I,str' num2str(i) ' );']);
 
 eval(['[MeasFrac' num2str(i) ',SNR' num2str(i) ',MeasFrac' num2str(i+5) ',SNR' num2str(i+5) ',MeasFrac' num2str(i+10) ',SNR' num2str(i+10) ']= cod(I,Transformrow' num2str(i) ',Transformapp' num2str(i) ',str' num2str(i) ',' num2str(i) ',str' num2str(i) ' );']);

end

figure;
plot(MeasFrac1,SNR1,MeasFrac2,SNR2,MeasFrac3,SNR3,MeasFrac4,SNR4,MeasFrac5,SNR5,MeasFrac6,SNR6,MeasFrac7,SNR7,MeasFrac8,SNR8,MeasFrac9,SNR9,MeasFrac10,SNR10,MeasFrac11,SNR11,MeasFrac12,SNR12,MeasFrac13,SNR13,MeasFrac14,SNR14,MeasFrac15,SNR15);                               %% Plot Aerr: Error fraction vs measurements used
legend('fft2 TC','dct2 TC','haar TC','db1 TC','sym1 TC','fft2 SC','dct2 SC','haar SC','db1 SC','sym1 SC','fft2 CS','dct2 CS','haar CS','db1 CS','sym1 CS');
xlabel('Fraction of Measurements used');
ylabel('SNR of Reconstruction');
