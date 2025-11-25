% KNN Classification Example using Iris Dataset
% This script:
% 1) Loads the iris dataset
% 2) Splits it into training and test sets
% 3) Trains a KNN classifier
% 4) Evaluates accuracy
% 5) Shows a confusion matrix

clear; clc; close all;

%% 1. Load data
load fisheriris   % meas (150x4), species (150x1 cell array)
X = meas;         % Features: [sepal length, sepal width, petal length, petal width]
Y = species;      % Labels: 'setosa', 'versicolor', 'virginica'

fprintf('Size of X: %d x %d\n', size(X,1), size(X,2));
fprintf('Size of Y: %d x 1\n', length(Y));

%% 2. Train/Test split (70% train, 30% test)
cv = cvpartition(Y, 'HoldOut', 0.3);

Xtrain = X(training(cv), :);
Ytrain = Y(training(cv), :);

Xtest  = X(test(cv), :);
Ytest  = Y(test(cv), :);

fprintf('Training samples: %d\n', size(Xtrain,1));
fprintf('Test samples    : %d\n', size(Xtest,1));

%% 3. Train KNN classifier (k = 5)
k = 5;
Mdl = fitcknn(Xtrain, Ytrain, 'NumNeighbors', k);

%% 4. Predict on test data
Ypred = predict(Mdl, Xtest);

% Compute classification accuracy
accuracy = mean(strcmp(Ypred, Ytest));
fprintf('Test accuracy with k = %d: %.2f%%\n', k, accuracy*100);

%% 5. Confusion matrix
figure;
confusionchart(Ytest, Ypred);
title(sprintf('KNN Confusion Matrix (k = %d)', k));

%% 6. Try different k values
k_values = 1:2:15;
acc_values = zeros(size(k_values));

for i = 1:numel(k_values)
    k_i = k_values(i);
    Mdl_i = fitcknn(Xtrain, Ytrain, 'NumNeighbors', k_i);
    Ypred_i = predict(Mdl_i, Xtest);
    acc_values(i) = mean(strcmp(Ypred_i, Ytest));
end

figure;
plot(k_values, acc_values, '-o', 'LineWidth', 1.5);
xlabel('Number of Neighbors (k)');
ylabel('Test Accuracy');
title('KNN Accuracy vs k');
grid on;

%% 7. Predict class for a new sample (example)
% New flower: [sepal length, sepal width, petal length, petal width]
newSample = [5.1 3.5 1.4 0.2];   % Looks like setosa
predictedLabel = predict(Mdl, newSample);

fprintf('Predicted species for new sample [5.1 3.5 1.4 0.2]: %s\n', predictedLabel{1});