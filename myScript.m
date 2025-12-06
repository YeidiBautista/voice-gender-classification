rng(123);
%Part 1: data preparation folder, file, dataset
folder = ["C:\Users\khang\OneDrive\Documents\MATLAB\PROJECT\Data\Male","C:\Users\khang\OneDrive\Documents\MATLAB\PROJECT\Data\Female"];
folderlabel= ["male", "female"];
%part2: set all record as same frequency speed 
fsSet = 16000; % all record need to be consistency
labels =[]; % empty label vector for male and female
features = []; % empty features vector

for k = 1 : length(folder)
    fol = folder(k);
    label = folderlabel(k);
files = dir(fullfile(fol, '*.wav'));
% Load audio files from the folder

for i = 1:length(files)
    fullpath = fullfile(fol, files(i).name); %build full file path to linking record in folder
    [y,Fs]= audioread(fullpath); %audio read file
 
    % Monaunal - Mono audio has only 1 chanel 
    % convert mono for simpler processing, and consistent dataset for all
    % features. 
    if size(y,2) > 1
    y = mean(y,2); %mono function 
    end 

    % Set same sample rate
    % change the sample rate to value above
    % consistency and easier and faster processing to correct feature
    if Fs ~= fsSet
    y=resample(y,fsSet, Fs); 
    Fs = fsSet;
   end
 
%noise cleaning process
lengthNoise = round(0.2 * fsSet);
noisePro = y(1:lengthNoise);
win = hamming(512, 'periodic');
overlap = 256;
fftLen = 512;
%signal and noise
[S, ~, ~] = stft(y, fsSet, 'Window', win, 'OverlapLength', overlap, 'FFTLength', fftLen);
[N, ~, ~] = stft(noisePro, fsSet, 'Window', win, 'OverlapLength', overlap, 'FFTLength', fftLen);
% Noise function
Noise = mean(abs(N), 2);
%Spectral subtraction
Sign = abs(S);
Signcleaner = Sign - Noise;
Signcleaner(Signcleaner < 0) = 0;% want the index for positive value and remove negatives
Signcleaner = Signcleaner .* exp(1j * angle(S));
%final step to clean out noise and keep as y
y = real(istft(Signcleaner, fsSet, 'Window', win, 'OverlapLength', overlap, 'FFTLength', fftLen));

% normalize - finds the loudest point in the audio 
    % same reason of mono, consistency dataset, improve data integrity for feature extraction
    if ~isempty(y) % Normalize the audio signal
    y = y / max(abs(y)); 
    end
    
 %trim silence:
    if length(y)/Fs>1 % use if esle if condition of sample is more than 1s
   threshold = 0.01; % any amplitude lower than 1% consider as silence
   % Trim silence from the audio signal
   trim = find(abs(y)> threshold); % locate position where the audio is louder than silence
   if ~isempty(trim) % if trim is not empty continue to trimming
       y=y(trim(1): trim (end)); % record is keep everything at speech start and end.
   end
   end


%pitch features - fundamental frequency F0
%Pitch is the perceptual property of sounds. A higher frequency of vocal fold vibration results in a higher perceived pitch. 
% Male 85 to 155 Hz, female 165 to 255 Hz
   win = round(fsSet * 0.03);
ov = round(0.015*fsSet);
    p = pitch(y, fsSet,'range',[50 350], 'WindowLength',win,'OverlapLength',ov);
    % calculates fundamental frequency of record
    pMean=median(p,'omitnan');% The average of pitch of record
    % Male 85 to 155 Hz, female 165 to 255 Hz
    pStd=std(p,'omitnan');
    pIQR=iqr(p);
    %The Interquartile Range (IQR) is a statistical measure of the variable in mid 50% of a set of pitch data
% we use IQR to measures the variable the pitch is across the recording

%MFCC features: MFFCC is a timbre of the voice 
% Mel - Frequency Ceptral coefficients
numCoeffs = 13;
    mf = mfcc(y, fsSet,'NumCoeffs',numCoeffs); % function to calculate MFCC
    %  vector contains the values for a small frame of the audio
    mfMean=median(mf,1,'omitnan'); % 1 x numberCoeffs
    % same as pitch, we want a mean of MFCC across all frame as
    % characteristics of voice in the record
    mfSTD=std(mf,1,'omitnan');
    % show the standard or variablity of voice over time

%spectral features include 2 feature
% we want to know the center of mass of the spectrum - centroid 
% Bandwidth as the the range of frequencies 
centroid = spectralCentroid(y,fsSet);
bandwidth =spectralSpread(y, fsSet);
% computes the spectral centroid and bandwidth and the output are vector,
% one value per frame
centroid_mean = mean(centroid);
centroid_std = std(centroid);

bandwidth_mean = mean(bandwidth);
bandwidth_std = std(bandwidth);
rolloff = spectralRolloffPoint(y, fsSet);
rolloff_mean = mean(rolloff);
% basically rolloff is feature measure the frequency below which a specific percentage of the total energy is contained
% all we looking for the average, from the machine can learning to classify

rmsVal = rms(y);
zcr = sum(abs(diff(sign(y))))/length(y);
% This calculates the zero-crossing rate (ZCR)
%Computes the difference between consecutive samples.
%zero crossing happens when the sign changes between samples.


feat = [rmsVal,pMean, pIQR,pStd, mfMean, mfSTD, centroid_mean, centroid_std,bandwidth_std, bandwidth_mean, rolloff_mean, zcr];
features=[features; feat];
labels = [labels; string(label)];
end
end

y =categorical(labels);
train = cvpartition(y, 'Holdout', 0.3);
%train classifier SVM
% Predict using SVM model
for i = 1 : train.NumTestSets
XtrainData = features(training(train,i), :);
YtrainLabels = y(training(train,i));
XtestData = features(test(train,i), :);
YtestLabels = y(test(train,i));
model = fitcsvm(XtrainData, YtrainLabels,'KernelFunction','rbf','Standardize',true,'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',struct('UseParallel', true,'ShowPlots',false),'BoxConstraint',1);
pred = predict(model, XtestData);
accur(i) = mean((pred==YtestLabels));
end

%train classifier KNN
%Try different k values
% Predict using KNN model
k_values = 1:2:77;
acc_values = zeros(length(k_values),1);
for j = 1:length(k_values)
   k_i = k_values(j);
   Mdl_i = fitcknn(XtrainData, YtrainLabels, 'NumNeighbors', k_i,'Standardize',true);
knnPred = predict(Mdl_i, XtestData);
end

% Calculate accuracy for KNN train model
knnAccur = mean(knnPred == YtestLabels); %fomula for accuracy by Mablab
knnAccur = knnAccur* 100; % %% accuracy

%print the result of accuracy %:
fprintf("Training samples : %d\n", length(YtrainLabels));
fprintf("Testing samples : %d\n", length(YtestLabels));
fprintf("The KNN accuracy by k is %.2f%%\n" ,knnAccur);
% accuracy of SVM train model
accur = accur * 100; % % accuracy
fprintf("The SVM Accuracy: %.2f%%\n", accur);
% plot the confusion matrix
figure;
confusionchart(YtestLabels, pred,"RowSummary","row-normalized","ColumnSummary","column-normalized");
title('Gender Classification-Confusion Matrix - SVM');

