function  filteredAudio = LowPassFilter(audioData, fs, cutoffFreq)
% LowPassFilter Applies a Butterworth Low-Pass Filter to audio data.

% Set filter order. Higher order means sharper filter, but more
% computation.
filterOrder = 6; % 6th-order filter

% Design the Butterworth low-pass filter (IIR Butterworth)
% designfilt creates the digital filter specification.
% 'lowpassiir' specifics and Infinite Impulse Response (IIR) low-pass
% filter
% 'Butterworth is chosen for its flat response in the passband.
d = designfilt('lowpassiir',...
    'FilterOrder',filterOrder,...
    'HalfPowerFrequency', cutoffFreq,...
    'SampleRate', fs);

% Apply the filter
% filter function applies the designed filter to the audio data.
% filtfilt is recommended for audio as it processes the signal
% forward and backward, eliminating phase distortion.
filteredAudio = filtfilt(d, audioData);

% Normalize the output (ensures amplitude stays in [-1, 1]
filteredAudio = filteredAudio / max(abs(filteredAudio));

end