# voice-gender-classification
Mini MATLAB Project: Voice Gender Classification

This project introduces students to basic machine learning and signal processing using MATLAB. The goal is to build a classifier that distinguishes between male and female voices based on short audio recordings.
Learning Goals

- Practice audio preprocessing (mono, resample, trim silence)
- Extract acoustic features (pitch, MFCCs, spectral stats)
- Train and evaluate a simple classifier (SVM/KNN/Tree)
- Discuss the limitations and ethics of gender inference from voice data
Data Preparation

Students may record their own audio samples or use a small dataset . Each class (female/male) should have around 50–100 short audio clips, 1–3 seconds each.

Recommended folder structure:
data/female/*.wav
data/male/*.wav
Suggestion:Feature Extraction

Extract the following features for each audio clip:
- Pitch (median, IQR)
- MFCCs (mean, std)
- Spectral features (centroid, bandwidth, roll-off)
- RMS energy and zero-crossing rate (mean, std)
Baseline MATLAB Script

The following script performs data loading, feature extraction, model training, and evaluation.



Evaluation and Deliverables

Deliverables:
- MATLAB script or Live Script (.mlx)
- Confusion matrix and accuracy report
- Short reflection (5–10 sentences) discussing which features helped, common errors, and limitations of gender classification.

-Presentation and the final report.
Ethical Discussion

Students must note that voice does not strictly determine gender identity, and this project is used only for technical demonstration purposes. It should not be applied to real-world personal identification systems.
