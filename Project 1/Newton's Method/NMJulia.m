% Forms the julia set using Newton's method iteration for finding roots to
% z^n+c=0

% define the degree of polynomai
n=3;
%Define the c
c=1;

%Define the functions and fixed points.
f = @(z) z.^n + c;
fprime = @(z) n*z^(n-1);
fixpt1 = 1;
fixpt2 = exp(pi/3*1i);
fixpt3= exp(-pi/3*1i);

colormap([1 0 0;0 1 0; 0 0 1; 1 1 1]); %color map with n+1 colors
M= zeros(401,401);
for j=1:401                  % Try initial values with imaginary parts between
  y = -2+ (j-1)*.01;        %   -2 and 2
  for i=1:401                % and with real parts between
    x = -2 + (i-1)*.01;     %   -2 and 2.
    z = x + 1i*y;             
    zk = z;

    iflag1 = 0;     % iflag1, iflag2, and iflag3 count the number of iterations
    iflag2 = 0;     %   when a root is within 1.e-6 of fixed points 1,2,3;
    iflag3 = 0;
    kcount = 0;      % kount is the total number of iterations.
 
    
    while kcount < 100 && abs(zk) < 100 && iflag1 < 5 && iflag2 < 5 && iflag3<5
      kcount = kcount+1;
      zk = zk-f(zk)/fprime(zk);           % This is the newtons method iteration.
      
      err1 = abs(zk-fixpt1);  % Test for convergence to fixpt1.
      if err1 < 1.e-6
         iflag1 = iflag1 + 1;
      else
         iflag1 = 0;
      end
      
      err2 = abs(zk-fixpt2);  % Test for convergence to fixpt2.
      if err2 < 1.e-6
        iflag2 = iflag2 + 1;
      else
        iflag2 = 0;
      end
      
      err3 = abs(zk-fixpt3);  % Test for convergence to fixpt3.
      if err3 < 1.e-6
        iflag3 = iflag3 + 1;
      else
        iflag3 = 0;
      end
    end
    
    if abs(zk)>100 %if the orbit diverged, fill in the color map
        M(j,i)=4; % to the color white
                       
   elseif iflag1>=5
        M(j,i)=1; %if converge to fxp 1, color red
    elseif iflag2>=5
        M(j,i)=2; %if converge to fxp 2, color green
    elseif iflag3 >=5
        M(j,i)=3; %if converge to fxp3, color blue
    end
  end
end
    
image([-2 2],[-2 2],M),  % This plots the results.
title('Newton Method \phi(z)=z^n+c=0, c=1 and n=3')
	xlabel('X')
	ylabel('Y')
pbaspect([1 1 1]); %keeps the x/y ratio even
axis xy % prevents inverted xy axis

