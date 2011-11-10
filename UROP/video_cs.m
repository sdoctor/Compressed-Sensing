% Compressed sensing for video

% ALGORITHM: 
% Preprocess: loop through video stills and create difference frames
%              if difference frame greater than some threshold, new
%              keyframe
% Do compressed sensing for each difference frame and also keyframes
% Compare orig sequence to compressed sensing recovered sequence