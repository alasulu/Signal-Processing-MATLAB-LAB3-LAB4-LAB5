clear
clc

wn1 = 0.44 * pi; % First nulling frequency
wn2 = 0.7 * pi; % Second nulling frequency

% Coefficients for the first nulling filter
b1_0 = 1;
b1_1 = -2 * cos(wn1);
b1_2 = 1;

% Coefficients for the second nulling filter
b2_0 = 1;
b2_1 = -2 * cos(wn2);
b2_2 = 1;

% Waveform Properties
N = 150; % Signal length
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

% Nulling filter implementations
filtered_x1 = conv(x, [b1_0, b1_1, b1_2], 'same');
filtered_x2 = conv(filtered_x1, [b2_0, b2_1, b2_2], 'same');

% Define the mathematical equation for the output signal
% For n >= 5, y[n] = x[n] - 2 * cos(wn1) * x[n-1] + x[n-2] - 2 * cos(wn2) * y[n-1] + y[n-2]
y_mathematical = zeros(1, N);
y_mathematical(1:4) = filtered_x2(1:4); % Initial values
for i = 5:N
    y_mathematical(i) = filtered_x2(i) - 2 * cos(wn1) * filtered_x2(i-1) + filtered_x2(i-2) ...
                         - 2 * cos(wn2) * y_mathematical(i-1) + y_mathematical(i-2);
end

% Plot both the mathematical formula and FIR filter output over the range 5 <= n <= 40
range = 5:40;
figure;
plot(range, filtered_x2(range), 'o-', 'DisplayName', 'FIR Filter Output');
hold on;
plot(range, y_mathematical(range), 'x-', 'DisplayName', 'Mathematical Formula');
xlabel('n');
ylabel('Output Signal');
title('Comparison of FIR Filter Output and Mathematical Formula');
legend;
grid on;