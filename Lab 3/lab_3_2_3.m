clear;
clc;

% Load and preprocess the image
echart = imread("meerkat.jpeg"); % Image Importing
echart = im2double(rgb2gray(echart)); % Converting Images to grayscale and double

q = 0.9; % Define system parameter
filter_coeffs = [1 -q]; % Creating a FIR high-pass filter

% Apply FIR filter in horizontal direction
filtered_image_horizontal = filter(filter_coeffs, 1, echart, [], 2);
% Apply FIR filter in vertical direction
filtered_image_vertical = filter(filter_coeffs, 1, filtered_image_horizontal, [], 1);

% Normalize the filtered image
ech90 = filtered_image_vertical;
ech90 = ech90 - min(ech90(:));
ech90 = ech90 / max(ech90(:));

% Display the filtered image
figure;
imshow(ech90);
title('Filtered Image');

% Define deconvolution filter parameters
M_values = [1, 5, 8, 11, 22, 33]; % Lengths of the deconvolution filters
r = 0.9; % Decay factor of the deconvolution

% Process deconvolution and normalization for all M values
recovered_images = cell(1, length(M_values));
for idx = 1:length(M_values)
    M = M_values(idx);
    % Generate the deconvolution filter
    deconv_filter = r.^(0:M);
    
    % Apply the deconvolution filter
    recovered_image = conv2(filtered_image_vertical, deconv_filter, 'full');
    
    % Crop the recovered image to original size
    recovered_image = recovered_image(1:size(echart, 1), 1:size(echart, 2));
    
    % Normalize the recovered image
    recovered_image = recovered_image - min(recovered_image(:));
    recovered_image = recovered_image / max(recovered_image(:));
    
    % Store the recovered image
    recovered_images{idx} = recovered_image;
end

% Define specific M values for impulse response plotting
M_values_impulse = [11, 20, 33];

for idx = 1:length(M_values_impulse)
    M = M_values_impulse(idx);
    % Generate the filter coefficients
    bdiffh = [1, -0.9]; % High-pass filter coefficients
    r = 0.9;
    l = 0:M;
    bb = r.^l; % Second filter coefficients
    
    % Apply the horizontal and vertical filtering
    yy = conv2(echart, bdiffh); % Horizontal filter
    ech90 = conv2(yy, bdiffh); % Vertical filter
    
    % Apply the second filter
    ww = conv2(ech90, bb);
    echo90_secondFilter = conv2(ww, bb);
    
    % Display the second filtered image
    figure;
    imshow(echo90_secondFilter);
    title(['Second Filtered Image (M = ', num2str(M), ')']);
    
    % Calculate and plot the impulse response
    hh = conv(bb, bdiffh);
    nn = 0:(length(hh) - 1);
    figure;
    stem(nn, hh, 'filled');
    xlabel('time index n');
    ylabel('impulse response');
    title(['Impulse Response (M = ', num2str(M), ')']);
end

