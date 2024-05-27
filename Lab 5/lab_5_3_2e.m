clear
clc

% Define time index
n = 0:99;

% Define input signal (sum of three sinusoids)
x = 5*cos(0.3*pi*n) + 22*cos(0.44*pi*n - pi/3) + 22*cos(0.7*pi*n - pi/4);

% Define desired passband frequencies
fpass = [0.3, 0.44, 0.7]; % Normalized frequencies (0 to 1)

% Define filter order
L = 100; % Adjust the filter length as needed

% Design the bandpass filter using fir1 function
b = fir1(L, fpass, 'bandpass');

% Apply the bandpass filter to the input signal using conv
y_filter_conv = conv(x, b, 'same');

% Apply the bandpass filter to the input signal using fftfilt
y_filter_fftfilt = fftfilt(b, x);

% Plot input and output signals for the fir1 bandpass filter using conv
figure;
subplot(2,2,1);
plot(n, x);
title('Input Signal (Original)');
xlabel('Sample');
ylabel('Amplitude');
subplot(2,2,2);
plot(n, y_filter_conv);
title('Filtered Output Signal (fir1 with conv)');
xlabel('Sample');
ylabel('Amplitude');

% Plot input and output signals for the fir1 bandpass filter using fftfilt
subplot(2,2,3);
plot(n, x);
title('Input Signal (Original)');
xlabel('Sample');
ylabel('Amplitude');
subplot(2,2,4);
plot(n, y_filter_fftfilt);
title('Filtered Output Signal (fir1 with fftfilt)');
xlabel('Sample');
ylabel('Amplitude');
