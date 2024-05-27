function [b, a] = iir1(order, cutoff, filterLength)
    % IIR1 function to design a first-order IIR filter
    % Inputs:
    %   - order: order of the filter (1 for first-order)
    %   - cutoff: cutoff frequency (normalized frequency)
    %   - filterLength: length of the filter
    % Outputs:
    %   - b: numerator coefficients of the filter
    %   - a: denominator coefficients of the filter
    
    a = [1, -exp(-2*pi*cutoff)];
    b = [1-a(2)];
    
    % Adjust filter length
    b = [b, zeros(1, filterLength - 1)];
    a = [a, zeros(1, filterLength - 1)];
end
