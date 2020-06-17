function [data_obj] = read_data(directory,filename,datatype,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     read_data.m    
% Description:  ORRE Post Processing Program function to read data and 
%               create an instance of the appropriate data class.
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 6-17-20 by J. Davis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Notes:
% The function <read_data.m> is designed to take a variable number of input 
% arguments. The complete call options are as follows:
%
% data = pkg.fun.read_data(data_dir,filename,datatype,channeltypes,tagtypes,tagformat)
% 
% Only the first three inputs (data_dir,filename, and datatype) are
% required. The remaining inputs are optional and pertain only to the
% user-defined dataclass (datatype 1)

%%% Input Parsing:
% Since this function can take a variable number of inputs (varargin), it
% is best practice to parse the inputs and define whether they are required
% or optional. This process also assigns any default values for the optional
% inputs (if neccessary). See the following to learn more:
% https://www.mathworks.com/company/newsletters/articles/tips-and-tricks-writing-matlab-functions-with-flexible-calling-syntax.html
% https://www.mathworks.com/help/matlab/ref/inputparser.html

% Return an error if minimum number of required arguments is not satisfied:
if nargin < 3
    error('Not enough inputs')
end
   
% Define default values for optional input arguments:
default_channeltypes = [];
default_tagtypes = [];
default_tagformat = [];

% Create input parser object
p = inputParser;

% Define valid input types:
valid_datatypes = @(x) mustBeMember(x,[0,1,2]); % only accept valid datatypes
% example for a string: checkString = @(s) any(strcmp(s,{'square','rectangle'}));

% Define input types:
% The syntax for <addRequired> is
% addRequired(inputParser,'input',default,validation)
addRequired(p,'directory',@isstring);
addRequired(p,'filename',@isstring);
addRequired(p,'datatype',valid_datatypes);
addOptional(p,'channeltypes',default_channeltypes)
addOptional(p,'tagtypes',default_tagtypes);
addOptional(p,'tagformat',default_tagformat,@isstring)

% Parse the inputs:
parse(p,directory,filename,datatype,varargin{:});

% Assign parsed input variables:
directory  = p.Results.directory;
filename = p.Results.filename;
datatype  = p.Results.datatype;
channeltypes  = p.Results.channeltypes;
tagtypes  = p.Results.tagtypes;
tagformat = p.Results.tagformat;

%%% Begin data reading process:

% Concatenate file location from provided directory and filename; assign a 
% fileID for later use in textscan function:
file_location = strcat(directory,'\',filename);
fileID = fopen(file_location,'r');

% Interpret data type from input key:

if datatype == 0 % test data
    % Create variables for number of tag and header lines based on
    % pre-defined file structure. This should be known for all datat types
    % (excluding user-defined) based on how the labview data aquisition
    % program is written.
    ntaglines = 2;
    nheaderlines = 1;
    
    % Use textscan function to read in data:
    data_tags = textscan(fileID,'%s',ntaglines,'CommentStyle','#');
    data_headers = textscan(fileID,'%s %s',nheaderlines,'Delimiter',',','CommentStyle','#');
    data = textscan(fileID,'%f %f','Delimiter',',','CommentStyle','#');
    
    % (I haven't created a class for this yet, we probably don't need it)
    
elseif datatype == 1 % user-defined (dataClass)
    
    % Interpret header and data format based on length of channeltype array:
    headerformat = repmat('%s',1,length(channeltypes)); % strings
    dataformat = repmat('%f',1,length(channeltypes));   % floats
    
    % Define number of tag and header lines (these should probably be inputs)
    ntaglines = 1;
    nheaderlines = 1;
    
    % Read tags, headers, and data from file using textscan:
    data_tags = textscan(fileID,tagformat,ntaglines,'CommentStyle','#');
    data_headers = textscan(fileID,headerformat,nheaderlines,'Delimiter',',','CommentStyle','#');
    data = textscan(fileID,dataformat,'Delimiter',',','CommentStyle','#');
    
    % (Delimiter type and comment style should also probably be inputs!)
    
    % Initialize instance of dataClass: 
    % See +pkg/+obj/dataClass.m 
    data_obj = pkg.obj.dataClass();
    
    % Assign tag properties to data_obj based on tagtypes input and populate 
    % with data_tag informtation read from the data file:
    for tag = 1:length(data_tags)
        % Check if the tag contains a string within a cell:
        if iscell(data_tags{tag}) 
            data_obj.addprop(tagtypes{tag}); % add property to object
            data_obj.(tagtypes{tag}) = data_tags{tag}{1}; % populate
            
        % Check if the tag contains a numeric input:
        elseif isnumeric(data_tags{tag}) 
            data_obj.addprop(tagtypes{tag}); % add property to object
            data_obj.(tagtypes{tag}) = data_tags{tag}(1); % populate
        end    
    end
    
    % Since this approach adds properties based on the channel type (e.g.
    % t, wp, strpot) it is possible to have more than one type. If so, this
    % loop appends a number on the end (we may not want to use this 
    % approach but it is an option):
    
    propcnt = 1; % initialize property counter
    for prop = 1:length(data_headers)
        
        % Check if the current channel type is repeated using <nnz>:
        if nnz(strcmp(channeltypes,channeltypes{prop})) > 1
            
            % While the current property name is repeated in data_obj, 
            % append the property name with the property counter number:
            while isprop(data_obj,(channeltypes{prop}))
                
                % Preserve channel name on first instance:
                if propcnt == 1
                    ch_name = channeltypes{prop};
                end
                
                % Modify channel type name:
                channeltypes{prop} = strcat(ch_name,num2str(propcnt+1));
                propcnt = propcnt + 1;
                
            end
            propcnt = 1; % reinitialize property counter for next property
            
        end
        % Add the current channel type as a property and populate with
        % corresponding data:
        data_obj.addprop(channeltypes{prop}); 
        data_obj.(channeltypes{prop}) = data{prop};
        
        %%% Here I think it makes sense to use the containers.Map object to
        %%% map header names to the channel name properties of data_obj. 
        %%% Just haven't gotten around to doing it yet!
        %%% https://www.mathworks.com/help/matlab/ref/containers.map.html#d120e731116
        
    end
end
 
% Close the file and exit the function:
fclose(fileID); 

end

