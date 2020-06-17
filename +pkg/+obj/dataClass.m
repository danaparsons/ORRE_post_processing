classdef dataClass < dynamicprops
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     dataClass.m    
% Description:  ORRE Post Processing Program class to store data tags, 
%               headers, and data.in a user-defined object.
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 6-17-20 by J. Davis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
     
%%% Notes:
% Uses dynamicprops superclass to enable dynamic creation of props:
% https://www.mathworks.com/help/matlab/matlab_oop/dynamic-properties-adding-properties-to-an-instance.html
    
    properties
    % No default properties defined yet! (Since they are added dynamically by the user) 
    % Maybe we can automatically include a date property which initializes 
    % when the obj is created?
    end
    
    methods
        function obj = dataClass()
            if nargin == 0
                % Initialize obj when called with no input arguments
                % None needed yet!
            else
                % When nargin ~= 0 use assigned tags and headers
                % None needed yet!
            end

        end
        
        %%%% Group of methods to sort property names in a logical order:
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
    end % end of methods
end % end of classdef

