%% mySpectrogram function

function [magFrames, phaseFrames, numFrames] = mySpectrogram(x, N, hop)
% breaks into sub-frames, FFT per frame, stores pos-freq magnitudes & phases

% column
x = x(:);

% frames (each column is one frame)
xFrames = framesig(x, N, hop);

% number of frames
[~, numFrames] = size(xFrames);

% multi-frame FFT
XFrames = fft(xFrames);

% keep only positive frequencies: rows 1 .. N/2+1
posRows = 1:(N/2 + 1);
Xpos = XFrames(posRows, :);

% magnitudes and phases
magFrames   = abs(Xpos);
phaseFrames = angle(Xpos);
end