function [MeasFracTC ,SNRTC, MeasFracSC1,SNRSC1,MeasFracSC4,SNRSC4, MeasFracCI,SNRCI]=cod3D(I,Transform,i)
%,MeasFracSC,SNRSC
%#############Transcodct3D
[l,m,n]=size(Transform);
 switch i
   case {1}
    str1='dct3';
       
    [MeasFracTC ,SNRTC]= transcoddct3D(I,Transform);
    [MeasFracSC1,SNRSC1]= sparsecod1dct3D(I,Transform);
    [MeasFracSC4,SNRSC4]= sparsecod4dct3D(I,Transform);
    [MeasFracCS,SNRCS]=comprcoddct3D(I,Transform);
case {2}
     str2='dwt3D';
      
     [MeasFracTC,SNRTC]= transcodwavel3D(I,Transform);
     [MeasFracSC1,SNRSC1]= sparsecod1wavel3Dworking(I,Transform);
     [MeasFracSC4,SNRSC4]= sparsecod4wavel3Dworking(I,Transform);
     [MeasFracCS,SNRCS]= comprcodwavel3Dworking(I,Transform);

case {3}
      str3='fft3';
      
      %% Not coded, not using     
      
      
    end

