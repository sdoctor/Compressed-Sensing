
function [MeasFrac,SNR]=sparsecodwavelenergytest(I,T)

[af sf]=farras;
Transformdummy=T;
[m1 m2 m3]=size(I);

    Denominator2=sum(sum(sum(I.^2)));

 SNR(1)=0;

 x='ENERGY TEST'   
%%Outer loop

 
x=1;

%#######################

% count from 2 to 12: 11 counts in this loop

%x==2


  

for p=1:3:7
for i=1:16:32
    for j=1:16:32
        for k=1:16:32
 

    Transformdummy=T;

            Transformdummy{1,1}{1,p}(i,j,k)=1;
            
       

  a=1

[af sf]=farras;
       Icap=idwt3D(Transformdummy,3,sf);
    
       
     Numerator2=sum(sum(sum(Icap.^2)))
                           %% calculating error
   
    
    SNR(x)=(Numerator2);
    MeasFrac(x)=x;
    x=x+1;  
   
     end
    end
end

end 


%#############


for p=1:3:7
for i=1:8:16
    for j=1:8:16
        for k=1:8:16
            
a=2

            Transformdummy=T;
            Transformdummy{1,2}{1,p}(i,j,k)=1;
         
    

[af sf]=farras;
       Icap=idwt3D(Transformdummy,3,sf);
    
                                    %% Finding error matrix

     Numerator2=sum(sum(sum(Icap.^2)))
                           %% calculating error
   
    
    SNR(x)=(Numerator2);
    MeasFrac(x)=x;
    x=x+1;  
    
     end
    end
end

end 






%@@@@@@@@@@@@@@@@@@@@@@@@@@@@


for p=1:3:7
for i=1:6:8
    for j=1:6:8
        for k=1:6:8
            
Transformdummy=T;

            Transformdummy{1,3}{1,p}(i,j,k)=1;
       

    
a=3
[af sf]=farras;
       Icap=idwt3D(Transformdummy,3,sf);
    
                                     %% Finding error matrix

     Numerator2=sum(sum(sum(Icap.^2)))
                           %% calculating error
   
    
    SNR(x)=Denominator2;
    MeasFrac(x)=x;
    x=x+1;  
    %Transformdummy{1,3}{1,p}(i,j,k)=0;
     end
    end
end

end 







%#####################

for p=1:1
for i=1:6:8
    for j=1:6:8
        for k=1:6:8
            Transformdummy=T;
            Transformdummy{1,4}(i,j,k)=1;
       
a=4
    

[af sf]=farras;
       Icap=idwt3D(Transformdummy,3,sf);
    
                                   %% Finding error matrix

     Numerator2=sum(sum(sum(Icap.^2)))
                           %% calculating error
   
    
    SNR(x)=Denominator2;
    MeasFrac(x)=x;
    x=x+1;  
    
     end
    end
end

end 




%SNR=a;
