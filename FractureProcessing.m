fontSize = 20;

% Read in image.
figure(1)
colorImage = imread('cliff_rgb.jpeg');
% colorImage = imread('Camp18Orthomosaic2.png');
subplot(2,3,1);
imshow(colorImage);
axis on;
title('Orthomosaic', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Give a name to the title bar.
set(gcf, 'Name', 'Image Processing', 'NumberTitle', 'Off');

% Convert to grayscale
grayImage = rgb2gray(colorImage);
subplot(2, 3, 2);
imshow(grayImage);
axis on;
title('Grayscale Image', 'FontSize', fontSize);

% % Display the edge detected image.
% % laplaceImage = imread('Camp18Orthomosaic2Laplace.png');
% laplaceImage = imread('cliff_gray_lap_color_erase.jpeg');
% subplot(2, 3, 3);
% imshow(laplaceImage);
% axis on;
% title('Laplacian Edge Detection', 'FontSize', fontSize);

% implement edge detection
laplaceImage=edge(grayImage,"canny",.2);
subplot(2, 3, 3);
imshow(laplaceImage);
axis on;
title('Edge Detection', 'FontSize', fontSize);

% % Compute and display the histogram.
% subplot(2, 3, 4);
% imhist(grayImage);
% ylim([0 350000]);
% grid on;
% ylabel('Intensity');
% xlabel('Grayscale Range')
% xl = get(gca,'XLabel');
% set(xl,'Position',get(xl,'Position') - [0 60000 0])

% Compute and display binary image
% subplot(2, 3, 5);
% binary = imbinarize(grayImage);
% % binary = imbinarize (laplaceImage, 0.15);
% % why not use auto-generated value?
% % potentially we play around with the threshold value and see how the results
% % differ?
% imshow(binary);
% axis on;
% title('Binary Image', 'Fontsize', fontSize);

% Reduce noise
subplot(2, 3, 4);
refined = bwareaopen(laplaceImage,50);
% 10 is currently number of pixels -- <10 means pixels are counted as noise
imshow(refined);
axis on;
title('Noise Reduction', 'Fontsize', fontSize);

% Calculate percent fracture of each square meter of the image
    % why a square meter? is this the best unit of space to use? 
    % will likely be different for more zoomed-in images
% Divide image into a 2m x 2m array of cells
% One meter = ~27 pixels (27.13853142)
% Two meters = ~54 pixels (54.277)
% Matt J (2020). MAT2TILES: divide array into equal-sized sub-arrays
% (https://www.mathworks.com/matlabcentral/fileexchange/35085-mat2tiles-
% divide-array-into-equal-sized-sub-arrays),
% MATLAB Central File Exchange. Retrieved April 9, 2020.

% cells = mat2tiles(refined,[54,54]);
cells = mat2tiles(refined,[54, 54]); % CHANGE (# of pixels in 2m)
% Reshape array to one column
% cells2 = reshape(cells,5829,1);
% cells2 = reshape(cells,5814,1);
cells2 = reshape(cells,[],1);
    % second arg = rows x columns of 'cells' variable
    % [] automatically creates column length
% Initialize array to store fracture percentage
% ratio = zeros(5829,1);
ratio = zeros(length(cells2),1);
% Iterate over whole array
%for i = 1:5829
for i = 1:length(cells2)
    % i must equal the length of the column when units are adjusted
    j = cells2{i,1};
    % Calculate number of white and black pixels
    numWhitePixels = sum(j(:));
    numBlackPixels = sum(~j(:));
    totalPixels = numWhitePixels + numBlackPixels;
    percentWhite = numWhitePixels / totalPixels;
    ratio(i,1) = percentWhite;
end

% Reshape array back to original shape
% ratio2 = reshape(ratio,67,87);
ratio2 = reshape(ratio, height(cells), length(cells)); 

% Convert array to image
fractureDensity = mat2gray(ratio2);
ax5=subplot(2, 3, 5);
imshow(fractureDensity);
colormap(ax5,jet);
colorbar;
title(ax5,'Fracture Density','FontSize', fontSize)
% Enlarge figure to full screen.
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Give a name to the title bar.
%set(gcf, 'Name', 'Fracture Density', 'NumberTitle', 'Off');

% Orientation data
ax6=subplot(2, 3, 6);
cc=bwconncomp(refined);
    % can add another argument to alter the desired connectivity
stats=regionprops('table', cc,'orientation');
orientations = table2array(stats);
histogram(orientations, 180);
xlabel('Angle (degrees)');
ylabel('Number of Fractures');
title(ax6,'Orientation of Fractures','FontSize', fontSize)
% Enlarge figure to full screen.
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Give a name to the title bar.
%set(gcf, 'Name', 'Orientation of Fractures', 'NumberTitle', 'Off');

