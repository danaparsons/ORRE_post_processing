%% ------------------------------ Header ------------------------------- %%
% Filename:     NREL_OSWEC.m
% Description:  NREL OSWEC data post-processing
% Author:       J. Davis
% Created on:   5-13-21
% Last updated: 5-13-21 by J. Davis
%% ------------------------------ Inputs ------------------------------- %%
dry_inertia = 0;
free_decay = 0;
regularwaves = 1;
%% ---------------------------- dry inertia ---------------------------- %%
if dry_inertia == 1
    % Define inputs:
    directory = 'data\NREL_OSWEC\OSWEC_inertia\body_w_ballast';     % current directory
    file = 'all';
    
    opts = pkg.obj.readDataOpt(directory,file);
    opts.as_struct = true;
    data = pkg.fun.read_data2(opts);
    
    out = OSWEC_inertia(data);
end

%% ---------------------------- free decay ----------------------------- %%
if free_decay == 1
    % Define inputs:
    directory = 'data\NREL_VGOSWEC\freedecay\VGM0';     % current directory
    file = 'all';
    
    opts = pkg.obj.readDataOpt(directory,file);
    opts.as_struct = true;
    %if ~exist('data','var')
    data = pkg.fun.read_data2(opts);
    %end
    
    fs = 500;
    plotloop = true;
    data = OSWEC_freedecay(data,fs,plotloop);
    % TO DO:
    % 1) IMPLEMENT NL DAMPING
    
end
%% ---------------------------- regular ----------------------------- %%
if regularwaves == 1
    % Define inputs:
    % directory = 'data\NREL_OSWEC\OSWEC_regularwaves\5-14-21';
    % directory = 'data\NREL_OSWEC\OSWEC_regularwaves\5-19-21';
    directory = 'data\NREL_VGOSWEC\regularwaves\VGM0';
    file = 'all';
    
    close all
    
    % initialize read data options:
    readdataopts = pkg.obj.readDataOpt(directory,file);
    readdataopts.as_struct = true;
    
%     if ~exist('data','var')
        data = pkg.fun.read_data2(readdataopts);
%     end
    
    % define data channels, variable names, and subfields:
    dataopts = struct();
    dataopts.channels = {7,9,10,11,12,13,14};
    dataopts.varnames = {'phi','fx','fy','fz','mx','my','mz'};
    dataopts.subfields = {'position','forceX','forceY','forceZ','momentX','momentY','momentZ'};
    
    % initialize filters for each subfield:
    filtopts = struct();
    filtopts.type = repmat({'butter'},1,length(dataopts.subfields));
    filtopts.subtype = repmat({'low'},1,length(dataopts.subfields));
    filtopts.order = {4,4,4,4,4,4,4};
%     filtopts.cutoff_margin = {3,[],[],[],[],[],[]};
%     filtopts.f_cutoff = {[],10,10,10,10,10,10};
    filtopts.cutoff_margin = {5,5,5,5,5,5,5};
    dataopts.filters = pkg.fun.init_filters(filtopts);
    
    % specify start and end times, sampling frequency:
    t0 = 10;
    tf = 40;
    fs = 500;
    
    % plot settings
    plotloop = false;
    
    % call regular waves pre-processing function:
    data = OSWEC_regularwaves_pre(data,dataopts,t0,tf,fs,plotloop);
    
   % plot settings
    plotloop = true;
    
    % call regular waves post-processing function:
    data = OSWEC_regularwaves_post(data,dataopts,plotloop);
    
    
    
%         data.T13_A16p75_B2_8.pos.filter.f_cutoff  = 2; data.T13_A16p75_B2_8.filter.order  = 4;
%         data.T13_A16p75_B2_14.pos.filter.f_cutoff = 2; data.T13_A16p75_B2_14.filter.order = 4;
%     % rerun with modified filters:
%     data = OSWEC_regularwaves_pre(data,channels,varnames,subfields,t0,tf,fs,plotloop);
    
    % TO DO:
    % 1) IMPLEMENT PROPER MEAN SUBTRACTION 
    %       (see https://www.mathworks.com/help/matlab/data_analysis/detrending-data.html)
    % 2) CHOP DATA AT A FINITE NUMBER OF CYCLES FOR FINAL FFT
    % 3) REPEAT FOR REMAINING SIGNALS! -> DONE
    
    
end