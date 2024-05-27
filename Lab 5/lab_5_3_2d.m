clear
clc

wc = 0.44 * pi; % Center frequency parameter
desired_attenuation = 10; % Desired attenuation factor
L = 1; % Starting value of filter length to initialize
step_size = pi / 100000; % Define step size for frequency response calculation
while true
    L = L + 1;
    % Generate impulse response of the bandpass filter
    n = 0:L-1; % Index
    h = (2 / L) * cos(wc * n); % Impulse Response of the bandpass filter
    w = 0:step_size:pi; % Angular frequency variable
    H = freqz(h, 1, w); % Frequency response of filter

    % Find frequencies where |H(e^jw)| <= 0.1 * H_max
    H_mag = abs(H);
    H_max = max(H_mag);
    
    passband_indices_low = find(H_mag <= 0.1 * H_max & w <= 0.3 * pi, 1, 'last');
    passband_indices_high = find(H_mag <= 0.1 * H_max & w >= 0.7 * pi, 1, 'first');
    
    % Check if the indices meet the condition
    if ~isempty(passband_indices_low) && ~isempty(passband_indices_high)
        if w(passband_indices_low) <= 0.3 * pi && w(passband_indices_high) >= 0.7 * pi
            break;
        end
    end
end

% Displaying Smallest Value
disp(['Smallest value of L: ', num2str(L)]);