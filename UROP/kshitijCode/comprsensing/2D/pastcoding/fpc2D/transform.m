function [Trow,Trows]= transform(I,type)

switch (type)
   case {1}
      T=fft2(I);
      Trow=T(:);
      Trows=0;
   case {2}'
      T=dct2(I);
      Trow=T(:);
      Trows=0;
   case {3}
      [Trow, Trows]=wavedec2(I,2,'haar');
   case {4}
      [Trow,Trows]=wavedec2(I,2,'db1');
   case {5}
      [Trow,Trows]=wavedec2(I,2,'sym1');
   otherwise
      disp('Unknown transform.')
end

