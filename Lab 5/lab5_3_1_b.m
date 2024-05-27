clear
clc

N = 150; % Length of the Signal
n = 0:N-1; % Time Index
w1 = 0.3 * pi; % Frequency of first sinusoid
w2 = 0.44 * pi; % Frequency of second sinusoid
w3 = 0.7 * pi; % Frequency of third sinusoid
phi1 = 0; % Phase of first sinusoid
phi2 = -pi/3; % Phase of second sinusoid
phi3 = -pi/4; % Phase of third sinusoid
x1 = 5 * cos(w1 * n); % First sinusodial component
x2 = 22 * cos(w2 * n + phi2); % Second sinusodial component
x3 = 22 * cos(w3 * n + phi3); % Third sinusodial component
x = x1 + x2 + x3; % Input Signal Calculation

% Plotting the Input Signal
figure;
stem(n, x);
xlabel('n');
ylabel('x[n]');
title('Input Signal x[n]');