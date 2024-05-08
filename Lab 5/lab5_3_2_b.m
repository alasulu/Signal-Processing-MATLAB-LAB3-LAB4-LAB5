clear
clc

L_values = [10, 20, 40];  % Filter length parameters
wc = 0.44*pi;              % Center frequency parameter
passband_widths = zeros(1, length(L_values)); % Arrays to store passband widths

% Frequency response for each of the filter lengths
figure;
for i = 1:length(L_values)
    L = L_values(i);
    
    n = 0:L; % Index
    h = 2/L * cos(wc * n); % Impulse Response of the bandpass filter
    w = 0:pi/1000:pi; % Angular frequency variable
    H = freqz(h, 1, w); % Frequency response of filter

    % Find frequencies on |H(e^jw)| >= 0.707 * H_max
    passband_indices = find(abs(H) >= 0.707 * max(abs(H)));
    passband_widths(i) = w(passband_indices(end)) - w(passband_indices(1));
    % Plotting of frequency response
    subplot(length(L_values), 1, i);
    plot(w, abs(H), 'LineWidth', 1.5);
    hold on;
    stem(w(passband_indices), abs(H(passband_indices)), 'r', 'LineWidth', 1.5);
    xlabel('Frequency (rad/sample)');
    ylabel('Magnitude');
    title(['Frequency Response for L = ', num2str(L)]);
    legend('Filter Frequency Response', 'Passband Region');
    grid on;
end

% Displaying results
disp('Passband widths at 0.707 level:');
disp(passband_widths);