function [f0, audioPlot, pitchPlot, voicedpitchPlot] = analyzePitch(userFile)
% analyzePitch takes an audio recording, userFile, and generates the
% fundamental frequency, f0, a plot of the audio sample, audioPlot, and the
% plot of the pitch of voiced speech over time, pitchPlot
% Read the audio file and plot the sample

% Extract audio data from given file, prepare figure window
[audioData, fs] = audioread(userFile);
figure
tiledlayout(3,1)

% Plot audio waveform over time vector
nexttile()
timeAudio = linspace(0, (numel(audioData)-1)/fs, numel(audioData));
audioPlot = plot(timeAudio, audioData);
xlabel('Time (s)');
ylabel('Amplitude');
title('Audio Signal');
grid on;


% Set Parameters for short-time audio analysis
windowSize = round(0.03*fs); % Sets a 30ms window of analsyis
overlapSize = round(0.025*fs); % Sets a 25ms overlap between 30ms sample windows


% Calculate the fundamental frequency
f0 = pitch(audioData, fs, WindowLength=windowSize, OverlapLength=overlapSize, Range=[50,300]);

% Generate the pitch plot
nexttile()
timePitch = linspace(0, (numel(audioData)-1)/fs, numel(f0)) ; % Create a time vector for the pitch plot
pitchPlot = plot(timePitch, f0);
xlabel('Time (s)');
ylabel('Pitch (Hz)');
title('Pitch Over Time');
grid on;

% Detect and generate the pitch plot of only voiced speech
voicedSpeech = voicedSpeechDetect(audioData, windowSize, overlapSize);

f0_voiced = f0;  % Creates copy of f0, for modification
f0_voiced(~voicedSpeech) = NaN;
nexttile()

% Plot the modified copy against adjusted time vector
voicedpitchPlot = plot(timePitch, f0_voiced);
xlabel('Time (s)');
ylabel('Voiced Pitch (Hz)');
title('Voiced Pitch Over Time');
grid on;
end