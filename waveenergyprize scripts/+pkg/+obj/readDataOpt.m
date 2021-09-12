classdef readDataOpt

    properties
        directory       = pwd    % current directory
        file            = []
        datatype        = '*.txt'
        ntaglines       = 12;
        nheaderlines    = 1;
        tagformat       = '%s';
        headerformat    = '%s';
        dataformat      = '%f';
        headerdelimiter = char(9); %tab
        datadelimiter   = ' ';
        commentstyle    = '%';
        as_struct        = false
    end
    
    methods
        function obj = readDataOpt(directory,file)
            % Initialize obj when called with no input arguments
              if  nargin > 0
                  
                  if exist('directory','var')
                      % Convert directory to char, if it is not already
                      if isstring(directory)
                          directory = char(directory);
                      end
                      % Check if the directory ends in a '\' or '/'. If not, be kind and add it.
                      if ~contains(directory(end),{'\','/'})
                          directory = [directory,'\'];
                      end
                      obj.directory = directory;
                  end
                  
                  if exist('file','var'); obj.file = file; end
                  
                  %%% FINISH INPUT PARSING FOR REMAINDER OF PROPS
              end
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

