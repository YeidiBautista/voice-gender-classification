function AudioTest = AudioRecorder(SampleRate, BitsPerSample, RecDuration)

info = audiodevinfo;
disp(info);
Device = input("Enter what device you would like to use to record.");

recObj = audiorecorder(SampleRate, BitsPerSample, 1, Device);

disp('Recording...');
recordblocking(recObj, RecDuration);
disp('Recording complete.');

AudioTest = getaudiodata(recObj);

end