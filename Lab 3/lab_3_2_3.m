clear
clc
echart = imread("meerkat.jpeg"); % Image Importing
echart = im2double(rgb2gray(echart)); % Converting Images to grayscale and double

q = 0.9; % Define system parameter
filter_coeffs = [1 -q]; % Creating a FIR high-pass filter

% Apply FIR FILTER different orientations
filtered_image_horizontal = filter(filter_coeffs, 1, echart, [], 2);
filtered_image_vertical = filter(filter_coeffs, 1, filtered_image_horizontal, [], 1);


M_values = [1, 5, 8, 11, 22, 33]; % % Defining deconvolution parameters with length of the filter
r = 0.9; % Decay factor of the deconvolution

for M = M_values
    deconv_filter = r.^(0:M); % Deconvolution filter
    recovered_image = conv2(filtered_image_vertical, deconv_filter, 'full'); % Performing deconvolution
    recovered_image = recovered_image(1:size(echart, 1), 1:size(echart, 2)); % Trimming

    % Other Operations
    recovered_image = recovered_image - min(recovered_image(:));
    recovered_image = recovered_image / max(recovered_image(:));

    % Plotting
    figure
    imshow(recovered_image);
    title(['Recovered Image (M = ', num2str(M), ')']);
end