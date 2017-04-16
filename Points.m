classdef Points
    %POINTS Calculates the points for each driver and constructor based on
    %the odds provided
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        drivers
        constructors
    end
    
    methods
        % Constructor - calculate the point distribution for the drivers
        % and constructors
        function obj = Points(odds, DriversObj)
            
            % We need the Driver Object to move between driver IDs and
            % Constructor IDs
            if nargin ~= 2
                error('An odds matrix and a Drivers object must be provided')
            elseif ~isa(DriversObj,'Drivers')
                error('Second argument must be a Drivers object')
            elseif ~ismatrix(odds)
                error('First argument must be an odds matrix')
            end

            % What points are assigned to each place?
            gridPoints = [20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]';
            winnerPoints = [30, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7]';
            % Constructor points are the same as driver winning points
            %constructorWinnerPoints = [30, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7]';
            
            fastedPoints = zeros(size(winnerPoints,1),1);
            fastedPoints(1) = 10;
            completingFullRacePoints = 15;
            completingHalfRacePoints = 10;
            % Not accounted for:
            % Grid movement +/- 1 point
            
            % Sort the odds
            %fastedLapSorted = sortrows(odds(:,[1,2]), 2);
            %winnerSorted = sortrows(odds(:,[1,3]), 2);
            %finishSorted = sortrows(odds(:,[1,4]), 2);
            %gridSorted = sortrows(odds(:,[1,5]), 2);
            
            disp(' - Calculating WINNING points');
            % Calculate points for winning
            winMatrix = runmontecarlo(size(winnerPoints,1)*10^6, odds(:,3), winnerPoints);
            
            disp(' - Calculating FASTED LAP points');
            % Calculate points for getting fastest lap
            fastedMatrix = runmontecarlo(size(fastedPoints,1)*10^6, odds(:,2), fastedPoints);
            
            disp(' - Calculating FINISH RACE points');
            % Calculate the points for finishing.
            % Multiply the probability of finishing, by the points you get
            finishMatrix = completingFullRacePoints*odds(:,4);
            % Increase the odds of completing a half race relative to a
            % full race
            a = 2; % We divide the inverse odds by this number
            halfFinishOdds = 1-((1-odds(:,4))/a);
            halfFinishMatrix = completingHalfRacePoints*halfFinishOdds;
            
            disp(' - Calculating CONSTRUCTOR points');
            % Convert to constructor points.  This only works because the
            % points for constructors winning are the same for drivers
            constructorMatrix = zeros(size(winMatrix,1)/2,1);
            for i=1:size(winMatrix,1)
                constructor = DriversObj.getconstructorid(i);
                constructorMatrix(constructor) = constructorMatrix(constructor) + winMatrix(i) + fastedMatrix(i) + finishMatrix(i);
            end
            
            disp(' - Calculating GRID POSITION points');
            % Calculate points for positions on the grid
            % There are no constructor points for pole positions
            gridMatrix = runmontecarlo(size(gridPoints,1)*10^6, odds(:,5), gridPoints);
            
            % Save the output in the class variables
            obj.drivers = [gridMatrix winMatrix fastedMatrix finishMatrix halfFinishMatrix];
            obj.constructors = constructorMatrix;
            
        end
        
        % Get points for a given team selection
        function teamPoints = team(obj, driverSelection, captain, constructorSelection)
            if size(driverSelection) ~= [6 1]
                error('You must pick 6 drivers in a column vector')
            elseif size(captain) ~= 1
                error('You must pick one captain only')
            elseif size(constructorSelection) ~= [2 1]
                error('You must pick 2 constructors in a column vector')
            end
            
            % Check captain is in the team
            if isempty(find(driverSelection==captain,1))
                error('Captain not found in your team selection');
            end
            
            % Sum the driver points
            driverPoints = sum(obj.drivers,2);
            
            % Double captain's score
            driverPoints(captain) = driverPoints(captain)*2;
            
            % Get team points for the drivers
            teamDriverPoints = driverPoints(driverSelection);
            
            % Get team points for the constructors
            teamConstructorPoints = obj.constructors(constructorSelection);
            
            % Return the total points
            teamPoints = sum(teamDriverPoints) + sum(teamConstructorPoints);
            
        end
    end
    
end

