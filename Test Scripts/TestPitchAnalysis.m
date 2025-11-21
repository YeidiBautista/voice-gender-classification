disp('Testing...');

audioTest = RecordAudio(44100, 16, 5);

% Play back the recorded audio for testing
sound(audioTest, 44100);

[f0, audioPlot, pitchPlot, voicedpitchPlot] = analyzePitch(audioTest);

% Display the fundamental frequency and plot the results
fprintf('Fundamental Frequency: %.2f Hz\n', f0);

figure;
subplot(2,1,1); plot(audioPlot); title('Audio Signal');
subplot(2,1,2); plot(pitchPlot); title('Pitch Contour');
subplot(2,1,3); plot(voicedpitchPlot); title('Voiced Pitch Contour');