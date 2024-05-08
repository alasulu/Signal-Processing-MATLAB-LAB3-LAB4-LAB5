clear
clc

n = 0:99; % Time Index
x = 5*cos(0.3*pi*n) + 22*cos(0.44*pi*n - pi/3) + 22*cos(0.7*pi*n - pi/4); % Signal
b = [1, -2*cos(0.44*pi), 1]; % Filter coefficient of y[n]
a = [1]; % Filter coefficient of x[n]
y = filter(b, a, x); % Input signal filtering

% 100 points plotting of input and output signals
subplot(2,1,1);
stem(n, x(1:100), 'b', 'LineWidth', 1.5);
xlabel('n');
ylabel('Amplitude');
title('Input Signal');
grid on;
subplot(2,1,2);
stem(n, y(1:100), 'r', 'LineWidth', 1.5);
xlabel('n');
ylabel('Amplitude');
title('Filtered Output Signal');
grid on;
