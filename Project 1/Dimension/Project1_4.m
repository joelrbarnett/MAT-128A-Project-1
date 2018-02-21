% PART 4
% FRACTAL DIMENSION

% RETICULAR CELL COUNTING METHOD
% STEP 1
% Convert image to grayscale image
im = imread('discBoundary.jpg');
image(im);
axis image;
im = im(1:800,201:1000,3);
bi = (im<200);

imagesc(bi);
colormap gray;
axis image;

% STEP 2
% Determine dimensions of image
[row,col] = size(bi);

N = zeros(1,3);     % Total number of boxes that contain at least one gray level
                    % intensity surface.
L = [3 2 5];        % Dimension of grids

% STEP 3
% Count number of boxes containing non white entries
N(1,1) = grayCount(row,col,L(1,1),bi);
N(1,2) = grayCount(row,col,L(1,2),bi);
N(1,3) = grayCount(row,col,L(1,3),bi);

% STEP 4
% Use least squares method to determine value of D
Nl = log(N);
Ll = log(L);

p = polyfit(log10(L),log10(N),1);
fd=-p(1)


