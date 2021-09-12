%% ------------------------------ Header ------------------------------- %%
% Filename:     NREL_VGOSWEC_waveenergyprize.m
% Description:  NREL VGOSWEC wave energy prize data post-processing
% Author:       J. Davis
% Created on:   8-12-21
% Last updated: 8-12-21 by J. Davis

%% ---------------------- model run processing ----------------------- %%

%%% INSTRUCTIONS: this script loads the raw data, processes it, and saves
%%% it as a .mat file. The script needs to be run for each VG configuration
%%% (0,10,20,45,90). It is currently configured for VGM0. Run this, and
%%% then simply replace 'VGM0' with 'VGM10', then 'VGM20', and so on. It
%%% will probably be easiest to do a find and replace operation. Otherwise,
%%% it appears in 8 places below.

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

save('waveenergyprize_VGM0.mat','waveenergyprize_VGM0')


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