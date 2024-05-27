% Clear command window and workspace
clear;
clc;

% Pre-emphasis filter for speech signal
fs = 44100;
duration = 2;

% Generate the time vector
t = (0:1/fs:duration-1/fs);

% Generate the input sine wave signal with frequency 394 Hz
inputSignal = sin(2*pi*394*t);

% Define the pre-emphasis filter coefficient
preEmphasis = 0.97; % Commonly used value

% Apply the pre-emphasis filter using the difference equation
% y(n) = x(n) - a * x(n-1)
preEmphasizedSignal = filter([1 -preEmphasis], 1, inputSignal);

% Plot the original and pre-emphasized signals for comparison
t = (0:length(inputSignal)-1)/fs;

figure;
subplot(2,1,1);
plot(t, inputSignal);
title('Original Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, preEmphasizedSignal);
title('Pre-emphasized Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Save the pre-emphasized signal to a new audio file
audiowrite('perfect_sinusoid_debugging.wav', preEmphasizedSignal, fs);

% Define center frequencies and bandwidths
fc = [394, 692, 1064, 1528, 2109, 2834, 3740, 4871]; % Center frequencies
B = [265, 331, 413, 516, 645, 805, 1006, 1257]; % Bandwidths

% Number of channels
numChannels = length(fc);

% Filter length (choose an appropriate length, must be the same for all filters)
L = 512;

% Sampling frequency
Fs = 44100;

% Preallocate array for filter coefficients
filters = zeros(numChannels, L);

% Design filters using Hamming-sinc method
for k = 1:numChannels
    % Calculate cutoff frequencies
    f_low = fc(k) - B(k) / 2;
    f_high = fc(k) + B(k) / 2;
    
    % Normalized cutoff frequencies
    f_low_norm = f_low / (Fs / 2);
    f_high_norm = f_high / (Fs / 2);
    
    % Design the BPF using the Hamming-sinc method
    filters(k, :) = fir1(L-1, [f_low_norm, f_high_norm]);
end

% Apply the filter bank to the pre-emphasized signal
outputSignals = zeros(numChannels, length(preEmphasizedSignal) + L - 1);
for k = 1:numChannels
    outputSignals(k, :) = conv(preEmphasizedSignal, filters(k, :));
end

% Design a different LPF for each channel
lpfLength = 128; % Length of the LPF
lpfs = zeros(numChannels, lpfLength);

for k = 1:numChannels
    % Passband edge frequency (half of the BPF bandwidth)
    passbandEdge = B(k) / 2 / (Fs / 2);
    lpfs(k, :) = fir1(lpfLength-1, passbandEdge);
end

% Apply the LPF to the magnitude of the BPF outputs
envelopes = zeros(size(outputSignals));
for k = 1:numChannels
    magnitudes = abs(outputSignals(k, :));
    envelopes(k, :) = conv(magnitudes, lpfs(k, :), 'same'); % Use 'same' to keep the output length same as input
end

% Plot the original signal, pre-emphasized signal, and the envelope of one channel
t = (0:length(inputSignal)-1)/fs;
figure;
subplot(3,1,1);
plot(t, inputSignal);
title('Original Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, preEmphasizedSignal);
title('Pre-emphasized Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
t_envelope = (0:length(envelopes(1, :))-1)/fs;
plot(t_envelope, envelopes(1, :));
title('Envelope of BPF Output for Channel 1');
xlabel('Time (s)');
ylabel('Amplitude');

% Play the envelope signal of the first channel as an example
soundsc(envelopes(3, :), fs); % You can select the which envelope output would you want to play

% (b) Design the DC-notch filter
a_values = [0.95, 0.98, 0.99, 0.995];

% Plot four magnitude responses in the same figure
figure;
hold on;
for a = a_values
    [h_notch, w] = freqz([1 -1], [1 -a], 1024, Fs);
    plot(w, abs(h_notch));
end
title('Frequency Response of DC-notch Filter for different "a" values');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('a = 0.95', 'a = 0.98', 'a = 0.99', 'a = 0.995');
hold off;

% Determine the value of the pole "a" for a notch bandwidth <= 100 Hz
notch_bandwidth = 100 / (Fs / 2);
a = 0.99; % Initial guess for "a"

% Function to find the value of "a" such that the notch bandwidth is <= 100 Hz
for a_candidate = 0.95:0.0001:0.9999
    [h_notch, w] = freqz([1 -1], [1 -a_candidate], 1024, Fs);
    notch_bandwidth_actual = sum(abs(h_notch) >= 0.9) / length(w) * (Fs / 2);
    if notch_bandwidth_actual <= 100
        a = a_candidate;
        break;
    end
end

% Plot frequency response of the chosen DC-notch filter
figure;
[h_notch, w] = freqz([1 -1], [1 -a], 1024, Fs);
plot(w, abs(h_notch));
title(['Frequency Response of DC-notch Filter with a = ' num2str(a)]);
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% (c) Apply the notch filter to the LPF output to remove DC component
filteredEnvelopes = zeros(size(envelopes));
for k = 1:numChannels
    filteredEnvelopes(k, :) = filter([1 -1], [1 -a], envelopes(k, :));
end

% Pick one channel and plot three frequency responses: the Hamming-sinc LPF, the DC-notch filter, and the cascade system
channelToPlot = 1;

% Hamming-sinc LPF
[h_lpf, w_lpf] = freqz(lpfs(channelToPlot, :), 1, 1024, Fs);

% Cascade system (LPF followed by the DC-notch filter)
[h_cascade, w_cascade] = freqz(conv(lpfs(channelToPlot, :), [1 -1]), [1 -a], 1024, Fs);

% Plot the frequency responses
figure;
subplot(3,1,1);
plot(w_lpf, abs(h_lpf));
title('Frequency Response of Hamming-sinc LPF');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(3,1,2);
plot(w, abs(h_notch));
title(['Frequency Response of DC-notch Filter with a = ' num2str(a)]);
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(3,1,3);
plot(w_cascade, abs(h_cascade));
title('Frequency Response of Cascade System (LPF followed by DC-notch Filter)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Define carrier frequencies
fc = [394, 692, 1064, 1528, 2109, 2834, 3740, 4871]; % Center frequencies

% Initialize audio output
audioOutput = zeros(1, length(envelopes(1, :)));

% Generate modulated signals and sum them up
for k = 1:numChannels
    % Generate carrier signal
    t = (0:length(envelopes(k, :))-1) / fs;
    carrier = cos(2*pi*fc(k)*t); % Carrier signal
    
    % Modulate the envelope with the carrier
    modulatedSignal = envelopes(k, :) .* carrier;
    
    % Sum up the modulated signals
    audioOutput = audioOutput + modulatedSignal;
end

% Normalize the audio output to prevent clipping
audioOutput = audioOutput / max(abs(audioOutput));
figure
subplot(2,1,1)
spectrogram(audioOutput,fs)
title('Spectrogram of Audio Output');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
subplot(2,1,2)
pspectrum(audioOutput,fs,'power')
title('Power Spectrum of Audio Output');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
-

% Play the audio
soundsc(audioOutput, fs);