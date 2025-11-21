function voicedSpeech = voicedSpeechDetect(userFile, windowSize, overlapSize)
% voicedSpeech takes an audio file and detects what parts are voiced
% speech.

% Set short time energy threshold to distinguish between silence and speech

energyThreshold = 20;
[segments,~] = buffer(userFile,windowSize, overlapSize,"nodelay");
ste = sum((segments.*hamming(windowSize,"periodic")).^2,1);
isSpeech = ste(:) > energyThreshold;

% Set zero crossing rate to distinguish between voiced and unvoiced speech
zcrThreshold = 0.02;
zcr = zerocrossrate(userFile, WindowLength=windowSize, OverlapLength=overlapSize);
isVoiced = zcr < zcrThreshold;

voicedSpeech = isSpeech & isVoiced;
end
