clear
clc

b = [1, -0.9]; % FIR filter coefficients 
n = 0:100; % Time index
w = sin(0.1*pi*n); % Define w[n] of sinusoidal signal
x = filter(b, 1, w); % Implementation and output of the FIR filter
r = 9; % r parameter
M = 22; % m parameter

% y[n] of output signal computation
y = zeros(size(w));
for idx = 1:length(w)
    sum_term = 0;
    for l = 0:M
        if (idx-l) >= 1
            sum_term = sum_term + (r^l) * x(idx-l);
        end
    end
    y(idx) = sum_term;
end

% Plotting
figure;
subplot(3,1,1);
stem(n, w);
title('Input Signal w[n]');
xlabel('n');
ylabel('Amplitude');

subplot(3,1,2);
stem(n, y);
title('Output Signal y[n]');
xlabel('n');
ylabel('Amplitude');

e = x - y; % Error signal e[n] computation

% Plotting on the requested range
subplot(3,1,3);
stem(n(1:50), e(1:50));
title('Error Signal e[n]');
xlabel('n');
ylabel('Amplitude');

% 3.1.2 Worst-Case Filter
e = x - y; % Error signal e[n] computation for worst-case filter

% Finding the maximum absolute error on the requested range
worst_case_error = max(abs(e(1:50)));
disp(['Worst-case error in the range 0 <= n < 50: ', num2str(worst_case_error)]);