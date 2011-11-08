%function [output] = compressedSensing(NumMeasurements)

% take a 2D image
% build random matrix M
% Y = Mx
% consider DCT Basis y = MCt
% apply SPGL1 on y to get t
% apply inverse DCT(t) to get x back
% error is original image - x


% Take a 2D Image
[B, map1] = imread('1_8_s.bmp');
B = double(B);
J = imresize(B, .1); % originally is it real big, so this brings it down
[orig_height, orig_width, orig_depth] = size(J);
disp('origheight, orig width = ');
disp(size(J));
I = J(:); % Gets a 1xs vector, where s is total num pixels
[s, h] = size(I);
disp('Size of image = ');
disp(size(I));
%I = im2double(I);
%I = rgb2gray(I);
disp('Size of image after im2double THing');
disp(size(I));

% T = dctmtx(8);
% dct = @(block_struct) T * block_struct.data * T';


% Build a random matrix M of size (mxn)
m = 1000;
M = rand(m, s);

% Y = Mx
%y = M*I;

% Get the coeffs of x
coefs = dct2(I);

% show the DCT coeffs for the image
plot(coefs)

% Show the log of the amplitude over the log of the frequency
indices = zeros(s, 1);
for j=1:s
    indices(j) = j;
end
log_coefs = log10(abs(coefs));
log_indices = log10(indices);
slope = log_coefs/log_indices;
figure;
plot(slope)

disp('size of coefs after dct2(I)');
disp(size(coefs));
new_coefs = zeros(s, 1);
disp('size of new_coefs when all zeros:');
disp(size(new_coefs));
disp('now making copy of coefs bigger than some m');
for i=1:m
    new_coefs(i) = coefs(i);
end

% Consider DCT Basis Y = M*C*x_coefs
disp('now mking dctmtx(s)');
C = dctmtx(s);

disp('size of C = ');
disp(size(C));
disp('size of new_coefs = ');
disp(size(new_coefs));

y = M*C*new_coefs;

disp('size of y = ');
disp(size(y));

disp('size of M*C = ');
disp(size(M*C));


% Apply SPGL1 on y to get t
disp('now beginning SPGL1');
opts = spgSetParms('verbosity', 0);
t = spg_bp(M*C, y, opts);
disp('done with spgl1! size of t = ');
disp(size(t));

% Apply inverse DCT To get x back
x = idct2(t);

% Error is original image - x
 %err = I - x;
 %disp('Error = ');
 %disp(err);

%I is orig_image, J is resized imge, 
cs_image = reshape(x, orig_height, orig_width, orig_depth);
disp('size of cs_imag =');
disp(size(cs_image));
 
figure

subplot(1,2,1), imshow(uint8(cs_image))

subplot(1,2,2), imshow(uint8(J), map1);


%imshow(uint8(B));





