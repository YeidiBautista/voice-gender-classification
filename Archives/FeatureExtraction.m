
clear; clc; close all;

%% 1. Load dataset
load fisheriris
X = meas;        % Original features: 4 (sepal length, sepal width, petal length, petal width)
Y = species;     % Labels

fprintf("Original Feature Matrix Size: %d x %d\n", size(X));

%% 2. Manual Feature Extraction (Statistical Features)
% Extract simple features: mean, variance, min, max for each sample
feat_mean = mean(X, 2);
feat_var  = var(X, 0, 2);
feat_min  = min(X, [], 2);
feat_max  = max(X, [], 2);

% Combine extracted features into new feature matrix
X_features = [feat_mean, feat_var, feat_min, feat_max];

fprintf("Extracted Features Matrix Size: %d x %d\n", size(X_features));

%% Visualize Two Extracted Features
figure;
gscatter(X_features(:,1), X_features(:,2), Y);
xlabel('Mean of Features');
ylabel('Variance of Features');
title('Feature Extraction: Mean vs Variance');
grid on;

%% 3. PCA Feature Extraction (Dimensionality Reduction)
% Standardize data before PCA
X_std = zscore(X);

% Compute PCA
[coeff, score, latent, tsquared, explained] = pca(X_std);

fprintf("Variance Explained by PC1: %.2f%%\n", explained(1));
fprintf("Variance Explained by PC2: %.2f%%\n", explained(2));

% Keep only the first 2 principal components
X_pca = score(:,1:2);

%% 4. Visualize PCA Features
figure;
gscatter(X_pca(:,1), X_pca(:,2), Y, 'rgb', 'osd');
xlabel('PC1');
ylabel('PC2');
title('PCA Feature Extraction (First 2 Components)');
grid on;

%% 5. Use Extracted Features with a Model (Optional)
% Example: Train KNN using PCA features
Mdl = fitcknn(X_pca, Y, 'NumNeighbors', 5);
pred = predict(Mdl, X_pca);
acc = mean(strcmp(pred, Y));

fprintf("Training Accuracy using PCA Features: %.2f%%\n", acc*100);
