function julia(varargin)
%GUI for viewing the simple quadratic Julia set using inverse iteration.
%
%   Use mouse and click to select new constant.
%   Click and drag to dynamically change the constant.
%
%   Plots an approximation to the Julia set boundary for the function 
%   P(z) = z^2 + c
%
%   julia (C)
%   julia (C, 'PropertyName', PropertyValue, ...)
%   julia ('PropertyName', PropertyValue, ...)
%
%   julia (C) Uses the complex number C as the initial constant.
%
%   julia (C, 'PropertyName', PropertyValue, ...) Uses the complex number C
%   as the initial constant and the additional parameter-value pairs.
%
%   julia ('PropertyName', PropertyValue, ...) Uses the parameter-value
%   pairs.
%
%   List of properties
%   InitialPoint
%      any complex value       default from uniformly distributed region
%      The constant to use when initiating the image.
%   Width (NO LONGER USED)
%      positive value          default 400
%      Number of datapoints to use width-wise
%   Height (NO LONGER USED)
%      positive value          default 400
%      Number of datapoints to use height-wise
%   XLim
%      2-element vector        default [-2,2]
%      Region boundary on the x-axis
%   YLim
%      2-element vector        default [-2,2]
%      Region boundary on the y-axis
%   NumStartPts
%      positive value          default 1000
%      Number of starting points from which the inverse iteration will be
%      performed
%   Iterations
%      positive value          default 100
%      Number of inverse iterations to perform
%   BGColor
%      1x3 matrix              default [0,0,0]
%      Background color in a RGB vector. RGB components must be between 0
%      and 1.
%   Color
%      1x3 matrix              default [1,0,0]
%      Boundary color in a RGB vector. RGB components must be between 0
%      and 1.
%
%  Known bug: If dragging with left mousekey, then pressing and holding the
%  right mouse key, then unpressing the left key, the program will continue
%  to update the Julia set. The problem is due to SelectionType retaining 
%  only the last button press. Thus, there is no way of knowing which key
%  has been unpressed.
%
%  This version is from October 29, 2010
%  Octover 29, 2010, Width and Height now automatically determined to
%  improve visualization. Also tweaked default values for 'NumStartPts' and
%  'Iterations' to reduce for loop and promote vectorization leading to
%  faster computation.
%  October 28, 2010, first version
%  Written by Christopher Leung
%  christopher.leung@mail.mcgill.ca
%
%  In memory to Benoit Mandelbrot

buttondown = 0;
axesize = [1 1];

% Parse inputs
p = inputParser;
p.addOptional('InitialPoint', rand(1)*2-1 + 1i*(rand(1)*2-1), @isnumeric)
p.addParamValue('Width', 400, @(x)isnumeric(x)&&x>0);
p.addParamValue('Height', 400, @(x)isnumeric(x)&&x>0);
p.addParamValue('XLim', [-2 2], @(x)isnumeric(x)&&numel(x)==2);
p.addParamValue('YLim', [-2 2], @(x)isnumeric(x)&&numel(x)==2);
p.addParamValue('NumStartPts', 1000, @(x)isnumeric(x)&&x>0);
p.addParamValue('Iterations', 100, @(x)isnumeric(x)&&x>0);
p.addParamValue('BGColor', [1 1 1], ...
    @(x)isnumeric(x)&&all(x<=1)&&all(x>=0)&&size(x,1)==1);
p.addParamValue('Color', [1 0 0], ...
    @(x)isnumeric(x)&&all(x<=1)&&all(x>=0)&&size(x,1)==1);
p.parse(varargin{:});

% Shorten the result name
param = p.Results;

% Get the quantization spacing, and preinverse it
xdelta = (param.Width-1)/(param.XLim(2)-param.XLim(1));
ydelta = (param.Width-1)/(param.YLim(2)-param.YLim(1));

% Show initial plot
hfig = figure(1);
hax = axes(...
    'Parent', hfig,...
    'XLim', param.XLim,...
    'YLim', param.YLim,...
    'DataAspectRatio', [1 1 1],...
    'DataAspectRatioMode', 'manual',...
    'Box','off',...
    'Layer','bottom',...
    'TickDir','out',...
    'DataAspectRatio',[1 1 1]);
himage = image(...
    'Parent', hax,...
    'XData', param.XLim,...
    'YData', param.YLim,...
    'Cdata', 1);
colormap([param.BGColor(1:3);param.Color(1:3)]);

% Get axesize for quantization level then draw the Julia set
c = param.InitialPoint;
resizecallback();

% Set callbacks
set(hfig, 'WindowButtonMotionFcn', @mousemovecallback);
set(hfig, 'WindowButtonDownFcn', @mousedowncallback);
set(hfig, 'WindowButtonUpFcn', @mouseupcallback);
set(hfig, 'ResizeFcn', @resizecallback);

    function redrawjulia(c)
    % Redraws the Julia set
        % zall stores every calculated point
        zall = zeros(param.NumStartPts,param.Iterations);
        % Generate the starting points
        z = ...
            (rand(param.NumStartPts,1)*2-1) + ...
            (rand(param.NumStartPts,1)*2-1)*1i;
        
        % Loop a few times to get rid of non-boundary points
        for m = 1:10
            z = sqrt(z-c);
        end
        % Perform inverse iteration
        for m = 1:param.Iterations
            % THE inverse iteration
            z = sqrt(z-c);
            % sqrt of complex number gives two possible answers
            % choose the non-default one 50% of the time
            idx = rand(param.NumStartPts,1)>0.5;
            z(idx) = -z(idx);
            % store the points
            zall(:,m) = z;
        end
        
        % get index of all points within plot boundaries
        idx = (1:param.NumStartPts*param.Iterations);
        idx = idx(real(zall(idx))<=param.XLim(2));
        idx = idx(real(zall(idx))>=param.XLim(1));
        idx = idx(imag(zall(idx))<=param.YLim(2));
        idx = idx(imag(zall(idx))>=param.YLim(1));
        
        % quantize the coordinates
        xdelta = (axesize(1)-1)/(param.XLim(2)-param.XLim(1));
        ydelta = (axesize(2)-1)/(param.YLim(2)-param.YLim(1));
        x = round((real(zall(idx))-param.XLim(1))*xdelta);
        y = round((imag(zall(idx))-param.YLim(1))*ydelta);
        
        % put points into image cdata
        CData = ones(axesize(2),axesize(1));
        CData(y+axesize(2)*x+1) = 2;
        set(himage,'CData',CData);
        
        % display the constant used
        title(hax, sprintf('using c = %f + %f i',real(c),imag(c)));
    end

    function mousemovecallback(obj,evt)
    % Update drawing if user is dragging
        if (buttondown == 1)
            pt = get(gca, 'CurrentPoint');
            c = pt(1,1)+1i*pt(1,2);
            redrawjulia(c);
        end
    end

    function mousedowncallback(obj,evt)
    % Update drawing when user left clicks
        if strcmp(get(gcf,'SelectionType'),'normal')
            buttondown = 1;
            pt = get(gca, 'CurrentPoint');
            c = pt(1,1)+1i*pt(1,2);
            redrawjulia(c);
        end
    end

    function mouseupcallback(obj,evt)
    % Dragging stops when mouse left button is released
        if strcmp(get(gcf,'SelectionType'),'normal')
            buttondown = 0;
        end
    end

    function resizecallback(obj,evt)
    % Update the axesize after a resize
    % This allows to set the number of quantized levels equal to the number
    % of pixels
        % get the size of the axes
        set(gca,'Units','pixel');
        Position = get(gca,'Position');
        axesize = floor(min(Position(3:4)))*[1 1];
        
        % keep aspect ratio
        yxratio = ...
            (param.YLim(2)-param.YLim(1))/(param.XLim(2)-param.XLim(1));
        if axesize(1)*yxratio > axesize(2)
            axesize = floor([axesize(2)/yxratio axesize(2)]);
        else
            axesize = floor([axesize(1) axesize(1)*yxratio]);
        end
        
        % undo unit change
        set(gca,'Units','normalized');
        redrawjulia(c);
    end
end