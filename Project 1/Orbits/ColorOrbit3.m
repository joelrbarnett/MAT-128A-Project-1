% Checks the orbits of z_0 from the region [-2,2]x[-2,2]
% under phi(z)=z^2+c

%Define the c
c=0.36+0.1*1i;

%Define the functions and fixed points.
phi = @(z) z^2 + c;
fixpt1 = (1 + sqrt(1-4*c))/2;
fixpt2 = (1 - sqrt(1-4*c))/2;

colormap jet;
M= zeros(401,401);
for j=1:401                  % Try initial values with imaginary parts between
  y = -2+ (j-1)*.01;        %   -2 and 2
  for i=1:401                % and with real parts between
    x = -2 + (i-1)*.01;     %   -2 and 2.
    z = x + 1i*y;             
    zk = z;

    iflag1 = 0;     % iflag1 and iflag2 count the number of iterations
    iflag2 = 0;     %   when a root is within 1.e-6 of a fixed point;
    kcount = 0;      % kount is the total number of iterations.
 
    
    while kcount < 1000 && abs(zk) < 100 && iflag1 < 5 && iflag2 < 5
      kcount = kcount+1;
      zk = phi(zk);           % This is the fixed point iteration.
      
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
      
    end
    
    if abs(zk)>100 %if the orbit diverged, fill in the color map
        M(j,i)=kcount+10; %the color for terms that diverged with similar 
                        %kcounts will have similar color
    end
  end
end
    
image([-2 2],[-2 2],M),  % This plots the results.
title('Colored orbits for \phi(z)=z^2+c, c =0.36+0.1i')
	xlabel('X')
	ylabel('Y')
pbaspect([1 1 1]); %keeps the x/y ratio even
axis xy % prevents inverted xy axis

