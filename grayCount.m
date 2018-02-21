function [ N ] = grayCount(row, col, L, imgray)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
N=0;
for i=1:L:row                               % Counts across rows by L
    for j=1:L:col                           % Counts across columns by L
        % Searches for a non white pixel in the grid.
        if imgray(i,j)~=0                   % White in matlab for grayscale
                                            % is equal to 3.
                                            % If the pixel is not white,
                                            % then increments the number of
                                            % nonwhite boxes by 1. Then
                                            % moves onto the next grid.
            N = N+1;
            break
        end
    end
end


