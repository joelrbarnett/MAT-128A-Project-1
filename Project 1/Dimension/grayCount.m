function [ N ] = grayCount(row, col, L, imgray)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
N=0;
for i=1:L:row                               % Counts across rows by L
    for j=1:L:col                           % Counts across columns by L
        % Searches for a non white pixel in the grid.
        if (i+L < row) && (j+L<col)
        for k=0:L                           % Counts from row i to i+L
            for m=0:L                       % Counts from frow j to j+L
                if imgray(i+k,j+m)==1       % White in matlab for grayscale
                                            % is equal to 3.
                                            % If the pixel is not white,
                                            % then increments the number of
                                            % nonwhite boxes by 1. Then
                                            % moves onto the next grid.
                    N = N+1;
                    k=L+1;                  % The break term exits the for
                                            % m=0:L loop. Setting k=L+1
                                            % exits the for k=0:L loop
                                            % forcing it to move onto the
                                            % next loop.
                    break
                else
                    N=N;
                end
            end
        end
        end
    end
end



