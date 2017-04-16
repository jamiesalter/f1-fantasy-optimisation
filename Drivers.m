classdef Drivers
    %DRIVERS Links driver IDs to driver details
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        details
    end
    
    methods
        % Constructor
        function obj = Drivers(constructors)
            if nargin ~= 1
                error('Constructors object must be provided')
            elseif ~isa(constructors,'Constructors')
                error('Argument must be a Constructors object')
            end

            % Populate the drivers table
            name = {'Lewis Hamilton', ...
                'Sebastian Vettel', ...
                'Max Verstappen', ...
                'Daniel Ricciardo', ...
                'Kimi Raikkonen', ...
                'Valtteri Bottas', ...
                'Carlos Sainz Jr', ...
                'Kevin Magnussen', ...
                'Sergio Perez', ...
                'Esteban Ocon', ...
                'Romain Grosjean', ...
                'Nico Hulkenberg', ...
                'Jolyon Palmer', ...
                'Felipe Massa', ...
                'Marcus Ericsson', ...
                'Fernando Alonso', ...
                'Daniil Kvyat', ...
                'Lance Stroll', ...
                'Antonio Giovinazzi', ...
                'Stoffel Vandoorne'}';
            team = {'Mercedes', ...
                'Ferrari', ...
                'Red Bull', ...
                'Red Bull', ...
                'Ferrari', ...
                'Mercedes', ...
                'Toro Rosso', ...
                'Haas', ...
                'Force India', ...
                'Force India', ...
                'Haas', ...
                'Renault', ...
                'Renault', ...
                'Williams', ...
                'Sauber', ...
                'McLaren', ...
                'Toro Rosso', ...
                'Williams', ...
                'Sauber', ...
                'McLaren'}';
            cost = [30, 29, 27, 27, 26, 28, 22, 17, 20, 16, 18, 19, 16, 24, 15, 20, 17, 16, 15, 15]';
            id = (1:size(name,1))';
            
            teamID = constructors.getid(team);
            
            obj.details = table(id, name, teamID, cost);
            
        end
        
        % Get ID from given constructor names
        function driversIDs = getid(obj, names)
            if ~iscellstr(names)
                error('Drivers name must be a cell or cell array')
            end
            if size(names,2) ~= 1
                error('Only an n by 1 vector is permitted')
            end
            
            driversIDs = zeros(numel(names),1);
            
            % Loop through the cell array
            for i = 1:numel(names)
                row = obj.details(ismember(obj.details.name, names{i}),:);
                
                if size(row,1) < 1
                    error('Drivers name not found')
                end
                
                driversIDs(i,1) = table2array(row(:,'id'));
            end
        end
        
        % Get name from Driver ID
        function driverNames = getname(obj, driverIDs)
            if ~ismatrix(driverIDs)
                error('Drivers IDs must be a vector')
            end
            if size(driverIDs,2) ~= 1
                error('Only an n by 1 vector is permitted')
            end
            
            driverNames = table2array(obj.details(driverIDs,'name'));
        end
        
        % Get constructor ID of driver
        function constructorIDs = getconstructorid(obj, driverIDs)
            if ~ismatrix(driverIDs)
                error('Drivers IDs must be a vector')
            end
            if size(driverIDs,2) ~= 1
                error('Only an n by 1 vector is permitted')
            end
            constructorIDs = table2array(obj.details(driverIDs,'teamID'));
        end
        
        % Get number of drivers
        function noDrivers = getdrivernumber(obj)
            noDrivers = size(obj.details,1);
        end
        
        % Get cost of drivers
        function cost = getcost(obj, driverIDs)
            if ~isvector(driverIDs)
                error('Drivers IDs must be a vector')
            end
            if size(driverIDs,2) ~= 1
                error('Only an n by 1 vector is permitted')
            end

            cost = table2array(obj.details(driverIDs,'cost'));

        end
    end
    
end

