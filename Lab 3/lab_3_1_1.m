clear
clc

% Part a & b
bb = [1 -0.9]; % Filter coefficient
xx = 256*(rem(0:100,50)<10); % Length of 10 pulse
first = 1; 
last = 75;
nn = first:last;

subplot(2,1,1);
ww = filter(bb, 1, xx); % Apply FIR filter using filter function
stem(nn, ww(nn), 'filled');
xlabel('time index n');
ylabel('input x[n]');

M = 22;
r = 0.9;
l = 0:M;
second_filter_coeff = r.^l;
yy = filter(second_filter_coeff, 1, ww); % Apply second FIR filter
subplot(2,1,2);
stem(nn, yy(nn), 'filled', '-.');
xlabel('time index n');
ylabel('reconstructed output y[n]');
figure
% Part c
bb = [1 -0.9]; % Filter coefficient
xx = 256*(rem(0:100,50)<10); % Length of 10 pulse
first = 1; 
last = 50;
nn = first:last;

subplot(3,1,1);
ww = filter(bb, 1, xx); % Apply FIR filter using filter function
stem(nn, xx(nn), 'filled');
xlabel('time index n');
ylabel('input x[n]');

M = 22;
r = 0.9;
l = 0:M;
second_filter_coeff = r.^l;
yy = filter(second_filter_coeff, 1, ww); % Apply second FIR filter
subplot(3,1,2);
stem(nn, yy(nn), 'filled', '-.');
xlabel('time index n');
ylabel('output y[n]');

err = xx(nn) - yy(nn); % Calculate the error
subplot(3,1,3);
stem(nn, err, 'filled', '--');
xlabel('time index n');
ylabel('error between y[n] & x[n]');
disp('Max error: ');
disp(max(err)); % Display the maximum error
