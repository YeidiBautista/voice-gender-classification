disp('Testing...');

audioTest = RecordAudio(44100, 16, 5);

% Play back the recorded audio for testing
sound(audioTest, 44100);

plot(audioTest);