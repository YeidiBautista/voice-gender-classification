function feat = extractVoiceFeatures(y, Fs, fsSet)
%EXTRACTVOICEFEATURES  Extracts the same features used for training
%   y      : audio signal (column vector)
%   Fs     : original sampling rate
%   fsSet  : target sampling rate used in training (e.g. 16000)
%
%   feat   : 1 x D feature row vector (same as in training)

    % --- MONO ---
    if size(y,2) > 1
        y = mean(y,2);
    end

    % --- RESAMPLE ---
    if Fs ~= fsSet
        y = resample(y, fsSet, Fs);
        Fs = fsSet;
    end

    % --- NOISE REDUCTION (same as training) ---
    noiseLen = round(0.2 * fsSet);
    noiseLen = min(noiseLen, numel(y)); % safety
    noiseProfile = y(1:noiseLen);

    win = hamming(512, 'periodic');
    overlap = 256;
    fftLen = 512;

    [S, ~, ~] = stft(y, fsSet, 'Window', win, 'OverlapLength', overlap, 'FFTLength', fftLen);
    [N, ~, ~] = stft(noiseProfile, fsSet, 'Window', win, 'OverlapLength', overlap, 'FFTLength', fftLen);

    N_mag = mean(abs(N), 2);
    S_mag = abs(S);
    S_clean_mag = S_mag - N_mag;
    S_clean_mag(S_clean_mag < 0) = 0;
    S_clean = S_clean_mag .* exp(1j * angle(S));
    y = real(istft(S_clean, fsSet, 'Window', win, 'OverlapLength', overlap, 'FFTLength', fftLen));

    % --- NORMALIZE ---
    if ~isempty(y) && max(abs(y)) > 0
        y = y / max(abs(y));
    end

    % --- TRIM SILENCE ---
    if numel(y)/Fs >= 1   % only bother if at least 1 second
        threshold = 0.01;
        idx = find(abs(y) > threshold);
        if ~isempty(idx)
            y = y(idx(1):idx(end));
        end
    end

    % --- PITCH FEATURES ---
    winLen = round(fsSet * 0.03);  % 30 ms
    ov = round(0.015 * fsSet);     % 15 ms overlap

    p = pitch(y, fsSet, 'Range', [50 350], ...
              'WindowLength', winLen, 'OverlapLength', ov);

    pMean = median(p, 'omitnan');
    pStd  = std(p, 'omitnan');
    pIQR  = iqr(p);

    % --- MFCC FEATURES ---
    numCoeffs = 13;
    mf = mfcc(y, fsSet, 'NumCoeffs', numCoeffs);

    mfMean = median(mf, 1, 'omitnan');
    mfSTD  = std(mf, 0, 1, 'omitnan'); % std over frames

    % --- SPECTRAL FEATURES ---
    centroid  = spectralCentroid(y, fsSet);
    bandwidth = spectralSpread(y, fsSet);
    rolloff   = spectralRolloffPoint(y, fsSet);

    centroid_mean = mean(centroid);
    centroid_std  = std(centroid);

    bandwidth_mean = mean(bandwidth);
    bandwidth_std  = std(bandwidth);

    rolloff_mean   = mean(rolloff);

    % --- RMS + ZCR ---
    rmsVal = rms(y);
    zcr    = sum(abs(diff(sign(y)))) / numel(y);

    % --- CONCATENATE FEATURES (SAME ORDER AS TRAINING) ---
    feat = [rmsVal, ...
            pMean, pIQR, pStd, ...
            mfMean, mfSTD, ...
            centroid_mean, centroid_std, ...
            bandwidth_std, bandwidth_mean, ...
            rolloff_mean, ...
            zcr];

end
