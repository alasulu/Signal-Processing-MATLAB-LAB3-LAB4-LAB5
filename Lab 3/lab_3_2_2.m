clear
clc
%% Convolution of Image
echart = imread("meerkat.jpeg"); % Image Importing
echart = im2double(rgb2gray(echart)); % Converting Images to grayscale and double

q = 0.9; % Define system parameter
filter_coeffs = [1 -q]; % Creating a FIR high-pass filter

% Apply FIR FILTER different orientations
filtered_image_horizontal = filter(filter_coeffs, 1, echart, [], 2);
filtered_image_vertical = filter(filter_coeffs, 1, filtered_image_horizontal, [], 1);

% Other Operations
ech90 = filtered_image_vertical;
ech90 = ech90 - min(ech90(:));
ech90 = ech90 / max(ech90(:));

imshow(ech90); % Plotting the output
%% Deconv
q = 0.9; % Define system parameter
filter_coeffs = [1 -q]; % Creating a FIR high-pass filter


% Apply FIR FILTER different orientations
filtered_image_horizontal = filter(filter_coeffs, 1, echart, [], 2);
filtered_image_vertical = filter(filter_coeffs, 1, filtered_image_horizontal, [], 1);

M = 22; % Length of the deconvolution filter
r = 0.9; % Decay factor of the deconvolution

% Generating and performing of deconvolution filter
deconv_filter = r.^(0:M);
recovered_image = conv2(filtered_image_vertical, deconv_filter, 'full');

% Other Operations
recovered_image = recovered_image(1:size(echart, 1), 1:size(echart, 2));
recovered_image = recovered_image - min(recovered_image(:));
recovered_image = recovered_image / max(recovered_image(:));

% Display the recovered image
figure
imshow(recovered_image);