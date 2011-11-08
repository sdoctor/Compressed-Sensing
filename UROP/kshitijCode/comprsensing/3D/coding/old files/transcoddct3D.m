function [MeasFrac,SNR]= transcoddct3D(I,Transform)

Signal=sum(sum(sum(I.^2)));

[M,N,P]=size(Transform);


for i=1:64
    for j=1:64
        for k=1:64
            T(i,j,k) = i+j+k;
        end
    end
end



NMeas(1)=0;
for val=2:5:M+N+P
   NMeas(val)=sum(T(:)<=val);  
   Trearr =zeros(M,N,P);
   eval(['Trearr(:,:,:) =Transform(:,:,:).*(T(:,:,:)<=' num2str(val) ');']);
   
   Icap=idct3(Trearr);
 
   Errormatrix=(I-Icap); 
   Noise=sum(sum(sum(Errormatrix.^2)));
   SNR(val)=10*log10(Signal/Noise);
   MeasFrac(val)=NMeas(val)/prod(size(I));
end

   
end
