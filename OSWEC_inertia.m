%% ------------------------------ Header ------------------------------- %%
% Filename:     ORRE_post_processing.m
% Description:  ORRE Post Processing Program input file (test)
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 8-9-20 by J. Davis
%% ------------------------------------ -------------------------------- %%

close all % close any open figures

% Define inputs:
directory = 'data\OSWEC_inertia\w_ballast\';     % current directory
datatype = 1;
ntaglines = 12;
nheaderlines = 1;
tagformat = '%s';
headerformat = '%s';
dataformat =  '%f';
headerdelimiter = char(9); %tab
datadelimiter = ' ';
commentstyle = '%';

% Get file list in directory
files = dir(fullfile(directory,'*.txt'));

% Sort file names based on run number
filenames = {files.name};
n = cellfun(@(x) str2double(x(4:end-4)),filenames,'UniformOutput',false);
[~, I] = sort(cell2mat(n));
filenames = filenames(I);

% Read in data if it is not already in the workspace
if ~exist('data','var')
    for i = 1:length(filenames)
    data.(['run',num2str(i)]) = pkg.fun.read_data(directory,filenames{i},datatype,ntaglines,...
        nheaderlines,tagformat,headerformat,dataformat,headerdelimiter,datadelimiter,commentstyle);
    end
    numruns = i; clear i;
end


% moment of inertia calc loop
g = 9.81;
d = 0.18; % from SW, no ballast
M = 6.446+7.044; % body + ballast (kg)


Tn  = zeros(numruns,1); % initialize vector to store dominant periods
wn  = zeros(numruns,1); 
Iyy = zeros(numruns,1);

plotloop = false;

for runnum = 1:numruns
    
    run = ['run',num2str(runnum)];

    phi0 = min(data.(run).ch2(data.(run).ch2 == min(data.(run).ch2)));
    t0   = min(data.(run).ch1(data.(run).ch2 == phi0));
    t    = data.(run).ch1(data.(run).ch1 >= t0)-t0;
    phi_raw  = data.(run).ch2(data.(run).ch1 >= t0); phi_raw = phi_raw-mean(phi_raw(end-100:end-5));

    % lowpass filter
    [f_raw,P_raw] = pkg.fun.plt_fft(t,phi_raw);
    passbandfreq = 5; % Hz
    [phi,filter] = lowpass(phi_raw,passbandfreq,(2*10^-3)^(-1),'Steepness',0.95);
    [f,P,Tn(runnum)] = pkg.fun.plt_fft(t,phi);
    
    if plotloop == true
        figure
            semilogx(f_raw,P_raw,'DisplayName','Original'); hold on
            semilogx(f,P,'DisplayName','Filtered'); 
            xline(passbandfreq,'DisplayName','Passband frequency')
            legend()
            xlabel('f(Hz)')
            ylabel('P1')

        figure
            plot(t,phi_raw,'DisplayName','Original'); hold on
            plot(t,phi,'DisplayName','Filtered')
            legend()
            xlabel('t(s)')
            ylabel('phi(deg)')
    end
wn(runnum)  = 2*pi/Tn(runnum);
Iyy(runnum) = M*g*d/wn(runnum)^2; % kg-m^2        
end

Tn_mean  = mean(Tn);
Tn_stdev = std(Tn);

Iyy_mean = mean(Iyy);
Iyy_std  = std(Iyy);

IyySW   = 0.6583; % kg-m^2

figure
bar(1,Iyy_mean,'DisplayName','Swing Test'); hold on
    er = errorbar(1,Iyy_mean,Iyy_std,Iyy_std,'DisplayName','Swing Test STDEV');
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';
bar(2,IyySW,'DisplayName','SW')
ylabel('I_{yy} (kg-m^2)')
xticks([1,2])
xticklabels({'exp','SW'})
