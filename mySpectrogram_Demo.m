%% clear all
clear; clc; clf; close all;

%% Load the sound file 
[x, Fs] = audioread('pianoChroma.wav');  % x = samples, Fs = sample rate
x = x(:);                                  % make sure x is a column

%% Set the frame and hop siz
N   = 1024;    % number of samples in each frame
hop = 512;     % move half the distance of samples for the next frame

%% Use the mySpectrogram() function
[magFrames, phaseFrames, numFrames] = mySpectrogram(x, N, hop);

%% Make time and frequency axes for plotting
f = (0:N/2) * (Fs / N);           % frequency axis in Hz
t = (0:numFrames-1) * (hop / Fs) * 1000; % time axis in milliseconds

%% Plot the magnitude spectrogram (Z = depth)
figure('Name', 'Magnitude Spectrogram');
mesh(f, t, magFrames');      
xlabel('Frequency (Hz)');
ylabel('Time (ms)');
zlabel('Depth (Magnitude)');
title('3D Magnitude Spectrogram ');
%% Plot the phase spectrogram
figure('Name', 'Phase Spectrogram');
waterfall(f, t, phaseFrames');   
xlabel('Frequency (Hz)');
ylabel('Time (ms)');
zlabel('Depth (Phase, radians)');
title('3D Phase Spectrogram');

%% function Hard Coded

function [magFrames, phaseFrames, numFrames] = mySpectrogram(x, N, hop)
% mySpectrogram - makes a basic spectrogram using only positive frequencies
% x is the sound signal
% N is how many samples are in each frame
% hop is how far we move forward each time
% magFrames is the magnitude of each frame (0..N/2)
% phaseFrames is the phase of each frame (0..N/2)
% numFrames is total number of frames

    x = x(:);              % make sure the signal is a column
    L = length(x);         % total number of samples

    % number of full frames that fit (drops extra samples at the end)
    numFrames = fix((L - N) / hop) + 1;   % must come before zeros()

    % indices for positive frequencies (bins 0..N/2)
    keep = 1:(N/2 + 1);                   % MATLAB index 1..N/2+1

    % make empty space for results (rows = N/2+1, cols = numFrames)
    magFrames   = zeros(length(keep), numFrames);
    phaseFrames = zeros(length(keep), numFrames);

    % go through each frame
    for m = 1:numFrames
        s = (m - 1) * hop + 1;            % start sample
        e = s + N - 1;                    % end sample
        frame = x(s:e);                   % take the frame

        % Take the FFT (fast version of the DFT)
        X = fft(frame, N);

        % keep only positive frequencies
        Xpos = X(keep);

        % store the magnitude and phase
        magFrames(:, m)   = abs(Xpos);
        phaseFrames(:, m) = angle(Xpos);
    end
end