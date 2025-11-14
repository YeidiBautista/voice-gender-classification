fsSet = 44000; %set good human record rate from GG
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
    p = pitch(y, fsSet); %pitch
    pMean=median(p);% median P
    pIQR=iqr(p); % IQR P

    mf = mfss(y, fsSet);
    mfMean=median(mf);
    mfSTD=std(mf)




end