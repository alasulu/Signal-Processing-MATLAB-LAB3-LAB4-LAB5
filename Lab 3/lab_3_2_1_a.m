% Define the parameters of the system
q = 0:9;
r = 0:9;
M = 22;

% Define the filters
FIR1 = filter([1 1], [1], q);
FIR2 = filter([1 1], [1], r);

% Cascade the filters
Y = filter(FIR2, [1], filter(FIR1, [1], ones(1, M)));

% Plot the impulse response of the overall cascaded system
plot(0:M-1, Y)
xlabel('Time (samples)')
ylabel('Amplitude')
title('Impulse Response of Cascaded System')