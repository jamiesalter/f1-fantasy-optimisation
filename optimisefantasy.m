totalTime = tic;
disp('Initialising odds and classes');
% CREATE ODDS TABLE
fastedLap = [2.642352941, 3.037058824, 11.64705882, 11.64705882, 6.411764706, 7.147058824, 60.64705882, 149.5294118, 70.05882353, 168.6470588, 124.8235294, 85.23529412, 265.7058824, 53.11764706, 706.8823529, 208.6470588, 130.7058824, 186.2941176, 734.3333333, 527.4705882]';
winner = [2.028095238, 2.364285714, 36.0952381, 36.66666667, 8.952380952, 9.238095238, 858.5, 1091.47619, 543.8571429, 1286.714286, 936.7142857, 905.7619048, 2096.238095, 479.5714286, 2881.952381, 1429.571429, 1346.238095, 1103.380952, 2881.952381, 2334.333333]';
pole = [1.627777778, 3.085, 48.27777778, 48.27777778, 10.16666667, 7.222222222, 806.5555556, 1084.333333, 620.4444444, 1417.666667, 931.5555556, 731.5555556, 1834.333333, 277.9444444, 2695.444444, 1584.333333, 1348.222222, 1098.222222, 2824.529412, 2473.222222]';
finishOdds = [1.08, 1.12, 1.11, 1.11, 1.16, 1.11, 1.16, 1.36, 1.2, 1.33, 1.3, 1.2, 1.44, 1.16, 1.4, 1.72, 1.33, 1.61, 1.57, 2.1; ...
1.08, 1.14, 1.13, 1.13, 1.14, 1.1, 1.2, 1.33, 1.14, 1.29, 1.33, 1.17, 1.5, 1.17, 1.4, 1.8, 1.33, 1.67, 1.57, 2.25; ...
1.08, 1.08, 1.11, 1.11, 1.11, 1.08, 1.2, 1.36, 1.2, 1.36, 1.36, 1.2, 1.5, 1.2, 1.44, 1.8, 1.25, 1.8, 1.57, 1.91; ...
1.08, 1.08, 1.12, 1.12, 1.1, 1.1, 1.17, 1.33, 1.17, 1.25, 1.29, 1.17, 1.5, 1.14, 1.29, 1.8, 1.25, 1.67, 1.53, 2; ]';
notFinishOdds = [7, 5.5, 6, 6, 4.5, 6, 4.5, 3, 4.33, 3.25, 3.4, 4.33, 2.62, 4.5, 2.75, 2, 3.25, 2.2, 2.25, 1.66;
7, 5, 5.5, 5.5, 5, 6.5, 4.33, 3.25, 5, 3.5, 3.25, 4.5, 2.5, 4.5, 2.75, 1.91, 3.25, 2.1, 2.25, 1.57; ...
7, 7, 6, 6, 6, 7, 4.33, 3, 4.33, 3, 3, 4.33, 2.5, 4.33, 2.62, 1.91, 3.75, 1.91, 2.25, 1.8; ...
8, 8, 6, 6, 7, 7, 4.5, 3.25, 4.5, 3.75, 3.5, 4.5, 2.5, 5, 3.5, 1.91, 3.75, 2.1, 2.38, 1.73;]';

% Combine the finish and not finish odds
% Calculate the assumped probability of the odds
finishOdds = 1./(finishOdds+1);
notFinishOdds = 1./(notFinishOdds+1);
finishPredicted = 1- notFinishOdds;

% We average the finishing and not finishing odds to get a more accurate
% picture of the actual probability of a finish (removes the bookies profit
% margin from the picture)
finishOdds = (finishOdds + finishPredicted)./2;

% Average across the finishOdds
finishOddsAvg = mean(finishOdds,2);

driverID = (1:size(fastedLap,1))';

odds = [driverID, fastedLap, winner, finishOddsAvg, pole];

% CREATE CLASSES
ConstructorsObj = Constructors();
DriversObj = Drivers(ConstructorsObj);

% CALCULATE POINTS
disp('Calculating points from odds'); pointsTime = tic;
PointsObj = Points(odds, DriversObj);
time = toc(pointsTime);
fprintf('All points calculated in %0.4fs\n',time);

% CREATE CURRENT SELECTION
driverSelectionNames = {'Lewis Hamilton', 'Valtteri Bottas', 'Max Verstappen', 'Kimi Raikkonen', 'Sergio Perez', 'Esteban Ocon'}';
captainName = {'Lewis Hamilton'};
constructorSelectionNames = {'Ferrari', 'McLaren'}';

% Convert selection to IDs
driverSelection = DriversObj.getid(driverSelectionNames);
captain = DriversObj.getid(captainName);
constructorSelection = ConstructorsObj.getid(constructorSelectionNames);

% Calculate points for the team
currentTeamPoints = PointsObj.team(driverSelection, captain, constructorSelection);
fprintf('Current team estimated to achieve %0.2f points\n',currentTeamPoints);

% BRUTE FORCE EVERY POSSIBLE OPTION
disp('Brute forcing every possible team option'); bruteTime = tic;
everyOption = bruteforce(PointsObj, DriversObj, ConstructorsObj, 200, driverSelection, constructorSelection);
time = toc(bruteTime);
fprintf('Brute force completed in %0.4fs\n',time);

% Show the top 10
top10 = createtopten(DriversObj, ConstructorsObj, everyOption);
% createtopten(DriversObj, ConstructorsObj, flipud(sortrows(everyOption(everyOption(:,13)==2,:), 10)));
time = toc(totalTime);
fprintf('Total optimisation completed in %0.4fs\n',time);