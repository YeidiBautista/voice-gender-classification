disp('Testing...');

audioTest = RecordAudio(44100, 16, 5);
fs = 44100;

% Filter the audio (LPF)
cutoff = 8000;
audioFiltered = LowPassFilter(audioTest, fs, cutoff);

% Play back the recorded audio for testing
sound(audioFiltered, fs);

filename = 'my_recorded_audio.wav';

audiowrite(filename, audioFiltered, fs);


% Analyze the recorded audio
[f0, audioPlot, pitchPlot, voicedpitchPlot] = analyzePitch(filename);

