function [MeasFracTC,SNRTC,MeasFracSC1,SNRSC1,MeasFracSC4,SNRSC4, MeasFracCI,SNRCI]=cod(I,Transformrow,Transformapp,i)

 [MeasFracTC,SNRTC]= transcod(I,Transformrow,Transformapp,i);
 [MeasFracSC1,SNRSC1]= sparsecod1(I,Transformrow,Transformapp,i);
 [MeasFracSC4,SNRSC4]= sparsecod4(I,Transformrow,Transformapp,i);
 [MeasFracCI,SNRCI]= comprcod(I,Transformrow,Transformapp,i); 
 
