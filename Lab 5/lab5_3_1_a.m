clear
clc

wn1 = 0.44 * pi; % First nulling frequency
wn2 = 0.7 * pi; % Second nulling frequency

% Coefficients for the first nulling filter
b1_0 = 1;
b1_1 = -2 * cos(wn1);
b1_2 = 1;

% Coefficients for the second nulling filter
b2_0 = 1;
b2_1 = -2 * cos(wn2);
b2_2 = 1;

% Coefficients Displaying of Filters
disp('Filter 1 Coefficients:');
disp(['b1_0 = ', num2str(b1_0)]);
disp(['b1_1 = ', num2str(b1_1)]);
disp(['b1_2 = ', num2str(b1_2)]);
disp(' ');

disp('Filter 2 Coefficients:');
disp(['b2_0 = ', num2str(b2_0)]);
disp(['b2_1 = ', num2str(b2_1)]);
disp(['b2_2 = ', num2str(b2_2)]);