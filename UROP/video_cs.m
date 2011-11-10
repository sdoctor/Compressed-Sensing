% Compressed sensing for video

% ALGORITHM: 
% Preprocess: loop through video stills and create difference frames
%              if difference frame greater than some threshold, new
%              keyframe
% Do compressed sensing for each difference frame and also keyframes
% Compare orig sequence to compressed sensing recovered sequence

%********************************************************************




% READ VIDEO
reader = VideoReader('small_test.mov');

nFrames = reader.NumberOfFrames;
vidHeight = reader.Height;
vidWidth = reader.Width;
disp('numFrames =');
disp(nFrames);

% Prepare to write video
diff_reconstruct_writer = VideoWriter('diff_reconstruct.avi');
diff_reconstruct_writer.FrameRate = reader.FrameRate;
open(diff_reconstruct_writer);

small_mov_writer = VideoWriter('small_mov.avi');
small_mov_writer.FrameRate = reader.FrameRate;
open(small_mov_writer);

diff_mov_writer = VideoWriter('differences.avi');
diff_mov_writer.FrameRate = reader.FrameRate;
open(diff_mov_writer);

cs_diff_writer = VideoWriter('cs_diff.avi');
cs_diff_writer.FrameRate = reader.FrameRate;
open(cs_diff_writer);

cs_mov_writer = VideoWriter('cs_mov.avi');
cs_mov_writer.FrameRate = reader.FrameRate;
open(cs_mov_writer);




% Preallocate movie structure.
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);

% Read one frame at a time.
for k = 1 : nFrames-1
    mov(k).cdata = read(reader, k);
end

% Size a figure based on the video's width and height.
hf = figure;
set(hf, 'position', [150 150 vidWidth vidHeight])

%disp('now showing original movie');
%movie(hf, mov, 1, reader.FrameRate);


% MAKE MOVIE 10% OF SIZE!
small_mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight*.1, vidWidth*.1, 3, 'uint8'),...
    'colormap', []);

diff_mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight*.1, vidWidth*.1, 3, 'uint8'),...
    'colormap', []);



cs_mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight*.1, vidWidth*.1, 3, 'uint8'),...
    'colormap', []);



% Variables for compressed sensing
m = 1000;
M = rand(m, vidHeight*vidWidth*3*.01); %*Note* should it be a different random per frame?

diff_mov(1).cdata = imresize(read(reader, 1), .1); %initialize keyframe
writeVideo(diff_mov_writer, diff_mov(1).cdata);

% Read and resize one frame at a time
for j = 1 : nFrames-1  
    % Make a smaller movie
    frame = read(reader, j);
    J = imresize(frame, .1);   
    small_mov(j).cdata = J;
    writeVideo(small_mov_writer, small_mov(j).cdata);
    
    % Make Difference Frames movie
    if j > 1
        diff_frame = read(reader, j) - read(reader, j-1);
        diff_mov(j).cdata = imresize(diff_frame, .1); 
        writeVideo(diff_mov_writer, diff_mov(j).cdata);
    end
    
    
end

%disp('now showing small movie');
%movie(hf, small_mov, 1, reader.FrameRate);

disp('now showing diff frame movie');
movie(hf, diff_mov, 1, reader.FrameRate);



cs_diff(1:nFrames) = ...
    struct('cdata', zeros(vidHeight*.1, vidWidth*.1, 3, 'uint8'),...
    'colormap', []);

disp('now performing compressed sensing on the diff frames');
% Compressed sensing on difference frames
for i = 1 : nFrames-1 %testing on first frame - should be nFrames-1
   % Compressed sensing on frames -- to be moved to another function
   B = double(diff_mov(i).cdata);
   disp('size of frame = ');
   disp(size(B));
   I = B(:);
   [s, h] = size(I);
   I = I(1:s/3);
    
   disp('size of image =');
   disp(s);
   disp('cs on frame:');
   disp(i);
    %don't even need the dct stuff because so sparse...
%     coefs = dct2(I);
%     new_coefs = zeros(s, 1);
%     indices = zeros(s,1);
%     for i=1:m
%         new_coefs(i) = coefs(i);
%     end
    M = rand(m, s/3);
%     C = dctmtx(s);
%     y = M*C*new_coefs;
    y = M*I;
    opts = spgSetParms('verbosity', 0);
    t = spg_bp(M, y, opts);
%     x = idct2(t);
    x = [t; t; t]; % concatenate to fake color - hack...
    cs_img = reshape(x, vidHeight*.1, vidWidth*.1, 3);
    cs_diff(i).cdata = uint8(cs_img); 
    writeVideo(cs_diff_writer, cs_diff(i).cdata);
    
    figure
    subplot(1, 2, 1), imshow(diff_mov(i).cdata)
    subplot(1, 2, 2), imshow(cs_diff(i).cdata);
end

%disp('now showing cs movie');
%movie(hf, cs_mov, 1, reader.FrameRate);


%Reconstruct from difference frames
diff_reconstruct(1:nFrames) = ...
    struct('cdata', zeros(vidHeight*.1, vidWidth*.1, 3, 'uint8'),...
    'colormap', []);
diff_reconstruct(1).cdata = diff_mov(1).cdata; %keyframe
writeVideo(diff_reconstruct, diff_reconstruct(1).cdata);

for h=2:nFrames-1
    %something is wrong here
    diff_reconstruct(h).cdata = diff_reconstruct(h-1).cdata + diff_mov(h).cdata;
    writeVideo(diff_reconstruct_writer, diff_reconstruct(h).cdata);
end

disp('now showing diff reconstruct movie');
movie(hf, diff_reconstruct, 1, reader.FrameRate);




% Reconstruct cs_mov from compressed diff frames
%TODO

disp('now showing diff from cs ');
movie(hf, cs_diff, 1, reader.FrameRate);




%close all writers
close(diff_reconstruct_writer);
close(small_mov_Writer);
close(diff_mov_writer);
close(cs_diff_writer);
close(cs_mov_writer);

