%% ------------------------------ Header ------------------------------- %%
% Filename:     OSWEC_inerta.m
% Description:  Calculates the inertia of an OSWEC-type model from input 
%               dry inertia run data
% Author:       J. Davis
% Created on:   5-13-21
% Last updated: 5-13-21 by J. Davis
%% --------------------------------------------------------------------- %%
function out = OSWEC_inertia(data)


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


%run1struc = data.run1.to_struct();
% data.Run1.rename('ch1','y')

numruns = length(fieldnames(data)); % number of fields in the dataset


% moment of inertia calc loop
g = 9.81;           % (m/s^2)
d = 0.18;           %  from hang test (m)
M = 6.446+7.044;    % body + ballast (kg)


Tn  = zeros(numruns,1); % initialize vector to store dominant periods
wn  = zeros(numruns,1); 
Iyy = zeros(numruns,1);

plotloop = 0;

for runnum = 1:numruns
    
    run = ['Run',num2str(runnum)];

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

% compute basic statistics
Tn_mean  = mean(Tn); Tn_std = std(Tn);
Iyy_mean = mean(Iyy); Iyy_std  = std(Iyy);

% visualize results
figure; hold on
scatter(1:numruns,Iyy,'o','MarkerFaceColor','k','MarkerEdgeColor','k','DisplayName','observations')
    yline(Iyy_mean,'LineWidth',1.5,'DisplayName','mean')
    ylim([0.9 1.1]*Iyy_mean)
    xlim([1 numruns])
    % plot 1 stddev from mean
    inBetween = [(Iyy_mean+Iyy_std)*[1 1], fliplr((Iyy_mean-Iyy_std)*[1 1])];
    fill([[1 numruns], fliplr([1 numruns])], inBetween, 'k','FaceAlpha',0.1,'EdgeColor','none','DisplayName','1 stdev')
    xlabel('Observation')
    ylabel('I_{yy} (kg-m^2)')
    legend()
    
    
figure
histogram(Iyy,round(numruns/2))
xlabel('I_{yy} (kg-m^2)')
ylabel('Count')

out.Iyy_mean    = Iyy_mean;
out.Iyy_std     = Iyy_std;
out.Tn_mean     = Tn_mean;
out.Tn_std      = Tn_std;
end


