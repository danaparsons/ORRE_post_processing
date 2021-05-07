
%% ------------------------------ Header ------------------------------- %%
% Filename:     dataClass.m    
% Description:  ORRE Post Processing Program generic channel-based class to
%               store user data.
% Authors:      D. Lukas and J. Davis
% Created on:   7-8-20
% Last updated: 5-6-21 by J. Davis
% Notes: Uses dynamicprops superclass to enable the dynamic creation 
% of class properties:
% https://www.mathworks.com/help/matlab/matlab_oop/dynamic-properties-adding-properties-to-an-instance.html
%% ------------------------------- Class ------------------------------- %%
    
classdef dataClass < dynamicprops
    
    properties
    filename    % Store original filename 
    tags        % Store any data tags relevant to the experiment 
    headers     % Store data headers
    map         % Map data channels to headers
    map_legend  % Store map key and value set for user reference
    % Additional properties and channels are added using the dynamic properties function <addprop>
    
    end

    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Constructor method - constructs instance of this class
        function dataObj = dataClass(filename,tags,headers,data)
            
            % Initialize obj when called with no input arguments
            if nargin == 0
                dataObj.tags = [];
                dataObj.headers = [];
                   
            elseif nargin < 4
                error('Not enough inputs.')
                
            else
                % Handle empty inputs:
                if isempty(filename); filename = '(Empty)'; end
                if isempty(tags); tags = '(Empty)'; end
                
                % Construct tag and header properties from input:
                dataObj.filename = filename;
                dataObj.tags = tags;
                dataObj.headers = headers; 
                
                % Initialize map keySet:
                keySet = cell(size(data));
                
                % Use dynamic properties feature to add appropriate number
                % of channels corresponding to data:
                for ch = 1:size(data,2)
                    dataObj.addprop(strcat('ch',num2str(ch)));
                    dataObj.(strcat('ch',num2str(ch))) = data{ch};
                    
                    % Populate keySet with channel names:
                    keySet{ch} = strcat('ch',num2str(ch));
                    
                end
                
                % Create map and map_legend:
                dataObj.map = containers.Map(keySet,headers);
                dataObj.map_legend = cell2table([transpose(keySet) transpose(headers)]);
                dataObj.map_legend.Properties.VariableNames = {'Key','Value'};
                
                % Note: the map is used to associate channel names (e.g.
                % ch1) with their corresponding headers (e.g. 'Time (s)').
                % This feature allows data to be handeled by functions 
                % universally using the 'ch_' key while maintaining
                % association with the proper heading.
                % For example, calling the following: dataObj.map('ch1') 
                % will yield the string 'Time (s)'

            end

        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Group of methods to sort property names in a logical order:
        % https://gist.github.com/wwarriner/f189373bf40cc741f6d945165a85e115
        function value = properties( obj )
            if nargout == 0
                disp( builtin( "properties", obj ) );
            else
                value = sort( builtin( "properties", obj ) );
            end
        end
        function value = fieldnames( obj )
            value = sort( builtin( "fieldnames", obj ) );
        end
        function group = getPropertyGroups( obj )
            props = properties( obj );
            group = matlab.mixin.util.PropertyGroup( props );
        end  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function dataStruct = to_struct(obj)
            %props =  builtin('properties',obj); % Note <properties> has been overwritten in a previous method
            props =  properties(obj);
            for p = 1:length(props)
                dataStruct.(props{p}) = obj.(props{p});
            end
        end
    end % end of methods
end % end of classdef

