function [MeasFrac,SNR]= sparsecod4dct3D(I,Transform)
Signal=norm(mycolon(I),2);
      
[y,idx]=sort(abs(mycolon(Transform)),'ascend');

[h w] = size(y);
for i=4:12000:length(mycolon(Transform))
   % since measurements actually used = h-i, we calculate equivalent inew
   % for giving measnew = meas/4
   meas = h-i; 
   measnew=floor(meas/4);
   inew = h -measnew;
   Thr=y(inew);

   Trearr=Transform.*(abs(Transform)>=Thr);
   Icap=idct3(Trearr);
 
   Errormatrix=mycolon(I-Icap); 
   Noise(i)=norm(Errormatrix,2);
   SNR(i)=10*log10(Signal/Noise(i));
   
   MeasFrac(i)=(h-i)/length(mycolon(I));
   
end
 end