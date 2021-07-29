%% ------------------------------ Header ------------------------------- %%
% Filename:     OSWEC_regularwaves_post.m
% Description:  Post-process OSWEC-type model regular wave experiments
% Author:       J. Davis
% Created on:   5-18-21
% Last updated: 6-25-21 by J. Davis
%% --------------------------------------------------------------------- %%
function [data] = OSWEC_regularwaves_post(data,dataopts,plotloop,verbose)

% extract setnames, channels, variable names, and subfields:
setnames = fieldnames(data);
varnames = dataopts.varnames;
subfields = dataopts.subfields;

% append subfield to results variable name if varname is repeated:
[~,~,repeatvars] = unique(varnames);
if length(repeatvars) ~=(unique(repeatvars))
    repeatvars = logical(repeatvars);
    varnames_results = strcat(varnames(repeatvars),'_',subfields(repeatvars));
else
    varnames_results = varnames;
end

% extract number of runs and subfields in the dataset:
numruns = length(setnames); 
numsubfields = length(subfields);

% initialize results structure:
Results = struct();

for i = 1:numruns
    % assign current run of the dataset:
    currentrun = setnames{i};
    if verbose==1; disp(['%',repmat('-',1,100),'%',newline,currentrun]); end
    
    % extract run identifiers:    
    runID(i,:) = strsplit(currentrun,'_');

    % keep track of run repeats:
    if i>1 && strcmp(runID{i,1},runID{i-1,1})==1
        cnt=cnt+1;
    else
        cnt=1;
    end
    
    for j = 1:numsubfields
        % assign current subfield and variable name:
        subfield = subfields{j};
        varname = varnames{j};   
        varname_results = varnames_results{j};
        if verbose==1; disp(varname); end
        
%         if contains(currentrun,'T20')
            plotloop = true;
%         else
%             plotloop = false;
%         end
        
        % close any open figures
        close all
        
        % initialize results fields:
        if cnt ==1
            Results.(runID{i,1}).(varname_results).('T') = [];
            Results.(runID{i,1}).(varname_results).('A_fft') = [];
            Results.(runID{i,1}).(varname_results).('A_pks') = [];
        end
        
        % extract data
        y  = data.(currentrun).(subfield).(varname);
        t  = data.(currentrun).(subfield).t;
        
        % find peaks to slice at integer number of cycles
        pkprom = 0.90*sqrt(2)*rms(y);
        pkheight = 0.80*sqrt(2)*rms(y);
        [pk, loc]= findpeaks(y,t,'MinPeakProminence',pkprom,'MinPeakHeight',pkheight,'Annotate','extents');
        [negpk,~]= findpeaks(-y,t,'MinPeakProminence',pkprom,'MinPeakHeight',pkheight,'Annotate','extents');
                
        % pos and neg amps by mean of peaks
        A_pks1 = mean(pk);
        A_pks2 = -mean(negpk);
        
        % remove mean based on peaks
        y = y - (A_pks1+A_pks2)/2;
        
        % take amplitude as mean of the abs of the +/- amplitudes:
        A_pks_combined = (A_pks1-A_pks2)/2;
        
        % update t0 and tf to first and last peak
        t0_fft = loc(1);
        tf_fft = loc(end);
        
        % store number of cycles
        ncycles = size(loc(2:end-1),1) - 1;
        
        % slice t and y at integer cycles
        t_slice = t(t >= t0_fft & t <= tf_fft);
        y_slice = y(t >= t0_fft & t <= tf_fft);
        
        % fft
        fs = data.(currentrun).(subfield).fft.pre.fs;
        pkpromfactor = 0.25; % threshold (as proportion of peak FFT value) below which additional peaks are considered insignificant
        [f,Ma,~,T,A_fft,~,~,fft_post] = pkg.fun.plt_fft(t_slice,y_slice,fs,pkpromfactor);
        fft_post.ncycles = ncycles;
        
        % Check if the dominant period identified by the fft is less than the maximum significant
        % period. If it is, check if the dominant period is an integer multiple of the maximum 
        % signficiant period. A whole number remainder indicates it is a higher harmonic reflection,  
        % and the fundamental and its amplitude will instead be used as the output period T and amplitude A.
        if fft_post.dominant_period < max(fft_post.significant_periods) 
            sigperiodratio = max(fft_post.significant_periods)./fft_post.dominant_period;
            if rem(round(sigperiodratio,1),1)==0 && sigperiodratio < 3
                T =  max(fft_post.significant_periods);
                A =  fft_post.significant_amps(fft_post.significant_periods ==  max(fft_post.significant_periods));
            end
        end

%         if contains(currentrun,'T20')
%             dataopts.min_period = 1.5;
%         else
%             ;
%         end
%         
%         if isfield(dataopts,'min_period') && fft_post.dominant_period < dataopts.min_period
%             T = max(fft_post.significant_periods(fft_post.significant_periods > dataopts.min_period));
%         else
%             T = fft_post.dominant_period;
%         end
        
        
        % display to commmand window
        if verbose==1
            disp(['T = ',num2str(T)])
            disp(['A = ',num2str(A_fft)])
        end
        
%         T_list(cnt) = T;
%         A_fft_list(cnt) = A_fft;
%         A_pks_list(cnt) = 
        
        % store results by period run identifier:
        Results.(runID{i,1}).(varname_results).T(cnt) = T;
        Results.(runID{i,1}).(varname_results).A_fft(cnt) = A_fft;
        Results.(runID{i,1}).(varname_results).A_pks(cnt) = A_pks_combined;
        
%         T_list{i,j} = T;
%         A_list{i,j}  = A_fft;
%         A_list{i,j}  = A_pks_combined;
        
        % figures
        if plotloop == true
            % plot 1: complete signal
            fig1 = figure;
            fig1.Position(1) = fig1.Position(1) - fig1.Position(3);
            fig1.Position(2) = fig1.Position(2) - fig1.Position(4)/2;
            plot(t,y,'DisplayName','Original','LineWidth',1.25)
            legend()
            xlabel('t(s)')
            ylabel(varname)
            legend()
            xlim([min(t),max(t)])
            sgtitle(replace(currentrun,'_',' '))
            
            % plot 2: sliced signal used to obtain the integer-cycle fft
            fig2 = figure;
            fig2.Position(2) = fig2.Position(2) - fig2.Position(4)/2;
            plot(t,y,'DisplayName','Original','LineWidth',1.25); hold on
            plot(t_slice,y_slice,'DisplayName','Sliced','LineWidth',1.25)
            yline(A_fft,'b','DisplayName','FFT Amp')
            yline(-A_fft,'b','HandleVisibility','off')
            yline(A_pks_combined,'r','DisplayName','Mean +/- Peak Amps')
            yline(-A_pks_combined,'r','HandleVisibility','off')
            legend()
            xlabel('t(s)')
            ylabel(varname)
            legend('Location','southoutside','Orientation','horizontal')
            xlim([min(t),max(t)])
            ylim(1.4*max(max(fft_post.dominant_amp),max(A_pks1)).*[-1 1])
            xl = xlim; yl = ylim;
            text(0.75*xl(2),0.9*yl(1),['ncycles = ',num2str(ncycles)])
            sgtitle(replace(currentrun,'_',' '))
            
            % plot 3: integer-cycle fft used to obtain the amplitude and period
            fig3 = figure;
            fig3.Position(1) = fig3.Position(1) + fig3.Position(3);
            fig3.Position(2) = fig3.Position(2) - fig3.Position(4)/2;
            semilogx(f,Ma,'DisplayName','Sliced','LineWidth',1.25)
            legend()
            xlabel('f(Hz)')
            ylabel(['Ma ',varname])
            legend()
            sgtitle(replace(currentrun,'_',' '))
            
        end
        
        % populate dataset fields
        data.(currentrun).(subfield).T  = T;
        data.(currentrun).(subfield).A_fft  = A_fft;
        data.(currentrun).(subfield).A_pks  = A_pks_combined;
        data.(currentrun).(subfield).fft.post  = fft_post;
    end
end

% loop to collate results; performed outside of main loop to handle a
% variable number of run repeats:

% extract ID and number of periods:
periods = fieldnames(Results);
numperiods = length(periods);

% initialize bulk results matrices:
T_mean = zeros(numperiods,numsubfields);
A_fft_mean = zeros(numperiods,numsubfields);
A_pks_mean = zeros(numperiods,numsubfields);
T_std = zeros(numperiods,numsubfields);
A_fft_std = zeros(numperiods,numsubfields);
A_pks_std = zeros(numperiods,numsubfields);

for i = 1:numperiods
    % assign current run of the dataset:
    currentperiod = periods{i};
    for j = 1:numsubfields 
    % assign current variable name:
    varname = varnames_results{j};
    
    % calculate mean and stdev of each property
    T_list{i,j} = Results.(currentperiod).(varname).T;
    A_fft_list{i,j}  = Results.(currentperiod).(varname).A_fft;
    A_pks_list{i,j}  = Results.(currentperiod).(varname).A_pks;
    
    T_mean(i,j) = mean(Results.(currentperiod).(varname).T);
    A_fft_mean(i,j)  = mean(Results.(currentperiod).(varname).A_fft);
    A_pks_mean(i,j)  = mean(Results.(currentperiod).(varname).A_pks);
    T_std(i,j)      = std(Results.(currentperiod).(varname).T);
    A_fft_std(i,j)  = std(Results.(currentperiod).(varname).A_fft);
    A_pks_std(i,j)  = std(Results.(currentperiod).(varname).A_pks);
    
    % populate results by period:
    Results.(currentperiod).(varname).T_mean = T_mean(i,j);
    Results.(currentperiod).(varname).A_fft_mean = A_fft_mean(i,j);
    Results.(currentperiod).(varname).A_pks_mean = A_pks_mean(i,j);
    Results.(currentperiod).(varname).T_std = T_std(i,j);
    Results.(currentperiod).(varname).A_fft_std = A_fft_std(i,j);
    Results.(currentperiod).(varname).A_pks_std = A_pks_std(i,j);
    end
end

% loop to store results by variable name:
for j = 1:numsubfields
    varname = varnames_results{j};
    tablebyvar = [cell2table(T_list(:,j),'VariableNames',{'T'}) ...
        array2table([T_mean(:,j) T_std(:,j)],'VariableNames',{'T_mean','T_std'})...
        cell2table(A_fft_list(:,j),'VariableNames',{'A_fft'})...
        array2table([A_fft_mean(:,j) A_fft_std(:,j)],'VariableNames',{'A_fft_mean','A_fft_std'})...
        cell2table(A_pks_list(:,j),'VariableNames',{'A_pks'})...
        array2table([A_pks_mean(:,j) A_pks_std(:,j)],'VariableNames',{'A_pks_mean','A_pks_std'})...
        ];
%   tablebyvar = array2table([T_mean(:,j) T_std(:,j) A_fft_mean(:,j) A_fft_std(:,j) A_pks_mean(:,j) A_pks_std(:,j)]);
%     tablebyvar.Properties.VariableNames = {'T_mean','T_std','A_fft_mean','A_fft_std','A_pks_mean','A_pks_std'};
    Results.(varname) = sortrows(tablebyvar,'T_mean');
end

% store combined results as a table:
% columnnames = ['T',reshape([strcat(varnames_results,{'_A_fft_mean'});...
%                             strcat(varnames_results,{'_A_fft_std'});...
%                             strcat(varnames_results,{'_A_pks_mean'});...
%                             strcat(varnames_results,{'_A_pks_std'})],...
%                             1,4*numsubfields)];
% Results.combined = array2table([T_mean(:,1) reshape([A_fft_mean;A_fft_std;A_pks_mean;A_pks_std], numperiods, [])]);
% Results.combined.Properties.VariableNames = columnnames;

% store results in data structure:
data.Results = Results;
end