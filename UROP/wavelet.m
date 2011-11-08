% Psuedocode:
% Take a 2D image 
% Do a DCT on it
% Remove all coef except first "m" (25000)
% Inverse DCT oN that to get image
% error is reconstructed signal - x'

% Read image
% I = imread('2_28_s.bmp');
% I = im2double(I);
% s = size(I);
% disp(['size of I = ']);
% disp(s);
%     
% Get DCT of the image
%%I_transformed = dct2(I);

% Remove all coef except first "m" 
%m = 250; % TODO: Make parameter that you pass in?

% go through and sort the values, but using an array of indices
%%[I_sorted, indices] = sort(I_transformed);
%%%%%%%end
% ^^ could make this faster with heaps, etc?
% http://www.geeksforgeeks.org/archives/2392

% Inverse DCT on coefs to get the image
%compressed_image = idct2(coefs);

I = imread('2_28_s.bmp');
I = im2double(I);
T = dctmtx(8);
dct = @(block_struct) T * block_struct.data * T';
B = blockproc(I,[8 8],dct);
mask = [1   1   1   1   0   0   0   0
        1   1   1   0   0   0   0   0
        1   1   0   0   0   0   0   0
        1   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0];
B2 = blockproc(B,[8 8],@(block_struct) mask .* block_struct.data);
invdct = @(block_struct) T' * block_struct.data * T;
I2 = blockproc(B2,[8 8],invdct);
imshow(I), figure, imshow(I2)






%display image
%image(compressed_image);

%imshow(compressed_image), figure, imshow(I);
imshow(I);   
