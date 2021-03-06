function Orb_0(const)
% Checks if 0 is in the filled Julia Set for a given \phi(z)=z^2+c
% by computing the orbit of 0.

%Define the c and initial z_0 (for orb(0), use z0=0;
c=const;
z0=0;

%Define the functions and fixed points.
phi = @(z) z^2 + c;
fixpt1 = (1 + sqrt(1-4*c))/2;
fixpt2 = (1 - sqrt(1-4*c))/2;


    iflag1 = 0;     % iflag1 and iflag2 count the number of iterations
    iflag2 = 0;     %   when a root is within 1.e-6 of a fixed point;
    kount = 0;      % kount is the total number of iterations.
    zk=z0;          %calculates the orb(z_0).
    
    while kount < 1000 && abs(zk) < 100 && iflag1 < 5 && iflag2 < 5
      kount = kount+1;
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
    
    if iflag1 >= 5 || iflag2 >= 5    % If orb(0) converges to a root, 
      fprintf('The sequence orb(0) converges to a root; thus, the filled Julia set is connected \n');% 0 is in the filled julia set
    elseif kount >= 1000 %otherwise, if the orbit remained bounded for large iterations
        fprintf('Orb(0) remained bounded for 1000 iterations. We assume the filled Julia set is connected \n'); 
    else
        fprintf('The orb(0) is unbounded, so the filled Julia set is not connected \n');
    end
end
