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

% Creating a linearly spaced vector for frequency
w = linspace(0, 2 * pi, 1000);  % Adjust the number of points as needed

% Calculating the frequency response of the first and second FIR Nulling Filters
H1 = b1(1) + b1(2) * exp(-1i * w) + b1(3) * exp(-2i * w);
H2 = b2(1) + b2(2) * exp(-1i * w) + b2(3) * exp(-2i * w);

% Multiplying the frequency responses of the two filters
H = H1 .* H2;

% Implementing the inverse Fourier transform to get the impulse response
y = ifft(H);

% Plotting the real part of the impulse response
figure;
plot(n(5:40), real(y(5:40)));  % Use real() to plot the real part if needed
xlabel('n');
ylabel('y[n]');
title('Output Signal (Mathematical Formula)');
grid on;
% Plotting the first 40 points of the output signal
figure;
plot(n(1:40), filtered_x2(1:40));
xlabel('n');
ylabel('y[n]');
title('Output Signal (First 40 Points)');
grid on;
