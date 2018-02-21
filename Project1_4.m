% PART 4
% FRACTAL DIMENSION

% RETICULAR CELL COUNTING METHOD
% STEP 1
% Convert image to grayscale image
im = imread('discBoundary.jpg');
image(im)
axis image
im = im(1:800,200:1000,3);
bi = (im<200);

imagesc(bi)
colormap gray
axis image

% STEP 2
% Determine dimensions of image
[row,col] = size(bi);

N = zeros(1,3);     % Total number of boxes that contain at least one gray level
                    % intensity surface.
L = [2 3 5];        % Dimension of grids

% STEP 3
% Count number of boxes containing non white entries
N(1,1) = grayCount(row,col,L(1,1),bi);
N(1,2) = grayCount(row,col,L(1,2),bi);
N(1,3) = grayCount(row,col,L(1,3),bi);

% STEP 4
% Use least squares method to determine value of D
Nl = log(N);
Ll = log(L);

numpt = size(N);
xi = 0;
yi = 0;
xy = 0;
x2 = 0;

for i=1:numpt(1,2)
    xi = Nl(1,i)+xi;
    yi = Ll(1,i)+yi;
    xy = Nl(1,i)+Ll(1,i)+xy;
    x2 = Nl(1,i)^2+x2;
end

a1 = (numpt*xy-xi*yi)/(numpt*x2 - xi^2);

D = -a1;


