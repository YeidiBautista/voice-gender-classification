function AudioTest = RecordAudio(SampleRate, BitsPerSample, RecDuration)
% RecordAudio function prompts the user to select from recording devices
% detected, then records at the given sample rate (SampleRate), with given bits per
% sample (BitsPerSample), for given amount of time (RecDuration).

% Detect audio devices and display input devices.
info = audiodevinfo;
numOfinputs = length(info.input);
for i= 1:numOfinputs
    disp(info.input(i));
end

% Prompt user to select recording device
Device = input("Enter the ID of which device you would like to use to record.");

% Record Sample using given characteristics
recObj = audiorecorder(SampleRate, BitsPerSample, 1, Device);

disp('Recording...');
recordblocking(recObj, RecDuration);
disp('Recording complete.');

AudioTest = getaudiodata(recObj);

end