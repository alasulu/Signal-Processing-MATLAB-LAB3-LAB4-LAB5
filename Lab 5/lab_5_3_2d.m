clear
clc

wc = 0.44*pi; % Center frequency parameter
desired_attenuation = 10; % Desired attenuation factor
L = 5; % Starting value of filter length to initialize
step_size = pi/100000; % Define step size for frequency response calculation
while true
    % Generate impulse response of the bandpass filter
    n = 0:L; % Index
    h = 2/L * cos(wc * n); % Impulse Response of the bandpass filter
    w = 0:step_size:pi; % Angular frequency variable
    H = freqz(h, 1, w); % Frequency response of filter

    % Find frequencies on |H(e^jw)| <= 0.1 * H_max for w <= 0.3*pi
    passband_indices_low = find(abs(H) <= 0.1 * max(abs(H)), 1, 'last');
    % Find frequencies on |H(e^jw)| <= 0.1 * H_max for w >= 0.7*pi
    passband_indices_high = find(abs(H) <= 0.1 * max(abs(H)), 1, 'first');
    if passband_indices_low <= 0.3*pi && passband_indices_high >= 0.7*pi % Desired attenuation verifier 
        break;
    end
    
    L = L + 1; % Filter length increment
end

% Displaying Smallest Value
disp(['Smallest value of L: ', num2str(L)]);