function [ expectedPoints ] = calcpoints( driverSelection, captain, constructorSelection, odds, DriversObj )
%CALC_POINTS
%   Takes a proposed team and betting odds and returns the expected number
%   of points based on these rules: http://fantasy.udt.co.za/f1/page/game_info.html

% Check captain is in the team
if isempty(find(driverSelection==captain,1))
    error('Captain not found in your team selection');
end

% Sort the odds matrices
fastedLapSorted = sortrows(odds, 2);
winnerSorted = sortrows(odds, 3);
finishSorted = sortrows(odds, 4);
poleSorted = sortrows(odds, 5);
constructorWinnerSorted = DriversObj.getconstructorid(winnerSorted(:,1));

% Create the points matricies
polePoints = [20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]';
finishPoints = [30, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7]';
constructorFinishPoints = [30, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7]';

% DRIVER
driverPoints = zeros(numel(driverSelection),1);

for i=1:numel(driverSelection)
    currentDriver = driverSelection(i);
    
    % QUALIFICATION POINTS
    a = poleSorted==currentDriver;
    gridPosition = find(a(:,1),1);
    driverPoints(i) = polePoints(gridPosition);
    
    % WINNING POINTS
    a = winnerSorted==currentDriver;
    finishingPosition = find(a(:,1),1);
    driverPoints(i) = finishPoints(finishingPosition);
end

% Double the captain's points
driverPoints(find(driverSelection==captain,1)) = driverPoints(find(driverSelection==captain,1))*2;

% CONSTRUCTOR
constructorPoints = zeros(numel(constructorSelection),1);

for i=1:numel(constructorSelection)
    currentConstructor = constructorSelection(i);
    
    % WINNING POINTS
    a = constructorWinnerSorted==currentConstructor;
    finishingPosition = find(a(:,1));
    constructorPoints(i) = sum(finishPoints(finishingPosition));
end

expectedPoints = [driverPoints; constructorPoints];

end

