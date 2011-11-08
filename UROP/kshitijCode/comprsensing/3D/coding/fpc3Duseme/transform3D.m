function [T]= transform3D(I,i)

switch (i)
   
   case {1}
       
       T=dct3(I);
             
       
   case {2}
       [af sf]=farras;
       T=dwt3D(I,3,af);
   
    case {3}
        T=fft(fft((fft(I,[],1)),[],2),[],3);
                
   otherwise
      disp('Unknown transform.')
end

