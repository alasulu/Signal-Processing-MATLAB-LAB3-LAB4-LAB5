clear
clc

b = [1, -2*cos(0.44*pi), 1]; % Filter coefficient of y[n]
a = [1];  % Filter coefficient of x[n]
w = linspace(0, pi, 1000);  % Frequency range from 0 to pi
H = freqz(b, a, w); % Frequency response

% Plot frequency response
plot(w, abs(H), 'LineWidth', 1.5);
xlabel('Frequency (rad/sample)');
ylabel('Magnitude');
title('Frequency Response of the Filter');
grid on;