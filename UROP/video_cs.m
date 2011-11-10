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


% MAKE MOVIE 10% OF SIZE!
small_mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight*.1, vidWidth*.1, 3, 'uint8'),...
    'colormap', []);

% Read and resize one frame at a time
for j = 1 : nFrames-1  
    frame = read(reader, j);
    J = imresize(frame, .1);   
    small_mov(j).cdata = J;
end


% Play back the movie once at the video's frame rate.
%disp('now showing original movie');
%movie(hf, mov, 1, reader.FrameRate);

disp('now showing small movie');
movie(hf, small_mov, 1, reader.FrameRate);



%*note* for writing...VideoWriter writes video...

