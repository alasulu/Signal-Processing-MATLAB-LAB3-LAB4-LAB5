clear
clc

L = 10; % Filter length parameter
wc = 0.44*pi; % Center frequency parameter
n = 0:L; % Index
h = 2/L * cos(wc * n); % Impulse response of bandpass filter
w = 0:pi/100:pi; % Angular frequency variable
H = freqz(h, 1, w); % Frequency response of filter

% Gain at interest interval
w_interest = [0.3*pi, wc, 0.7*pi]; % Interest interval
gain_interest = abs(interp1(w, H, w_interest)); % Gain interest value

% Result Displaying & Plotting
disp('Gain at frequencies of interest:');
disp(['w = 0.3*pi: ', num2str(gain_interest(1))]);
disp(['w = 0.44*pi: ', num2str(gain_interest(2))]);
disp(['w = 0.7*pi: ', num2str(gain_interest(3))]);
figure;
plot(w, abs(H));
hold on;
stem(w_interest, gain_interest, 'r', 'LineWidth', 1.5);
xlabel('Frequency (rad/sample)');
ylabel('Magnitude');
title('Frequency Response of Bandpass Filter');
legend('Filter Frequency Response', 'Frequencies of Interest');
grid on;