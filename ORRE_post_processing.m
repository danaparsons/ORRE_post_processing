%% ------------------------------ Header ------------------------------- %%
% Filename:     ORRE_post_processing.m
% Description:  ORRE Post Processing Program run file
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 8-9-20 by J. Davis
%% ------------------------------ Inputs ------------------------------- %%
run_app = 0;
show_examples = 0;
UserDefinedScript = 'OSWEC_inertia.m';

%% -------------------------------- Run -------------------------------- %%
if run_app == 1 
    ORRE_post_processing_app    % Execute app
else  
    run(UserDefinedScript)          % Run script
end
%% ----------------------------- Examples ------------------------------ %%
if show_examples == 1
    
% Define inputs:
directory = "C:\Users\orre2\Desktop\OSWEC_inertia\";     % current directory
filename = "run1.txt";
datatype = 1;
ntaglines = 12;
nheaderlines = 1;
tagformat = '%s';
headerformat = '%s';
dataformat =  '%f';
headerdelimiter = char(9); %tab
datadelimiter = ' ';
commentstyle = '%';
  
% Call the <read_data.m> function to create an instance of the appropriate
% data class:   

data = pkg.fun.read_data(directory,filename,datatype,ntaglines,...
    nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle);
    
%%% Note:
% The function <read_data.m> is designed to take a variable number of input 
% arguments. The complete call options are as follows:
%
% data = pkg.fun.read_data(data_dir,filename,datatype,ntaglines,nheaderlines,tagformat,headerformat,dataformat,commentstyle)
% 
% Only the first three inputs (data_dir,filename, and datatype) are
% required. The remaining inputs are optional and pertain only to the
% user-defined data class (datatype 1)

%%% Example of calling a function

% test of call method 1: direct input of data arrays
dominant_period = pkg.fun.plt_fft(data.ch1,data.ch2);

% test of call method 2: channel indicators
dominant_period = pkg.fun.plt_fft(1,3,data);

% test of bad calls:
dominant_period = pkg.fun.plt_fft(10,2,data); % returns error for nonexistent channel
dominant_period = pkg.fun.plt_fft(1.1,2,data); % returns error for non-int channel indicator


%%% Plotting example with use of data.map feature:

% Hard-coded:
figure
plot(data.ch1,data.ch2)
xlabel(data.map('ch1'))
ylabel(data.map('ch2'))


% Given the desired channel numbers, this is can be dynamically coded 
% (I think I made that term up) as the following:

% user-defined channels to plot:
n = '1';
m = '2';

figure
plot(data.(strcat('ch',n)),data.(strcat('ch',m)))
xlabel(data.map(strcat('ch',n)))
ylabel(data.map(strcat('ch',m)))

end



