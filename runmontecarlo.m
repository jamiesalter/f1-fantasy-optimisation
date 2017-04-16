function [ winMatrix ] = runmontecarlo( N, odds, points )
%DOMONTECARLO Run a Monte Carlo analysis of the odds
%   Returns the number of points for each driver
fprintf('    - Running Monte Carlo analysis with %d iterations\n',N); tic;

% Create truncated normal distribution of the odds of each
% driver. The standard deviation is a percentage of the mean. 
% We later turn the odds into finishing positions.

A = 900; % Coefficients for mean to SD formula
B = 1000; % Coefficients for mean to SD formula

oddsRV = zeros(N,size(odds,1));

for i=1:size(odds,1)
    m = odds(i);
    sd = (A*log(m+B) - A*log(0.75+B)+2); % Set the SD based on the log of the mean.  The second terms set the initial SD value at a mean of 0.75 equal to 2.
    oddsRV(:,i) = m + sd.*trandn((zeros(N,1)-m)./sd,inf.*ones(N,1));
end

% Sort the rows
[~, driverPositions] = sort(oddsRV, 2);

winMatrix = zeros(size(driverPositions,2),1);
% For each driver, get their total points
for i=1:size(driverPositions,2)
    winMatrix(i) = sum((driverPositions==i)*points);
end
% Normalise the points by dividing by the number of iterations.
% Kind of taking the average
winMatrix = winMatrix ./ N;

time = toc;
fprintf('    - Monte Carlo finished in %0.4fs\n',time);

end

