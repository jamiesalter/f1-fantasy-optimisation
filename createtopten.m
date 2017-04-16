function [ top10 ] = createtopten( DriversObj, ConstructorsObj, everyOption )
%CREATETOPTEN Get top 10 teams
%   Detailed explanation goes here

% Preallocate matricies
drivers = cell(10, 6);
constructors = cell(10, 2);
captain = cell(10,1);
points = zeros(10,1);
cost = zeros(10,1);
errorFlag = zeros(10,1);
substitutions = zeros(10,1);
for i=1:10
    % Fill data
    drivers(i,:) = DriversObj.getname(everyOption(i,1:6)')';
    constructors(i,:) = ConstructorsObj.getname(everyOption(i,7:8)')';
    captain(i) = DriversObj.getname(everyOption(i,9));
    points(i) = everyOption(i,10);
    cost(i) = everyOption(i,11);
    errorFlag(i) = everyOption(i,12);
    substitutions(i) = everyOption(i,13);
end
% Create table
top10 = table(drivers, constructors, captain, points, cost, errorFlag, substitutions);

end

