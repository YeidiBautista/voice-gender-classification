%% 6. Design a low-pass filter and remove high-frequency noise

[audioData, Fs] = audioread('my_recorded_audio.wav');
x_noisy = audioData;  % Assign the audio data to a variable for filtering
recTime = length(x_noisy) / Fs;  % Calculate the duration of the recorded audio
t = recTime;

Fc = 4000;               % Cutoff frequency (Hz) for speech
Wn = Fc / (Fs/2);        % Normalize to Nyquist frequency

filterOrder = 8;         % Higher order = sharper filter
[b, a] = butter(filterOrder, Wn, 'low');  % Butterworth low-pass filter

% Apply zero-phase filtering to avoid phase distortion
x_filtered = filtfilt(b, a, x_noisy);

fprintf('Playing back FILTERED signal...\n');
soundsc(x_filtered, Fs);
pause(recTime + 1);

%% 7. Plot filtered signal
figure;
plot(t, x_filtered);
xlabel('Time (s)');
ylabel('Amplitude');
title('Filtered Signal (After Noise Reduction)');
grid on;

%% 8. Spectrogram of filtered signal
figure;
spectrogram(x_filtered, 256, 200, 512, Fs, 'yaxis');
title('Spectrogram of Filtered Recording');
colorbar;

audiowrite('voice_filtered.wav', x_filtered, Fs);