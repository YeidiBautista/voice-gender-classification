function [f0, audioPlot, pitchPlot, voicedpitchPlot] = analyzePitch(userFile)
% analyzePitch takes an audio recording, userFile, and generates the
% fundamental frequency, f0, a plot of the audio sample, audioPlot, and the
% plot of the pitch of voiced speech over time, pitchPlot


% Read the audio file and plot the sample
[audioData, fs] = audioread(userFile);

figure
tiledlayout(3,1)

nexttile()
audioPlot = plot((1:length(audioData))/fs, audioData);
xlabel('Time (s)');
ylabel('Amplitude');
title('Audio Signal');
grid on;

% Set Parameters for short-time audio analysis
windowSize = round(0.03*fs); % Sets a 30ms window of analsyis
overlapSize = round(0.025*fs); % Sets a 25ms overlap between 30ms sample windows

% Calculate the fundamental frequency
f0 = pitch(audioData, fs, WindowLength=windowSize, OverlapLength=overlapSize, Range=[50,300]);
    % Range = [50,300] sets a minimum and maximum Hz value to consider.
    % Male voices typically have min f0 of 85Hz
    % Female voices typically have max f0 of 255Hz

% Generate the pitch plot
nexttile()
time = (1:length(f0)) / fs; % Create a time vector for the pitch plot
pitchPlot = plot(time, f0);
xlabel('Time (s)');
ylabel('Pitch (Hz)');
title('Pitch Over Time');
grid on;

% Generate the pitch plot of only voiced speech
voicedSpeech = voicedSpeechDetect(audioData, windowSize, overlapSize);

f0(~voicedSpeech) = NaN;

nexttile()
voicedpitchPlot = plot(time, f0);
xlabel('Time (s)');
ylabel('Voiced Pitch (Hz)');
title('Voiced Pitch Over Time');
grid on;

end