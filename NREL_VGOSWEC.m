%% ------------------------------ Header ------------------------------- %%
% Filename:     NREL_OSWEC.m
% Description:  NREL OSWEC data post-processing
% Author:       J. Davis
% Created on:   5-13-21
% Last updated: 5-13-21 by J. Davis
%% ------------------------------ Inputs ------------------------------- %%
dry_inertia = 0;
free_decay = 1;
regularwaves = 1;
%% ---------------------------- dry inertia ---------------------------- %%
if dry_inertia == 1
    % Define inputs:
%     directory = 'data\NREL_VGOSWEC\inertia\body_w_springs';     % current directory
    directory = 'data\NREL_VGOSWEC\inertia\body_only';
    file = 'all';
    
    opts = pkg.obj.readDataOpt(directory,file);
    opts.as_struct = true;
    inertia = pkg.fun.read_data2(opts);
    dataopts.fs = 500;
    dataopts.phi_ch = 2;
    dataopts.minwidth = 0.1; % width (in seconds) below which peaks are considered noise
    dataopts.min_period = 0.1;
    dataopts.max_period = 2;
    
    plotloop = false;
    inertia_body_only = OSWEC_freedecay(inertia,dataopts,plotloop);
    
    %     save('inertia_body_only.mat','inertia_body_only')
    
    %     out = OSWEC_inertia(inertia);

end

%% ---------------------------- free decay ----------------------------- %%
if free_decay == 1
    % Define inputs:
    directory = 'data/NREL_VGOSWEC/freedecay/VGM20/';     % current directory
    file = 'all';
    
    opts = pkg.obj.readDataOpt(directory,file);
    opts.as_struct = true;
    %if ~exist('data','var')
    freedecay = pkg.fun.read_data2(opts);
    %end
    
    dataopts = [];
    dataopts.fs = 500;
    dataopts.phi_ch = 6;
    dataopts.min_width = 0.1; % width (in seconds) below which peaks are considered noise
%     dataopts.min_period = 0.1;
%     dataopts.max_period = 6;
    dataopts.phi0_pkpromfactor = 0.40; % threshold, as a fraction of the maximum, for which peaks should be considered for finding phi0
    dataopts.fft_pkpromfactor = 0.15; % threshold (as proportion of peak FFT value) below which additional peaks are considered insignificant
    dataopts.pks_pkpromfactor = 0.001; % threshold, as a fraction of the maximum, for which peaks should be considered for identifying Tn_pks and damping
    dataopts.max_duration = 15; % maximum free decay duration
    plotloop = true;

    VGM20_freedecay = OSWEC_freedecay(freedecay,dataopts,plotloop);

    %     save('VGM90_freedecay.mat','VGM90_freedecay')

    
end
    
%     opts = pkg.obj.readDataOpt(directory,file);
%     opts.as_struct = true;
%     %if ~exist('data','var')
%     VGM0freedecay = pkg.fun.read_data2(opts);
%     %end
%     
%     fs = 500;
%     plotloop = false;
%     VGM0freedecay = OSWEC_freedecay(VGM0freedecay,fs,plotloop);
%     % TO DO:
%     % 1) IMPROVE NATURAL PERIOD ESTIMATE FROM PEAKS NOT FFT (NOT SHARP
%     % ENOUGH)
%     % 2) IMPLEMENT NL DAMPING
%     
    
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
 
  %% -------------------------- regular wave --------------------------- %%

    % READ DATA:
    directory = 'data/NREL_VGOSWEC/waveenergyprize/VGM90/'; % 'data\NREL_OSWEC\OSWEC_regularwaves\5-14-21' 'data\NREL_OSWEC\OSWEC_regularwaves\5-19-21'
    file = 'all';
    
    % initialize read data options:
    readdataopts = pkg.obj.readDataOpt(directory,file);
    readdataopts.as_struct = true;
    
    % call read data function:
%     if ~exist('VGM90','var')
        VGM90 = pkg.fun.read_data2(readdataopts);
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
    VGM0 = OSWEC_regularwaves_pre(VGM0,regularwaves_pre_opts,t0,tf,fs,plotloop,verbose);
    
    % POST-PROCESSING:
    % define data channels, variable names, and subfields to be post-processed:
    regularwaves_post_opts.varnames = {'phi','fx','fz','my'};
    regularwaves_post_opts.subfields = {'position','forceX','forceZ','momentY'};
    
   % plot settings
    plotloop = false;
    verbose = true;
    
    % call regular waves post-processing function:
   waveenergyprize_VGM0 = OSWEC_regularwaves_post(VGM0,regularwaves_post_opts,plotloop,verbose);
   
    save('waveenergyprize_VGM0.mat','waveenergyprize_VGM0')
    
  %% ------------------------ wave energy prize ------------------------ %%
% READ DATA:
directory = 'VGOSWECwaveenergyprize/VGM0/'; 
file = 'all';

% initialize read data options:
readdataopts = pkg.obj.readDataOpt(directory,file);
readdataopts.as_struct = true;

VGM0 = pkg.fun.read_data2(readdataopts);

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
VGM0 = OSWEC_regularwaves_pre(VGM0,regularwaves_pre_opts,t0,tf,fs,plotloop,verbose);

% POST-PROCESSING:
% define data channels, variable names, and subfields to be post-processed:
regularwaves_post_opts.varnames = {'phi','fx','fz','my'};
regularwaves_post_opts.subfields = {'position','forceX','forceZ','momentY'};

% plot settings
plotloop = false;
verbose = true;

% call regular waves post-processing function:
waveenergyprize_VGM0 = OSWEC_regularwaves_post(VGM0,regularwaves_post_opts,plotloop,verbose);

% save('waveenergyprize_VGM0.mat','waveenergyprize_VGM0')

  %% -------------------------- analysis ----------------------------- %%
  load('data\NREL_VGOSWEC\_processed\inertia_body_only.mat') 
  load('data\NREL_VGOSWEC\_processed\inertia_body_w_springs.mat') 
  
  % load paths:
%   OSWEC_loadpaths(VGM0,{'forceX','forceZ'},{'fx','fz'})
   
  % external torsional spring constant:
   g = 9.81;     % (m/s^2)
   d = 0.268732; %  from hang test (m)
   M = 6.676;    % body + ballast (kg)
   C_yy = M*g*d;
   I_yy = C_yy/inertia_body_only.results.wn_mean^2; % kg-m^2
   C_ext = I_yy*(inertia_body_w_springs.results.wn_mean)^2 - C_yy;
   
   

  %% ---------------------------- plots ------------------------------ %%
   load('data\NREL_VGOSWEC\_processed\designwaves.mat')
   load('data\NREL_VGOSWEC\_processed\regularwaves_VGM0.mat')
   load('data\NREL_VGOSWEC\_processed\regularwaves_VGM10.mat')
   load('data\NREL_VGOSWEC\_processed\regularwaves_VGM20.mat')
   load('data\NREL_VGOSWEC\_processed\regularwaves_VGM45.mat')
   load('data\NREL_VGOSWEC\_processed\regularwaves_VGM90.mat')
   
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