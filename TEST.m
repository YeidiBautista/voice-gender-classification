fsSet = 44000; %set good human record rate 
label =[]; % label for male and female

%Part 1: data preparation folder, file, dataset
male_folder = 'Data/Male';
female_folder = 'Data/Female';
% Load audio files from the folder
maleFiles = dir(fullfile(male_folder, '/*.wav'));
femaleFiles = dir(fullfile(female_folder, '/*.wav'));

%male voices
for i = 1:length(maleFiles)
    [y,Fs]= audioread(maleFiles); %audio read file
    y = mean(y,2); %mono function by mean
    y = y / max(abs(y)); % Normalize the audio signal
    y=resample(y,fsSet, Fs); % Set same sample rate
    %trimsilent?
    p = pitch(y, fsSet); %pitch calculate by function pitch()
    pMean=median(p);% median P
  

% MFCC is represents a sound's short-term power spectrum as a set of coefficients
    % returns the mel- frequency cepstral coefficients from audio input
    % the function extracts a vector included delta and delta-delta of it 
    % delta and delta-delta is temporal that capture rate change of MFCC
    % use it as example to classification male and female voice. 
    mf = mfcc(y, fsSet);


    mfMean=median(mf);
    mfSTD=std(mf)
    

end