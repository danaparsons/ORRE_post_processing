classdef dataClass < dynamicprops
    % Generic class for storing user-defined tags, headers, and data. 
    % Uses dynamicprops superclass to enable dynamic creation of props
    properties

    end
    
    methods
        function obj = dataClass()
            if nargin == 0
                % Initialize obj when called with no input arguments
                %
            else
                % When nargin ~= 0 use assigned tags and headers
                %
            end

        end
        
        % Group of methods to sort property names in a logical order
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

    end
end

