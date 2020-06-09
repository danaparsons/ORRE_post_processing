classdef signalClass
    %TESTCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        t
        x
        amp
        T
    end
    
    methods
        function signal = signalClass(time,position,period)
            %TESTCLASS Construct an instance of this class
            signal.t = time;
            signal.x = position;
            signal.amp = max(position);
            
            if nargin < 3 || isempty(period)
                signal.T = [];
            else
                signal.T = period;
            end
            
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

