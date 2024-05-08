clear
clc
% Sampling frequency
fs = 8000;

% Time duration of the signal (in seconds)
duration = 2;

% Time vector
t = 0:1/fs:duration-1/fs;

% Frequency of the sine wave
f = 1000; % 1000 Hz

% Generate the original signal (sine wave)
x1 = sin(2*pi*f*t);

% Time delay in seconds
Td = 0.2;

% Convert time delay to samples
P = round(Td * fs);

% Strength of the echo
r = 0.9;

% Generate the delayed signal
x1_delayed = [zeros(1,P), x1(1:end-P)]; % Shift the signal by P samples

% Add the original signal and the delayed signal with scaling
y = x1 + r * x1_delayed;

% Play the echoed signal
soundsc(y, fs);