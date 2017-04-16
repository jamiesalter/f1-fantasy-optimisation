function [ everyOption ] = bruteforce( PointsObj, DriversObj, ConstructorsObj, maxcost, currentTeamDrivers, currentTeamConstructors )
%BRUTEFORCE Analyses every possible combination
%   Detailed explanation goes here

disp(' - Creating table of valid options'); tic;

% Create a table of all possible options
% How many options are there?
noDrivers = DriversObj.getdrivernumber();
noConstructors = noDrivers/2;
noTeamDrivers = 6;
noTeamConstructors = 2;

noOptions = nchoosek(noDrivers,noTeamDrivers) * nchoosek(noConstructors,noTeamConstructors) * noTeamDrivers;

% Columns are:
% Drivers #1-6, Constructors #1-2, Captain, Points, Cost, Error flag,
% Number of substitutions
everyOption = zeros(noOptions, noTeamDrivers + noTeamConstructors + 5);

% Generate every driver combination
driverComb = nchoosek(1:noDrivers,noTeamDrivers);

% Generate every constructor combination
constructorComb = nchoosek(1:noConstructors,noTeamConstructors);

% Pull costs and constructors for each driver out of the class to make multi-threading
% quicker
driverCost = DriversObj.getcost([1:noDrivers]');
constructorCost = ConstructorsObj.getcost([1:noConstructors]');
driverConstructor = DriversObj.getconstructorid([1:noDrivers]');

for i=1:size(driverComb,1)*size(constructorComb,1)
    
    % Get the driver option number and constructor option number from
    % the index
    iDriver = ceil(i/size(constructorComb,1)); % round up
    iConstructor = mod(i,size(constructorComb,1)); % take the remainder
    iConstructor(~iConstructor) = size(constructorComb,1); % Replace a 0 from the mod function with the proper number
    
    % Calculate the cost of this option
    cost = sum(driverCost(driverComb(iDriver,:))) + sum(constructorCost(constructorComb(iConstructor,:)));
    
    % Check there's only maximum 2 drivers/constructors from a single team
    % in the selection
    % We get all the constructor IDs together in a vector, sort them and
    % check for differences.  If we find 2 zeros in a row, we have 3
    % constructors that are the same.
    if ~isempty(strfind(diff(sortrows([driverConstructor(driverComb(iDriver,:)); constructorComb(iConstructor,:)']))', [0 0]))
        errorFlag = 1;
    else
        errorFlag = 0;
    end

    % Create an index for which rows we're replacing in the output matrix
    % We do this to include the captains
    j = ((i-1)*noTeamDrivers)+1 : i*noTeamDrivers;
    
    % Create the matrix block
    everyOption(j,:) = repmat([driverComb(iDriver,:) constructorComb(iConstructor,:) 0 0 cost errorFlag 0], noTeamDrivers, 1);
    
    % Insert the team captains
    everyOption(j,noTeamDrivers+noTeamConstructors+1) = driverComb(iDriver,:)';
    
end
time = toc;
fprintf(' - Valid options generated in %0.4fs\n',time);

disp(' - Calculating points for every valid option'); tic;

% Loop through every option using multi-threaded for loop
parfor i=1:size(everyOption,1)
    x = everyOption(i,:); % Slice out the part of the matrix we need for this operation
    
    drivers = x(1:noTeamDrivers)';
    captain = x(noTeamDrivers+noTeamConstructors+1);
    constructors = x(noTeamDrivers+1:noTeamDrivers+noTeamConstructors)';
    cost = x(noTeamDrivers+noTeamConstructors+3);
    errorFlag = x(noTeamDrivers+noTeamConstructors+4);

    if cost < maxcost && errorFlag == 0
        % Check how many substitutions are required from the current team
        % choice
        % !!SETDIFF IS VERY SLOW!!  See https://kr.mathworks.com/matlabcentral/answers/53796-speed-up-intersect-setdiff-functions
        driverSub = numel(setdiff(drivers, currentTeamDrivers));
        constructorSub = numel(setdiff(constructors, currentTeamConstructors));
        substitutions = driverSub + constructorSub;
        
        everyOption(i,:) = [x(1:noTeamDrivers+noTeamConstructors+1) PointsObj.team(drivers, captain, constructors) cost errorFlag substitutions];
    else
        everyOption(i,:) = [x(1:noTeamDrivers+noTeamConstructors+1) 0 cost 1 0];
    end

end

time = toc;
fprintf(' - Points calculated in %0.4fs\n',time);

% Delete the parallel pool once we're done with it
%delete(gcp('nocreate'))

% Remove rows that are invalid
everyOption(everyOption(:,12)==1,:) = [];

% Sort the output
everyOption = flipud(sortrows(everyOption, 10));

end

