%% ------------------------------ Header ------------------------------- %%
% Filename:     read_data.m    
% Description:  ORRE Post Processing Program function to read data and 
%               create an instance of the appropriate data class.
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 5-13-21 by J. Davis
% Notes: The function <read_data.m> is designed to take a variable number 
% of input arguments. The complete call options are as follows:
%
% data = pkg.fun.read_data(data_dir,filename,datatype,ntaglines,
%    nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle)
% 
% Only the first three inputs (data_dir,filename, and datatype) are
% required. The remaining inputs are optional and pertain only to the
% user-defined data class (datatype 1)
%
% IMPORTANT: To skip an input, use '~' in place of the input position. This
% will set the input to its default value:
% 
% data = pkg.fun.read_data(data_dir,filename,datatype,ntaglines,
%    nheaderlines,'~','~','~',delimiter,'~')
%
%% ----------------------------- Function ------------------------------ %%
function [data] = read_data2(opts)
%% -------------------------- Input Parsing ---------------------------- %%
if ~exist('opts','var')
    opts = pkg.obj.readDataOpt();
end
%% ------------------------ Begin reading data ------------------------- %%


% Concatenate file location from provided directory and filename; assign a 
% fileID for later use in textscan function:

if strcmp(opts.file,'all')
    files =  dir(fullfile(opts.directory,opts.datatype));
    filenames = {files.name};
    %     % Sort file names based on run number
    %     filenames = {files.name};
    %     n = cellfun(@(x) str2double(x(4:end-4)),filenames,'UniformOutput',false);
    %     [~, I] = sort(cell2mat(n));
    %     filenames = filenames(I);
    data = [];
    for i = 1:length(filenames)
%         data.(['run',num2str(i)]) = pkg.fun.read_data(directory,filenames{i},datatype,ntaglines,...
%             nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle);
        
        file_location = strcat(opts.directory,filenames{i});
        fileID = fopen(file_location,'r');
        
        % Read tags, headers, and data from file using textscan:
        tags = textscan(fileID,opts.tagformat,opts.ntaglines,'delimiter','\n','CommentStyle',opts.commentstyle);
        headers = textscan(fileID,opts.headerformat,opts.nheaderlines,'delimiter','\n','CommentStyle',opts.commentstyle);
        headers = transpose(split(headers{1},opts.headerdelimiter));
        dataset = textscan(fileID,repmat(opts.dataformat,1,length(headers)),'Delimiter',opts.datadelimiter,'CommentStyle',opts.commentstyle);
        
        % Create dataClass object:
        setname = strsplit(filenames{i},'.');
        data.(setname{1}) = pkg.obj.dataClass(filenames{i},tags{1},headers,dataset);
        
        if opts.as_struct == true
            data.(setname{1}) = data.(setname{1}).to_struct();
        end
        
        % Close the file and exit the function:
        fclose(fileID);      
    end
%     fprintf(['\n','A new collection of dataClass objects were created and stored',...
%         ' from the files:\n\n']); fprintf('    ');
%     disp(cellfun(@(x) print(x),filenames); fprintf('\n')
%     fprintf('From the directory')
%     disp(opts.directory)
%     
else
    
    file_location = strcat(opts.directory,opts.file);
    fileID = fopen(file_location,'r');
    
    % Read tags, headers, and data from file using textscan:
    tags = textscan(fileID,opts.tagformat,opts.ntaglines,'delimiter','\n','CommentStyle',opts.commentstyle);
    headers = textscan(fileID,opts.headerformat,opts.nheaderlines,'delimiter','\n','CommentStyle',opts.commentstyle);
    headers = transpose(split(headers{1},opts.headerdelimiter));
    data = textscan(fileID,repmat(opts.dataformat,1,length(headers)),'Delimiter',opts.datadelimiter,'CommentStyle',opts.commentstyle);
    
    
    % Create dataClass object:
    data = pkg.obj.dataClass(opts.file,tags{1},headers,data);
    
    fprintf(['\n','A new instance of dataClass was created with ',num2str(data.map.Count),...
        ' channels from the file:\n\n']); fprintf('    ');
    disp(data.file); fprintf('\n')
    fprintf('The following tags are associated with the data:\n\n')
    disp(data.tags)
    fprintf('The channels are mapped to the data headers as follows:\n\n')
    disp(data.map_legend)
    
    if opts.as_struct == true
        data = data.to_struct();
    end
    
    % Close the file and exit the function:
    fclose(fileID);
    
end



end

%% ------------------------------ Deleted ------------------------------ %%
