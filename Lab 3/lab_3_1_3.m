clear
clc

[inputSignal, fs] = audioread('mecidiye.wav');
inputSignal = inputSignal(1:30*fs);
duration = 30; % Signal time duration
t = 0:1/fs:duration-1/fs; % Time vector
f = 1000; % 1kHz frequency of sine wave
delay = 0.2; % Delay in seconds
P = round(delay * fs); % Time delay to samples
r = 0.9; % Echo strength
x1_delayed = [zeros(1,P), inputSignal(1:end-P)]; % Delay signal generation with shifting the signal by P samples
y = inputSignal + r * x1_delayed; % Final form of signal

% Plotting of Signals
figure
subplot(2,1,1);
plot(t, inputSignal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
xlim([0, 30]); % Limit x-axis to first 0.75 seconds
subplot(2,1,2);
plot(t, y);
title('Echoed Signal');
xlabel('Time (s)');
ylabel('Amplitude');
xlim([0, 30]); % Limit x-axis to first 0.75 seconds
% Play original and delayed signals
soundsc(inputSignal,fs);
pause(2);
soundsc(x1_delayed,fs);