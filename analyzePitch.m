function [f0, audioPlot, pitchPlot] = analyzePitch(userFile)
% analyzePitch takes an audio recording, userFile, and generates the
% fundamental frequency, f0, a plot of the audio sample, audioPlot, and the
% plot of the pitch of voiced speech over time, pitchPlot


% Read the audio file and plot the sample
[audioData, fs] = audioread(userFile);

audioPlot = plot((1:length(audioData))/fs, audioData);
xlabel('Time (s)');
ylabel('Amplitude');
title('Audio Signal');
grid on;

% Calculate the fundamental frequency using autocorrelation method
f0 = pitch(audioData, fs);

% Generate the pitch plot
time = (1:length(f0)) / fs; % Create a time vector for the pitch plot
pitchPlot = plot(time, f0);
xlabel('Time (s)');
ylabel('Fundamental Frequency (Hz)');
title('Pitch Over Time');
grid on;

end