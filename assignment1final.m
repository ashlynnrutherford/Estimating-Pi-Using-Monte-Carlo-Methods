% MATLAB Project 1 - Estimating pi Using Monte Carlo Methods

%Part 1: For Loop
% Number of random points for the first estimation
pointsCount = 500;  % You can modify this value

% Start the timer
startTime = tic;

% Initialize variables
insideCount = 0;  % Points inside the quarter circle
xVals = rand(pointsCount, 1);  % Random x-coordinates
yVals = rand(pointsCount, 1);  % Random y-coordinates
circleEstimates = zeros(pointsCount, 1);  % Array to store estimates

% For loop to estimate Pi
for idx = 1:pointsCount
    % Check if point is inside the quarter circle
    if xVals(idx)^2 + yVals(idx)^2 <= 1
        insideCount = insideCount + 1;
    end
    
    % Estimate Pi
    circleEstimates(idx) = 4 * insideCount / idx;
end

% Stop the timer
totalTime = toc(startTime);

% Plot the estimated value as the number of points increases
figure(1);  % Create figure for estimates
plot(1:pointsCount, circleEstimates, 'r');  % Change color to red
xlabel('Points Count');
ylabel('Estimated Value');
title('Estimation of Pi vs Points Count');
legend('Pi Estimate');
drawnow;  % Force rendering

% Compute the deviation from the mean estimate
meanEstimate = mean(circleEstimates);
estimateDeviation = abs(circleEstimates - meanEstimate);

% Plot the deviation from the average estimate
figure(2);  % Create figure for deviations
plot(1:pointsCount, estimateDeviation, 'g');  % Change color to green
xlabel('Points Count');
ylabel('Deviation from Mean Estimate');
title('Deviation of Pi Estimate');
drawnow;  % Force rendering

% Display the total time taken
fprintf('Time for %d points: %f seconds\n', pointsCount, totalTime);

% Initialize a vector to store computation times
computationTimes = zeros(pointsCount, 1);

% For loop to estimate Pi and measure computation time
for idx = 1:pointsCount
    % Start timer for this iteration
    iterStartTime = tic;
    
    % Check if point is inside the quarter circle
    if xVals(idx)^2 + yVals(idx)^2 <= 1
        insideCount = insideCount + 1;
    end
    
    % Estimate Pi
    circleEstimates(idx) = 4 * insideCount / idx;
    
    % Stop the timer for this iteration and store the time
    computationTimes(idx) = toc(iterStartTime);
end

% Plot the computational cost vs points count
plot(1:pointsCount, cumsum(computationTimes), 'b');  % Cumulative time
xlabel('Points Count');
ylabel('Cumulative Time (seconds)');
title('Computational Cost vs Points Count');
legend('Computational Cost');
drawnow;

%Part 2: While loop
% Initialize tolerance levels for significant figures
precision2Digits = 0.01;   % For 2 digits of precision
precision3Digits = 0.001;  % For 3 digits of precision

% Initialize variables for the while loop
pointLimit = 1000;         % Starting number of points
insidePoints = 0;          % Points inside the circle
xVals = rand(pointLimit, 1); % Random x-coordinates
yVals = rand(pointLimit, 1); % Random y-coordinates
lastEstimate = 0;          % Previous estimate

% Initialize counters and flags for precision
iterationsFor2Digits = 0;
iterationsFor3Digits = 0;
precisionsMet = [false, false];  % Precision flags

% While loop to estimate the circle constant
while ~all(precisionsMet)
    % Count points inside the circle
    insidePoints = sum(xVals.^2 + yVals.^2 <= 1); 
    currentEstimate = 4 * insidePoints / pointLimit;  % Current estimate
    
    % Calculate deviation from the previous estimate
    currentDeviation = abs(currentEstimate - lastEstimate);
    
    % Check for 2-digit precision
    if ~precisionsMet(1) && currentDeviation < precision2Digits
        precisionsMet(1) = true;
        iterationsFor2Digits = pointLimit;
        fprintf('2-digit estimate: %.2f\n', currentEstimate);
    end
    
    % Check for 3-digit precision
    if ~precisionsMet(2) && currentDeviation < precision3Digits
        precisionsMet(2) = true;
        iterationsFor3Digits = pointLimit;
        fprintf('3-digit estimate: %.3f\n', currentEstimate);
    end
    
    % Update the last estimate and increase the number of points
    lastEstimate = currentEstimate;
    pointLimit = pointLimit + 1000;
    xVals = rand(pointLimit, 1);
    yVals = rand(pointLimit, 1);
end

% Display the number of points needed for each precision level
fprintf('Points to reach 2 digits: %d\n', iterationsFor2Digits);
fprintf('Points to reach 3 digits: %d\n', iterationsFor3Digits);

computeConstant(3);  % Call the function to estimate with 3-digit precision

% Function to estimate Pi with a user-defined precision
function circleEstimate = computeConstant(userPrecision)
    % Set default precision if not provided
    if nargin < 1
        userPrecision = 3; % Default is 3-digit precision
    end

    % Set tolerance and format based on precision
    switch userPrecision
        case 2
            tolerance = 0.1;
            formatSpec = '%.2f'; % 2-digit format
        case 3
            tolerance = 0.01;
            formatSpec = '%.3f'; % 3-digit format
    end

    % Initialize variables for the loop
    maxPoints = 1000;
    inCircleCount = 0;
    xCoord = rand(maxPoints, 1);
    yCoord = rand(maxPoints, 1);
    prevEstimate = 0;

    % While loop until required precision is reached
    while true
        % Count points inside the circle
        inCircleCount = sum(xCoord.^2 + yCoord.^2 <= 1);
        currentEstimate = 4 * inCircleCount / maxPoints;
        
        % Check if the precision is achieved
        if abs(currentEstimate - prevEstimate) < tolerance
            % Display the final estimate
            fprintf('Estimate with %d digits: %s\n', userPrecision, sprintf(formatSpec, currentEstimate));
            % Plot the random points
            displayPoints(xCoord, yCoord, currentEstimate, sprintf('%d Digits Precision', userPrecision), formatSpec);
            break;
        end
        
        % Update the previous estimate and increase points
        prevEstimate = currentEstimate;
        maxPoints = maxPoints + 1000;
        xCoord = rand(maxPoints, 1);
        yCoord = rand(maxPoints, 1);
    end

    % Return the final estimate
    circleEstimate = currentEstimate;
end

% Function to plot points inside and outside the circle
function displayPoints(xCoord, yCoord, estValue, precisionLabel, formatSpec)
    figure(3);  % Create figure for points
    hold on;
    axis equal;
    
    % Title with estimated value and precision
    title(sprintf('Monte Carlo -Pi: %s (%s)', sprintf(formatSpec, estValue), precisionLabel), 'FontSize', 14);
    xlabel('X');
    ylabel('Y');
    
    % Plot points: blue for inside the circle, orange for outside
    pointsInside = xCoord.^2 + yCoord.^2 <= 1;
    plot(xCoord(pointsInside), yCoord(pointsInside), 'b.');
    plot(xCoord(~pointsInside), yCoord(~pointsInside), 'm.');  % Change to magenta for outside points
    
    hold off;
    drawnow;  % Render plot immediately
end