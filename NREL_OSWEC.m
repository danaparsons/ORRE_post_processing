%% ------------------------------ Header ------------------------------- %%
% Filename:     NREL_OSWEC.m
% Description:  NREL OSWEC data post-processing
% Author:       J. Davis
% Created on:   5-13-21
% Last updated: 5-13-21 by J. Davis
%% ---------------------------- dry inertia ---------------------------- %%

% Define inputs:
directory = 'data\NREL_OSWEC\inertia\body_w_ballast';     % current directory
file = 'all';

opts = pkg.obj.readDataOpt(directory,file);
opts.as_struct = true;
inertia = pkg.fun.read_data2(opts);

%          out = OSWEC_inertia(inertia);

dataopts.fs = 500;
dataopts.phi_ch = 2;
dataopts.min_width = 0.1; % width (in seconds) below which peaks are considered noise
dataopts.min_period = 0.1;
dataopts.max_period = 2;
dataopts.phi0_pkpromfactor = 0.25; % threshold, as a fraction of the maximum, for which peaks should be considered
dataopts.fft_pkpromfactor = 0.15; % threshold (as proportion of peak FFT value) below which additional peaks are considered insignificant
dataopts.pks_pkpromfactor = 0.15; % threshold, as a fraction of the maximum, for which peaks should be considered for identifying Tn_pks and damping
plotloop = true;
inertia_body_w_ballast = pkg.fun.OSWEC_freedecay(inertia,dataopts,plotloop);

%     save('inertia_body_w_ballast.mat','inertia_body_w_ballast')

%% ---------------------------- free decay ----------------------------- %%

% Define inputs:
directory = 'data\NREL_OSWEC\freedecay\column';     % current directory
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
dataopts.min_period = 0.1;
dataopts.max_period = 6;
dataopts.phi0_pkpromfactor = 0.75; % threshold, as a fraction of the maximum, for which peaks should be considered for finding phi0
dataopts.fft_pkpromfactor = 0.15; % threshold (as proportion of peak FFT value) below which additional peaks are considered insignificant
dataopts.pks_pkpromfactor = 0.05; % threshold, as a fraction of the maximum, for which peaks should be considered for identifying Tn_pks and damping
%     dataopts.max_duration = 8; % maximum free decay duration
plotloop = true;

freedecay_cws = pkg.fun.OSWEC_freedecay(freedecay,dataopts,plotloop);

%     save('freedecay_column_w_springs.mat','freedecay_cws')

%% ---------------------- design wave processing ----------------------- %%
% READ DATA:
% directory = 'data\NREL_OSWEC\designwaves\column_w_springs';
directory = 'data\NREL_OSWEC\designwaves\column';
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
designwaves_c = OSWEC_regularwaves_post(designwaves,regularwaves_post_opts,plotloop,verbose);

%     save('designwaves_column.mat','designwaves_c')

%% -------------------------- regular waves ---------------------------- %%
% READ DATA:
directory = 'data\NREL_OSWEC\regularwaves\column_w_springs';
file = 'all';

% initialize read data options:
readdataopts = pkg.obj.readDataOpt(directory,file);
readdataopts.as_struct = true;

% call read data function:
regularwaves = pkg.fun.read_data2(readdataopts);

% PRE-PROCESSING:
% define data channels, variable names, and subfields to be pre-processed:
regularwaves_pre_opts = struct();
regularwaves_pre_opts.channels = {7,9,11,13};
regularwaves_pre_opts.varnames = {'phi','fx','fz','my'};
regularwaves_pre_opts.subfields = {'position','forceX','forceZ','momentY'};
regularwaves_pre_opts.exval_factor = 5;
regularwaves_pre_opts.min_period = 0.5;

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
regularwaves = pkg.fun.OSWEC_regularwaves_pre(regularwaves,regularwaves_pre_opts,t0,tf,fs,plotloop,verbose);

% POST-PROCESSING:
% define data channels, variable names, and subfields to be post-processed:
regularwaves_post_opts.varnames = {'phi','fx','fz','my'};
regularwaves_post_opts.subfields = {'position','forceX','forceZ','momentY'};

% plot settings
plotloop = false;
verbose = true;

% call regular waves post-processing function:
regularwaves_cws= pkg.fun.OSWEC_regularwaves_post(regularwaves,regularwaves_post_opts,plotloop,verbose);

%     save('regularwaves_column_w_springs_updated.mat','regularwaves_cws')

%% ------------------------- wave energy prize ------------------------- %%

directory = 'data/NREL_OSWEC/waveenergyprize/column_w_springs/'; %
file = 'all';

% initialize read data options:
readdataopts = pkg.obj.readDataOpt(directory,file);
readdataopts.as_struct = true;

wep = pkg.fun.read_data2(readdataopts);

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
wep = pkg.fun.OSWEC_regularwaves_pre(wep,regularwaves_pre_opts,t0,tf,fs,plotloop,verbose);

% POST-PROCESSING:
% define data channels, variable names, and subfields to be post-processed:
regularwaves_post_opts.varnames = {'phi','fx','fz','my'};
regularwaves_post_opts.subfields = {'position','forceX','forceZ','momentY'};

% plot settings
plotloop = false;
verbose = true;

% call regular waves post-processing function:
waveenergyprize_cws = pkg.fun.OSWEC_regularwaves_post(wep,regularwaves_post_opts,plotloop,verbose);

% save('waveenergyprize_column_w_springs.mat','waveenergyprize_cws')

%% ----------------------------- analysis ------------------------------ %%
%    OSWEC_loadpaths(column,{'forceX','forceZ'},{'fx','fz'})

load('data\NREL_OSWEC\_processed\inertia_body_w_ballast.mat')
load('data\NREL_OSWEC\_processed\inertia_body_w_ballast_and_springs.mat')

% load paths:
%   OSWEC_loadpaths(VGM0,{'forceX','forceZ'},{'fx','fz'})

% external torsional spring constant:
g = 9.81;     % (m/s^2)
d = 0.18; %  from hang test (m)
M = 13.49;    % body + ballast (kg)
C_yy = M*g*d;
I_yy = C_yy/inertia_body_w_ballast.results.wn_mean^2; % kg-m^2
C_ext = I_yy*(inertia_body_w_ballast_and_springs.results.wn_mean)^2 - C_yy;

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