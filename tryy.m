% bg = imread('..\data\dgd\Min-SAIVT-DGD-rgb-raw\sub0001\bg\0001.jpg');
% fg = imread('..\data\dgd\Min-SAIVT-DGD-rgb-raw\sub0001\nw01\0001.jpg');

clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;

backgroundImage = imread('..\data\dgd\Min-SAIVT-DGD-rgb-raw\sub0001\bg\0001.jpg');
% Display the image.
subplot(3, 3, 1);
imshow(backgroundImage, []);
axis on;
title('Background Image', 'FontSize', fontSize, 'Interpreter', 'None');
% Get the dimensions of the image.  
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorChannels] = size(backgroundImage);
if numberOfColorChannels > 1
	% It's not really gray scale like we expected - it's color.
	% Convert it to gray scale.
	backgroundImage = rgb2gray(backgroundImage); 
end

% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 

originalImage = imread('..\data\dgd\Min-SAIVT-DGD-rgb-raw\sub0001\nw01\0001.jpg');
% Display the image.
subplot(3, 3, 2);
imshow(originalImage, []);
axis on;
title('Original Image', 'FontSize', fontSize, 'Interpreter', 'None');
% Get the dimensions of the image.  
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorChannels] = size(originalImage);
if numberOfColorChannels > 1
	% It's not really gray scale like we expected - it's color.
	% Convert it to gray scale.
	grayImage = rgb2gray(originalImage); 
else
	grayImage = originalImage;
end

% Subtract the images
diffImage = abs(double(grayImage) - double(backgroundImage));
% Display the image.
subplot(3, 3, 3);
imshow(diffImage, []);
axis on;
title('Difference Image', 'FontSize', fontSize, 'Interpreter', 'None');

% Let's compute and display the histogram.
[pixelCount, grayLevels] = hist(diffImage(:), 100);
subplot(3, 3, 4); 
bar(grayLevels, pixelCount); % Plot it as a bar chart.
grid on;
title('Histogram of original image', 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Gray Level', 'FontSize', fontSize);
ylabel('Pixel Count', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.

% Threshold the image.
binaryImage = diffImage >= 8;
% Display the image.
subplot(3, 3, 5);
imshow(binaryImage, []);
title('Binary Image', 'FontSize', fontSize, 'Interpreter', 'None');

% Take largest blob
binaryImage = bwareafilt(binaryImage, 1);
% Fill holes.
mask = imfill(binaryImage, 'holes');
% % Get convex hull
% binaryImage = bwconvhull(binaryImage);
% Display the image.
subplot(3, 3, 6);
imshow(mask, []);
title('Largest blob', 'FontSize', fontSize, 'Interpreter', 'None');

% Mask the image
% Mask the image using bsxfun() function
maskedRgbImage = bsxfun(@times, originalImage, cast(mask, 'like', originalImage));
% Display the image.
subplot(3, 3, 7);
imshow(maskedRgbImage, []);
title('Masked Image', 'FontSize', fontSize, 'Interpreter', 'None');
