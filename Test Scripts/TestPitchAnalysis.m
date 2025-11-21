disp('Testing...');

audioTest = RecordAudio(44100, 16, 5);

% Play back the recorded audio for testing
sound(audioTest, 44100);

filename = 'my_recorded_audio.wav';

audiowrite(filename, audioTest, 44100);

% Analyze the recorded audio
[f0, audioPlot, pitchPlot, voicedpitchPlot] = analyzePitch(filename);

