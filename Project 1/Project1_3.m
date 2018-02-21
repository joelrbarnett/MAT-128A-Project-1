c = 0.36 + 0.1i;                %Don't need inline, all we need is the value of c
zklist = [];                    %We need an empty set to hold the imageinery points 
                                %so MATLAB can plot z_k+1
                                
for i=1:201 
    y = -1 + (i-1)*.01;         %I changed the iteration from i to k so MATLAB doesn't
    for k=1:201                 %get confused on my imaginery variable "1i"
        x = -1 + (k-1)*.01;     %set z_0 "zk" as an imaginery number x+1.i*y
        zk = x+1i*y;            %We don't need fix points, so I took out flag1 and flag2
        iteration = 0;              
        

        while iteration < 100 && abs(zk) < 2 %I took out flag1 and 2 because we don't them in loop
            iteration = iteration+1;
            phi = zk-c;
            

            x = real(phi);        %defined x and y as real and imaginery
            y = imag(phi);
            r = sqrt((x^2+y^2));
            theta = atan2(y,x); %I used atan2 because that gets the if else statement when
                                %theta is less than 0
            

            zk = sqrt(r)*(cos(theta/2)+1i*sin(theta/2));
            

            ran_num = randi(100,1,1); %defined a random number since phi has a random chance
            m = 2;
            if mod(ran_num,m) == 1;   %of being a negative or positive value then zk takes on that
                zk = -zk;       %value
            else
                zk = zk;
            end
        end    
          zklist= [zklist,zk] ;  %vector to hold all the points collected from iteration
        end
       

    end
    

plot(zklist,'.')
axis xy