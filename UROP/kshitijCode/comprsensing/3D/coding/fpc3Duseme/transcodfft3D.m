function [MeasFrac,SNR]= transcodfft3D(I,Transform)

Signal=sum(sum(sum(abs(I).^2)));

[M,N,P]=size(Transform);


for i=1:M
    for j=1:N
        for k=1:P
            T(i,j,k) =i+j+k;
        end
    end
end


NMeas(1)=0;
for val=2:100:M+N+P
   NMeas(val)=sum(T(:)<=val);  
   
   eval(['Trearr(:,:,:) =Transform(:,:,:).*(T(:,:,:)<=' num2str(val) ');']);
      
   Icap=ifft(ifft(ifft(Trearr,[],3),[],2),[],1);
 
   Errormatrix=abs(I-Icap); 
   Noise(val)=sum(sum(sum(abs(Errormatrix).^2)));
   SNR(val)=10*log10(Signal/Noise(val));
   MeasFrac(val)=NMeas(val)/prod(size(Transform));
   
end
end
