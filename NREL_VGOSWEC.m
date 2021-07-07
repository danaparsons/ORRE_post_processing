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
    inertia = pkg.fun.read_data2(opts);
    
    out = OSWEC_inertia(inertia);
end

%% ---------------------------- free decay ----------------------------- %%
if free_decay == 1
    % Define inputs:
    directory = 'data\NREL_VGOSWEC\freedecay\VGM90';     % current directory
    file = 'all';
    
    opts = pkg.obj.readDataOpt(directory,file);
    opts.as_struct = true;
    %if ~exist('data','var')
    VGM0freedecay = pkg.fun.read_data2(opts);
    %end
    
    fs = 500;
    plotloop = false;
    VGM0freedecay = OSWEC_freedecay(VGM0freedecay,fs,plotloop);
    % TO DO:
    % 1) IMPROVE NATURAL PERIOD ESTIMATE FROM PEAKS NOT FFT (NOT SHARP
    % ENOUGH)
    % 2) IMPLEMENT NL DAMPING
    
    
end
%% ----------------------------- regular ------------------------------- %%
if regularwaves == 1
  %% --------------------- design wave processing ---------------------- %%
  % READ DATA:
    directory = 'data\NREL_VGOSWEC\designwaves\combined';
    file = 'all';
    
    % initialize read data options:
    readdataopts = pkg.obj.readDataOpt(directory,file);
    readdataopts.as_struct = true;
    
    % call read data function:
%     if ~exist('designwaves','var')
        designwaves = pkg.fun.read_data2(readdataopts);
%     end

    % PRE-PROCESSING:
    % define data channels, variable names, and subfields to be pre-processed:
    regularwaves_pre_opts = struct();
    regularwaves_pre_opts.channels = {3,4};
    regularwaves_pre_opts.varnames = {'eta','eta'};
    regularwaves_pre_opts.subfields = {'wp1','wp2'};
    regularwaves_pre_opts.exval_factor = 3;
    
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
    
    % call regular waves pre-processing function:
    designwaves = OSWEC_regularwaves_pre(designwaves,regularwaves_pre_opts,t0,tf,fs,plotloop,verbose);
   
    % POST-PROCESSING:
    % define data channels, variable names, and subfields to be post-processed:
    regularwaves_post_opts.varnames = {'eta','eta'};
    regularwaves_post_opts.subfields = {'wp1','wp2'};
    
    % plot settings
    plotloop = false;
    verbose = true;
    
    % call regular waves post-processing function:
    designwaves = OSWEC_regularwaves_post(designwaves,regularwaves_post_opts,plotloop,verbose);
    
%     save('designwaves.mat','designwaves')
 
  %% ---------------------- model run processing ----------------------- %%
    % READ DATA:
    directory = 'data\NREL_VGOSWEC\regularwaves\VGM45'; % 'data\NREL_OSWEC\OSWEC_regularwaves\5-14-21' 'data\NREL_OSWEC\OSWEC_regularwaves\5-19-21'
    file = 'all';
    
    % initialize read data options:
    readdataopts = pkg.obj.readDataOpt(directory,file);
    readdataopts.as_struct = true;
    
    % call read data function:
%     if ~exist('VGM90','var')
        VGM45 = pkg.fun.read_data2(readdataopts);
%     end

    % PRE-PROCESSING:
    % define data channels, variable names, and subfields to be pre-processed:
    regularwaves_pre_opts = struct();
    regularwaves_pre_opts.channels = {7,9,10,11,12,13,14};
    regularwaves_pre_opts.varnames = {'phi','fx','fy','fz','mx','my','mz'};
    regularwaves_pre_opts.subfields = {'position','forceX','forceY','forceZ','momentX','momentY','momentZ'};
    regularwaves_pre_opts.exval_factor = 5;
    
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
    
    % call regular waves pre-processing function:
    VGM45 = OSWEC_regularwaves_pre(VGM45,regularwaves_pre_opts,t0,tf,fs,plotloop,verbose);
    
    % POST-PROCESSING:
    % define data channels, variable names, and subfields to be post-processed:
    regularwaves_post_opts.varnames = {'phi','fx','fz','my'};
    regularwaves_post_opts.subfields = {'position','forceX','forceZ','momentY'};
    
   % plot settings
    plotloop = false;
    verbose = true;
    
    % call regular waves post-processing function:
   VGM45 = OSWEC_regularwaves_post(VGM45,regularwaves_post_opts,plotloop,verbose);
   
%    save('VGM45_regularwaves.mat','VGM45')
    
  %% -------------------------- analysis ----------------------------- %%
   OSWEC_loadpaths(VGM0,{'forceX','forceZ'},{'fx','fz'})
   
   
   
   

  %% ---------------------------- plots ------------------------------ %%
   load('designwaves.mat')
   load('VGM0_regularwaves.mat')
   load('VGM10_regularwaves.mat')
   load('VGM20_regularwaves.mat')
   load('VGM45_regularwaves.mat')
   load('VGM90_regularwaves.mat')
   
   k = wave_disp(2*pi./designwaves.Results.eta_wp2.T_mean,1,9.81,0.001);
   phi_norm = 1;
   RAO_norm = 2*pi/180./(k.*designwaves.Results.eta_wp2.A_pks_mean);
   fx_norm = 1;
   fz_norm = 1;
   my_norm = 1;
   
   figure
   errorbar(designwaves.Results.eta_wp2.T_mean,designwaves.Results.eta_wp2.A_pks_mean,designwaves.Results.eta_wp2.A_pks_std,...
       '.','CapSize',0); hold on
   ylabel('wave amplitude (m)')
   xlabel('period (s)')
   
   figure; hold on
   errorbar(VGM0.Results.phi.T_mean,VGM0.Results.phi.A_fft_mean.*phi_norm,VGM0.Results.phi.A_fft_std.*phi_norm,':o',...
       'DisplayName','VGM0')
   errorbar(VGM10.Results.phi.T_mean,VGM10.Results.phi.A_fft_mean.*phi_norm,VGM10.Results.phi.A_fft_std.*phi_norm,':o',...
       'DisplayName','VGM10')
   errorbar(VGM20.Results.phi.T_mean,VGM20.Results.phi.A_fft_mean.*phi_norm,VGM20.Results.phi.A_fft_std.*phi_norm,':o',...
       'DisplayName','VGM20')
   errorbar(VGM45.Results.phi.T_mean,VGM45.Results.phi.A_fft_mean.*phi_norm,VGM45.Results.phi.A_fft_std.*phi_norm,':o',...
       'DisplayName','VGM45')
   errorbar(VGM90.Results.phi.T_mean,VGM90.Results.phi.A_fft_mean.*phi_norm,VGM90.Results.phi.A_fft_std.*phi_norm,':o',...
       'DisplayName','VGM90')
   legend('Location','northwest')
   ylabel('\phi (deg)')
   xlabel('period (s)')
   
   figure; hold on
   errorbar(VGM0.Results.phi.T_mean,VGM0.Results.phi.A_fft_mean.*RAO_norm,VGM0.Results.phi.A_fft_std.*RAO_norm,':o',...
       'DisplayName','VGM0')
   errorbar(VGM10.Results.phi.T_mean,VGM10.Results.phi.A_fft_mean.*RAO_norm,VGM10.Results.phi.A_fft_std.*RAO_norm,':o',...
       'DisplayName','VGM10')
   errorbar(VGM20.Results.phi.T_mean,VGM20.Results.phi.A_fft_mean.*RAO_norm,VGM20.Results.phi.A_fft_std.*RAO_norm,':o',...
       'DisplayName','VGM20')
   errorbar(VGM45.Results.phi.T_mean,VGM45.Results.phi.A_fft_mean.*RAO_norm,VGM45.Results.phi.A_fft_std.*RAO_norm,':o',...
       'DisplayName','VGM45')
   errorbar(VGM90.Results.phi.T_mean,VGM90.Results.phi.A_fft_mean.*RAO_norm,VGM90.Results.phi.A_fft_std.*RAO_norm,':o',...
       'DisplayName','VGM90')
   legend('Location','northwest')
   ylabel('\phi/(kA)')
   xlabel('period  (s)')
   
%    figure; hold on
%    errorbar(VGM0.Results.fx.T_mean,VGM0.Results.fx.A_pks_mean.*fx_norm,VGM0.Results.fx.A_pks_std.*fx_norm,':o',...
%        'DisplayName','VGM0')
%    errorbar(VGM10.Results.fx.T_mean,VGM10.Results.fx.A_pks_mean.*fx_norm,VGM10.Results.fx.A_pks_std.*fx_norm,':o',...
%        'DisplayName','VGM10')
%    errorbar(VGM20.Results.fx.T_mean,VGM20.Results.fx.A_pks_mean.*fx_norm,VGM20.Results.fx.A_pks_std.*fx_norm,':o',...
%        'DisplayName','VGM20')
%    errorbar(VGM45.Results.fx.T_mean,VGM45.Results.fx.A_pks_mean.*fx_norm,VGM45.Results.fx.A_pks_std.*fx_norm,':o',...
%        'DisplayName','VGM45')
%    errorbar(VGM90.Results.fx.T_mean,VGM90.Results.fx.A_pks_mean.*fx_norm,VGM90.Results.fx.A_pks_std.*fx_norm,':o',...
%        'DisplayName','VGM90')
%    legend('Location','northwest')
%    ylabel('Fx (N)')
%    xlabel('period (s)')
   
      figure; hold on
   errorbar(VGM0.Results.fx.T_mean,VGM0.Results.fx.A_fft_mean.*fx_norm,VGM0.Results.fx.A_fft_std.*fx_norm,':o',...
       'DisplayName','VGM0')
   errorbar(VGM10.Results.fx.T_mean,3*VGM10.Results.fx.A_fft_mean.*fx_norm,VGM10.Results.fx.A_fft_std.*fx_norm,':o',...
       'DisplayName','VGM10')
   errorbar(VGM20.Results.fx.T_mean,3*VGM20.Results.fx.A_fft_mean.*fx_norm,VGM20.Results.fx.A_fft_std.*fx_norm,':o',...
       'DisplayName','VGM20')
   errorbar(VGM45.Results.fx.T_mean,VGM45.Results.fx.A_fft_mean.*fx_norm,VGM45.Results.fx.A_fft_std.*fx_norm,':o',...
       'DisplayName','VGM45')
   errorbar(VGM90.Results.fx.T_mean,VGM90.Results.fx.A_fft_mean.*fx_norm,VGM90.Results.fx.A_fft_std.*fx_norm,':o',...
       'DisplayName','VGM90')
   legend('Location','northwest')
   ylabel('Fx (N)')
   xlabel('period (s)')
   
   figure; hold on
   errorbar(VGM0.Results.fz.T_mean,VGM0.Results.fz.A_fft_mean.*fz_norm,VGM0.Results.fz.A_fft_std.*fz_norm,':o',...
       'DisplayName','VGM0')
   errorbar(VGM10.Results.fz.T_mean,VGM10.Results.fz.A_fft_mean.*fz_norm,VGM10.Results.fz.A_fft_std.*fz_norm,':o',...
       'DisplayName','VGM10')
   errorbar(VGM20.Results.fz.T_mean,VGM20.Results.fz.A_fft_mean.*fz_norm,VGM20.Results.fz.A_fft_std.*fz_norm,':o',...
       'DisplayName','VGM20')
   errorbar(VGM45.Results.fz.T_mean,VGM45.Results.fz.A_fft_mean.*fz_norm,VGM45.Results.fz.A_fft_std.*fz_norm,':o',...
       'DisplayName','VGM45')
   errorbar(VGM90.Results.fz.T_mean,VGM90.Results.fz.A_fft_mean.*fz_norm,VGM90.Results.fz.A_fft_std.*fz_norm,':o',...
       'DisplayName','VGM90')
   legend('Location','northwest')
   ylabel('Fz (N)')
   xlabel('period (s)')
   
   figure; hold on
   errorbar(VGM0.Results.my.T_mean,VGM0.Results.my.A_fft_mean.*my_norm,VGM0.Results.my.A_fft_std.*my_norm,':o',...
       'DisplayName','VGM0')
   errorbar(VGM10.Results.my.T_mean,VGM10.Results.my.A_fft_mean.*my_norm,VGM10.Results.my.A_fft_std.*my_norm,':o',...
       'DisplayName','VGM10')
   errorbar(VGM20.Results.my.T_mean,VGM20.Results.my.A_fft_mean.*my_norm,VGM20.Results.my.A_fft_std.*my_norm,':o',...
       'DisplayName','VGM20')
   errorbar(VGM45.Results.my.T_mean,VGM45.Results.my.A_fft_mean.*my_norm,VGM45.Results.my.A_fft_std.*my_norm,':o',...
       'DisplayName','VGM45')
   errorbar(VGM90.Results.my.T_mean,VGM90.Results.my.A_fft_mean.*my_norm,VGM90.Results.my.A_fft_std.*my_norm,':o',...
       'DisplayName','VGM90')
   legend('Location','northwest')
   ylabel('My (N-m)')
   xlabel('period (s)')
   
   figure
   errorbar(VGM90.Results.phi.T_mean,VGM90.Results.phi.A_pks_mean,VGM90.Results.phi.A_pks_std,'o',...
       'DisplayName','VGM90 pks'); hold on
   errorbar(VGM90.Results.phi.T_mean,VGM90.Results.phi.A_fft_mean,VGM90.Results.phi.A_fft_std,'o',...
       'DisplayName','VGM90 fft');
   legend('Location','northwest')
   ylabel('\phi (deg)')
   xlabel('period (s)')
   

   
   figure; hold on
   
   
end

%% --------------------------- Subfunctions ---------------------------- %%

function [k] = wave_disp(w,h,g,allowable_error)
k_n = w.^2/g; % make a first guess of k using deep water approximation
err = ones(size(w)); % initialize error

% iterate until max element-wise error is reduced to allowable error:
while max(err) > allowable_error
    w_n = sqrt(g*k_n.*tanh(k_n*h));  % compute new w
    k_n = w.^2./(g*tanh(k_n*h));     % compute new k
    err = abs(w_n - w)./w;           % compute error
end
k = k_n; % assign output as final k

end