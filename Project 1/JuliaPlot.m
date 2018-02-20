function juliaPlot(f,x,y,cmap)
% Copyright 2016 The MathWorks, Inc.

n = 2000;
nx = linspace(x(1),x(2),n);
ny = linspace(y(1),y(2),n);
[xx,yy] = meshgrid(nx,ny);
z = xx + 1i*yy;

for k = 1:25
    z = f(z);
end

% Zero-out divergent values
z = exp(-abs(z));

% Plot the Julia set
imagesc(z)
axis equal
axis on
if nargin <4
    cm = colormap('cool');
    cm(1,:) = [1 1 1];
    colormap(cm)
else
    colormap(cmap)
end