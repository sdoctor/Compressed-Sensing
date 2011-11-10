% reconstruct from the difference movie and the keyframe

orig_mov_reader = VideoReader('small_mov.avi');
diff_mov_reader = VideoReader('cs_diff.avi');

nFrames = diff_mov_reader.NumberOfFrames;
vidHeight = diff_mov_reader.Height;
vidWidth = diff_mov_reader.Width;

key_frame = read(orig_mov_reader, 1);

%Reconstruct from difference frames
diff_reconstruct(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
    'colormap', []);

diff_reconstruct(1).cdata = key_frame;


%Read in entire diff_mov
diff_mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
    'colormap', []);
% Read one frame at a time.
for k = 2 : nFrames-1
    diff_mov(k).cdata = read(diff_mov_reader, k);
end

%Initialize writer to reconstruct
diff_reconstruct_writer = VideoWriter('cs_reconstruct.avi');
diff_reconstruct_writer.FrameRate = reader.FrameRate;
open(diff_reconstruct_writer);



writeVideo(diff_reconstruct_writer, diff_reconstruct(1).cdata);


for h=2:nFrames-1
    %something is wrong here
    diff_reconstruct(h).cdata = diff_reconstruct(h-1).cdata + diff_mov(h).cdata;
    writeVideo(diff_reconstruct_writer, diff_reconstruct(h).cdata);
end
close(diff_reconstruct_writer);

figure;
imshow(diff_reconstruct(1).cdata);

