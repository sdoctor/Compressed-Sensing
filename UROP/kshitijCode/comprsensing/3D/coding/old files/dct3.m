function D=dct3(x)

[m,n,p]=size(x);

tmp=zeros(size(x));
for i=1:p
    tmp(:,:,i)=dct2(x(:,:,i));
end

for i=1:m
    for j=1:n
        D(i,j,:)=dct(tmp(i,j,:));
    end
end
    