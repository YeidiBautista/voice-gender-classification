clear; clc;

% Load trained model
load("genderModel.mat", "model", "fsSet");

fsRec     = fsSet;  % 16000
bits      = 16;
nChannels = 1;

recObj = audiorecorder(fsRec, bits, nChannels);

disp("Press Enter to start recording, or type 'q' to quit.");

while true
    userInput = input("Command (Enter to record, q to quit): ", 's');
    if strcmpi(userInput, 'q')
        disp("Exiting demo.");
        break;
    end

    recDuration = 3; % seconds
    fprintf("Recording for %.1f seconds... Speak now!\n", recDuration);

    recordblocking(recObj, recDuration);
    y = getaudiodata(recObj);
    
    % Plot waveform for debugging
    audioData = getaudiodata(recObj);
    filename = 'my_recorded_audio.wav';
    audiowrite(filename, audioData, fsRec);
    [audioData, fs] = audioread(filename);
    figure
    timeAudio = linspace(0, (numel(audioData)-1)/fs, numel(audioData));
    audioPlot = plot(timeAudio, audioData);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Audio Signal');
    grid on;

    y = double(y);  % make sure it's double

    % Extract features using the SAME pipeline as in training
    feat = extractVoiceFeatures(y, fsRec, fsSet);

    % Ensure feat is 1 x D
    feat = feat(:)';  % row vector

    % Predict
    predictedLabel = predict(model, feat);

    fprintf("Predicted voice sex: %s\n\n", string(predictedLabel));

  
    if predictedLabel == "male"
        msg = "I think this voice is: MALE";
    else
        msg = "I think this voice is: FEMALE";
    end
    disp(msg);
end
