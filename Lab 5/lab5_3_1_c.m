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

b1 = [b1_0, b1_1, b1_2]; % First nulling filter coefficients
b2 = [b2_0, b2_1, b2_2];  % Second nulling filter coefficients

% Nulling filter implementation
filtered_x1 = conv(x, b1, 'same');
filtered_x2 = conv(filtered_x1, b2, 'same');

% Plotting the signals [Original & Filtered]
figure;
subplot(3,1,1);
plot(n, x);
xlabel('n');
ylabel('x[n]');
title('Original Signal');
subplot(3,1,2);
plot(n, filtered_x1);
xlabel('n');
ylabel('Filtered Signal 1');
title('Filtered Signal after 1st Nulling Filter');
subplot(3,1,3);
plot(n, filtered_x2);
xlabel('n');
ylabel('Filtered Signal 2');
title('Filtered Signal after 2nd Nulling Filter');