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
    % 1) IMPROVE NATURAL PERIOD ESTIMATE FROM PEAKS NOT FFT (NOT SHARP
    % ENOUGH)
    % 2) IMPLEMENT NL DAMPING
    
    
end
%% ---------------------------- regular ----------------------------- %%
if regularwaves == 1
  % ------------------------ design waves -------------------------- %
  % READ DATA:
    directory = 'data\NREL_VGOSWEC\designwaves\Wave_calibration_CV';
    file = 'all';
    
    % initialize read data options:
    readdataopts = pkg.obj.readDataOpt(directory,file);
    readdataopts.as_struct = true;
    
    % call read data function:
%     if ~exist('data','var')
        data = pkg.fun.read_data2(readdataopts);
%     end

    % PRE-PROCESSING:
    % define data channels, variable names, and subfields to be pre-processed:
    regularwaves_pre_opts = struct();
    regularwaves_pre_opts.channels = {3,4};
    regularwaves_pre_opts.varnames = {'eta','eta'};
    regularwaves_pre_opts.subfields = {'wp1','wp2'};
    
    % initialize filters for each subfield:
    filtopts = struct();
    filtopts.type = repmat({'butter'},1,length(regularwaves_pre_opts.subfields));
    filtopts.subtype = repmat({'low'},1,length(regularwaves_pre_opts.subfields));
    filtopts.order = {4,4,4,4,4,4,4};
    filtopts.cutoff_margin = {5,5,5,5,5,5,5}; % filtopts.cutoff_margin = {3,[],[],[],[],[],[]}; % filtopts.f_cutoff = {[],10,10,10,10,10,10};
    regularwaves_pre_opts.filters = pkg.fun.init_filters(filtopts);
    
    % specify start and end times; sampling frequency:
    t0 = 10;
    tf = 40;
    fs = 500;
    
    % other settings
    plotloop = false;
    verbose = true;
    
    % POST-PROCESSING:
    % call regular waves pre-processing function:
    data = OSWEC_regularwaves_pre(data,regularwaves_pre_opts,t0,tf,fs,plotloop,verbose);
    
    % define data channels, variable names, and subfields to be post-processed:
    regularwaves_post_opts.varnames = {'eta','eta'};
    regularwaves_post_opts.subfields = {'wp1','wp2'};
    
   % plot settings
    plotloop = false;
    verbose = true;
    
    % call regular waves post-processing function:
    data = OSWEC_regularwaves_post(data,regularwaves_post_opts,plotloop);
 
    % ------------------------- model runs -------------------------- %
    % READ DATA:
    % directory = 'data\NREL_OSWEC\OSWEC_regularwaves\5-14-21';
    % directory = 'data\NREL_OSWEC\OSWEC_regularwaves\5-19-21';
    directory = 'data\NREL_VGOSWEC\regularwaves\VGM0';
    file = 'all';
    
    % initialize read data options:
    readdataopts = pkg.obj.readDataOpt(directory,file);
    readdataopts.as_struct = true;
    
    % call read data function:
%     if ~exist('data','var')
        data = pkg.fun.read_data2(readdataopts);
%     end

    % PRE-PROCESSING:
    % define data channels, variable names, and subfields to be pre-processed:
    regularwaves_pre_opts = struct();
    regularwaves_pre_opts.channels = {7,9,10,11,12,13,14};
    regularwaves_pre_opts.varnames = {'phi','fx','fy','fz','mx','my','mz'};
    regularwaves_pre_opts.subfields = {'position','forceX','forceY','forceZ','momentX','momentY','momentZ'};
    
    % initialize filters for each subfield:
    filtopts = struct();
    filtopts.type = repmat({'butter'},1,length(regularwaves_pre_opts.subfields));
    filtopts.subtype = repmat({'low'},1,length(regularwaves_pre_opts.subfields));
    filtopts.order = {4,4,4,4,4,4,4};
    filtopts.cutoff_margin = {5,5,5,5,5,5,5}; % filtopts.cutoff_margin = {3,[],[],[],[],[],[]}; % filtopts.f_cutoff = {[],10,10,10,10,10,10};
    regularwaves_pre_opts.filters = pkg.fun.init_filters(filtopts);
    
    % specify start and end times; sampling frequency:
    t0 = 10;
    tf = 40;
    fs = 500;
    
    % other settings
    plotloop = true;
    verbose = true;
    
    % POST-PROCESSING:
    % call regular waves pre-processing function:
    data = OSWEC_regularwaves_pre(data,regularwaves_pre_opts,t0,tf,fs,plotloop,verbose);
    
    % define data channels, variable names, and subfields to be post-processed:
    regularwaves_post_opts.varnames = {'phi','fx','fz','my'};
    regularwaves_post_opts.subfields = {'position','forceX','forceZ','momentY'};
    
   % plot settings
    plotloop = false;
    
    % call regular waves post-processing function:
    data = OSWEC_regularwaves_post(data,regularwaves_post_opts,plotloop);
    
   %%%%%%
   
   
   figure
   errorbar(data.Results.phi.T_mean,data.Results.phi.A_pks_mean,data.Results.phi.A_pks_std,'o'); hold on
   errorbar(data.Results.phi.T_mean,data.Results.phi.A_fft_mean,data.Results.phi.A_fft_std,'o')
   
   figure
   errorbar(data.Results.my.T_mean,data.Results.my.A_pks_mean,data.Results.my.A_pks_std,'o'); hold on
   errorbar(data.Results.my.T_mean,data.Results.my.A_fft_mean,data.Results.my.A_fft_std,'o')
   
end