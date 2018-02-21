% PART 4
% FRACTAL DIMENSION

% 
% STEP 1
% Convert image to grayscale image
im = imgread('fractal.jpg');
imgray = rgb2gray(im);

% STEP 2
% Determine dimensions of image
[row,col] = size(imgray);

N = zeros(1,3);     % Total number of boxes that contain at least one gray level
                    % intensity surface.
L = [1,2,5];        % Dimension of grids

% STEP 3
% Count number of boxes containing non white entries
N(1,1) = grayCount(row,col,L(1,1),imgray);
N(1,2) = grayCount(row,col,L(1,2),imgray);
N(1,3) = grayCount(row,col,L(1,3),imgray);

% STEP 4
% Use least squares method to determine value of D
Nl(1,1) = log10(N(1,1));
Nl(1,2) = log10(N(1,2));
Nl(1,3) = log10(N(1,3));
Ll(1,2,3) = log([1,2,5]);

numpt = size(N)
xi = 0;
yi = 0;
xy = 0;
x2 = 0;

for i=1:numpt
    xi = L(1,i)+xi;
    yi = N(1,i)+yi;
    xy = L(1,i)+L(1,i);
    x2 = L(1,i)^2+x2;
end

a1 = (numpt*xy-xi*yi)/(numpt*x2 - xi^2);

D = -a1;



