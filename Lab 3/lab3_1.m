clear
clc
% Definition of Signal and Filter
xx = 256*(rem(0:100, 50) < 10); % Input Signal
aa = 1; % Coefficient of output
bb = [1, -0.9]; % Coefficient of Input
ww = filter(bb, aa, xx); % Filtering
disp(ww); % Displaying

% Plotting
n = 0:75; % Range for Plotting
figure
subplot(2,1,1);
stem(n, xx(n+1), 'b', 'LineWidth', 1.0); % Input signal
title('Input Signal');
xlabel('n');
ylabel('x[n]');
xlim([0, 75]);
subplot(2,1,2);
stem(n, ww(n+1), 'r', 'LineWidth', 1.0); % Output signal
title('Output Signal');
xlabel('n');
ylabel('w[n]');
xlim([0, 75]);
