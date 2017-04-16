classdef Constructors
    %CONSTRUCTORS Links constructor IDs to constructor details
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        details
    end
    
    methods
        % Constructor
        function obj = Constructors()
            % Populate the constructors table
            name = {'Mercedes', ...
                'Ferrari', ...
                'Red Bull', ...
                'Williams', ...
                'Toro Rosso', ...
                'Renault', ...
                'Force India', ...
                'McLaren', ...
                'Haas', ...
                'Sauber'}';
            cost = [33, 30, 29, 26, 24, 24, 23, 23, 19, 16]';
            id = (1:size(name,1))';
            obj.details = table(id, name, cost); 
        end
        
        % Get ID from given constructor names
        function constructorIDs = getid(obj, names)
            if ~iscellstr(names)
                error('Constructors name must be a cell or cell array')
            end
            if size(names,2) ~= 1
                error('Only an n by 1 vector is permitted')
            end
            
            constructorIDs = zeros(numel(names),1);
            
            % Loop through the cell array
            for i = 1:numel(names)
                row = obj.details(ismember(obj.details.name, names{i}),:);
                
                if size(row,1) < 1
                    error('Constructors name not found')
                end
                
                constructorIDs(i,1) = table2array(row(:,'id'));
            end
        end
        
        % Get cost of constructors
        function cost = getcost(obj, constructorIDs)
            if ~isvector(constructorIDs)
                error('Constructor IDs must be a vector')
            end
            if size(constructorIDs,2) ~= 1
                error('Only an n by 1 vector is permitted')
            end
            cost = table2array(obj.details(constructorIDs,'cost'));
        end
        
        % Get name from Constructor ID
        function constructorNames = getname(obj, constructorIDs)
            if ~ismatrix(constructorIDs)
                error('Constructor IDs must be a vector')
            end
            if size(constructorIDs,2) ~= 1
                error('Only an n by 1 vector is permitted')
            end
            
            constructorNames = table2array(obj.details(constructorIDs,'name'));
        end
        
    end
    
end

