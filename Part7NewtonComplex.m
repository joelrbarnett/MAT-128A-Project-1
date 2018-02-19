%
% Newtown's Method for complex plane
% n = 2
% tol sets our tolerance
% z is initial guess

format long
z = 0.5
tol = 10^(-10)
n = 2

while abs(z^n-1) > tol
    z = z - (z.^n - 1)/(2.*z);

end

z

