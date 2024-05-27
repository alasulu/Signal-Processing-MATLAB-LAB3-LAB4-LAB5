clear;
clc;

% Load and preprocess the image
echart = imread("meerkat.jpeg"); % Image Importing
echart = im2double(rgb2gray(echart)); % Converting Images to grayscale and double

% Define filter parameters
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
M = 22; % Length of the deconvolution filter
r = 0.9; % Decay factor of the deconvolution

% Generate the deconvolution filter
deconv_filter = r.^(0:M);

% Apply the deconvolution filter
recovered_image = conv2(filtered_image_vertical, deconv_filter, 'full');

% Crop the recovered image to original size
recovered_image = recovered_image(1:size(echart, 1), 1:size(echart, 2));

% Normalize the recovered image
recovered_image = recovered_image - min(recovered_image(:));
recovered_image = recovered_image / max(recovered_image(:));

% Display the recovered image
figure;
imshow(recovered_image);
title('Recovered Image');
