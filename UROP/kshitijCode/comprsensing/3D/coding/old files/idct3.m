function x=idct3(D)

[m,n,p]=size(D);

tmp=zeros(size(D));
for i=1:m
    for j=1:n
        tmp(i,j,:)=idct(D(i,j,:));
    end
end


for i=1:p
    x(:,:,i)=idct2(tmp(:,:,i));
end

