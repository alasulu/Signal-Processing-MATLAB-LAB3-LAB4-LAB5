clear;
clc;

%%%--- Speech signal pre-emphasis operation ---%%%

% Read the input speech signal
[inputSignal, fs] = audioread('man_sound.wav'); 
inputSignal = inputSignal(1:15*fs); % Importing just first 15 seconds of audio signal
preEmphasis = 0.97; % Commonly used pre-emphasis filter coefficient
preEmphasizedSignal = filter([1 -preEmphasis], 1, inputSignal); % Difference equation of pre-emphasis filter: y(n) = x(n) - a * x(n-1)
t = (0:length(inputSignal)-1)/fs; % Time element of the input signal
% Plot the original and pre-emphasized signals for comparison
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
audiowrite('preemp_man.wav', preEmphasizedSignal, fs); % Saving the pre-emphasized signal to the current folder

%%%--- Filter Bank Operations ---%%%

fc = [394, 692, 1064, 1528, 2109, 2834, 3740, 4871]; % Center frequencies
B = [265, 331, 413, 516, 645, 805, 1006, 1257]; % Bandwidths
numChannels = length(fc); % Channel number
% Design filters using IIR bandpass filters
filters = cell(numChannels, 1); % Preallocating a place for IIR bandpass filters
for k = 1:numChannels
    % Calculate cutoff frequencies
    f_low = fc(k) - B(k) / 2; % Low cutoff frequency
    f_high = fc(k) + B(k) / 2; % High cutoff frequency
    f_low_norm = f_low / (fs / 2); % Normalized low cutoff frequency
    f_high_norm = f_high / (fs / 2); % Normalized high cutoff frequency
    % Design the BPF using the Butterworth filter
    [b, a] = butter(4, [f_low_norm, f_high_norm], 'bandpass');
    filters{k} = {b, a};
end
outputSignals = zeros(numChannels, length(preEmphasizedSignal)); % Filter bank applying to the pre-emphasized signal
for k = 1:numChannels
    outputSignals(k, :) = filter(filters{k}{1}, filters{k}{2}, preEmphasizedSignal);
end
% Designing a different LPF for each channel
lpfLength = 128; % Length of the LPF
lpfs = cell(numChannels, 1); % Preallocating the channels
for k = 1:numChannels
    passbandEdge = B(k) / 2 / (fs / 2); % Implementaion of passband limit frequencies and filters (half of the BPF bandwidth)
    [b, a] = butter(4, passbandEdge, 'low');
    lpfs{k} = {b, a};
end

%%%%--- Enveloping Part ---%%%
envelopes = zeros(size(outputSignals)); % Applying the LPF to the magnitude of the BPF outputs
for k = 1:numChannels
    magnitudes = abs(outputSignals(k, :));
    envelopes(k, :) = filter(lpfs{k}{1}, lpfs{k}{2}, magnitudes);
end
% Plotting
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
% Playing the envelope signal of the first channel as an example
soundsc(envelopes(3, :), fs); 

%%%--- (b) DC Notch Filter Design ---%%%
a_values = [0.95, 0.98, 0.99, 0.995];
% Magnitude Responses Figures
figure;
hold on;
for a = a_values
    [h_notch, w] = freqz([1 -1], [1 -a], 1024, fs);
    plot(w, abs(h_notch));
end
title('Frequency Response of DC-notch Filter for different "a" values');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('a = 0.95', 'a = 0.98', 'a = 0.99', 'a = 0.995');
hold off;
% Determine the value of the pole "a" for a notch bandwidth <= 100 Hz
notch_bandwidth = 100 / (fs / 2);
a = 0.99; % Initial guess for "a"
% Function to find the value of "a" such that the notch bandwidth is <= 100 Hz
for a_candidate = 0.95:0.0001:0.9999
    [h_notch, w] = freqz([1 -1], [1 -a_candidate], 1024, fs);
    notch_bandwidth_actual = sum(abs(h_notch) >= 0.9) / length(w) * (fs / 2);
    if notch_bandwidth_actual <= 100
        a = a_candidate;
        break;
    end
end
% Plot frequency response of the chosen DC-notch filter
figure;
[h_notch, w] = freqz([1 -1], [1 -a], 1024, fs);
plot(w, abs(h_notch));
title(['Frequency Response of DC-notch Filter with a = ' num2str(a)]);
xlabel('Frequency (Hz)');
ylabel('Magnitude');

%%%--- (c) Applying the notch filter to the LPF output to remove DC ---%%%
filteredEnvelopes = zeros(size(envelopes));
for k = 1:numChannels
    filteredEnvelopes(k, :) = filter([1 -1], [1 -a], envelopes(k, :));
end
channelToPlot = 1; % Pick one channel
[h_lpf, w_lpf] = freqz(lpfs{channelToPlot}{1}, lpfs{channelToPlot}{2}, 1024, fs); % Butterworth LPF
[h_cascade, w_cascade] = freqz(conv(lpfs{channelToPlot}{1}, [1 -1]), conv(lpfs{channelToPlot}{2}, [1 -a]), 1024, fs); % Cascade system (LPF followed by the DC-notch filter)
% Plotting the frequency responses
figure;
subplot(3,1,1);
plot(w_lpf, abs(h_lpf));
title('Frequency Response of Butterworth LPF');
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
fc = [394, 692, 1064, 1528, 2109, 2834, 3740, 4871]; % Defining carrier frequencies
audioOutput = zeros(1, length(filteredEnvelopes(1, :))); % Audio output playing
% Generating modulated signals and sum them up
for k = 1:numChannels
    t = (0:length(filteredEnvelopes(k, :))-1) / fs; % Generating Carrier signal
    carrier = cos(2*pi*fc(k)*t); % Carrier signal
    modulatedSignal = filteredEnvelopes(k, :) .* carrier; % Modulating the envelope with the carrier
    audioOutput = audioOutput + modulatedSignal; % Summing up the modulated signals
end
% Normalizing the audio output to prevent clipping
audioOutput = audioOutput / max(abs(audioOutput));

% Power Plotting
figure
subplot(2,1,1)
spectrogram(audioOutput, fs);
title('Spectrogram of Audio Output');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
subplot(2,1,2)
pspectrum(audioOutput, fs, 'power');
title('Power Spectrum of Audio Output');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
soundsc(audioOutput, fs); % Sound Output Playing

