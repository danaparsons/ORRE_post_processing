%% ------------------------------ Header ------------------------------- %%
% Filename:     NREL_OSWEC_waveenergyprize.m
% Description:  NREL OSWEC wave energy prize data post-processing
% Author:       J. Davis
% Created on:   8-12-21
% Last updated: 8-12-21 by J. Davis
%%-----------------------------------------------------------------------%%
%%% INSTRUCTIONS: this script is for the OSWEC with no springs, referred to as
%%% 'column' here (to differentiate from the no column case), and the OSWEC
%%% with springs (column with springs).
%% OSWEC, column and no springs


%READ DATA:
%  directory = 'OSWECwaveenergyprize/column/'; % file = 'all';
% 
% % initialize read data options:
% readdataopts = pkg.obj.readDataOpt(directory,file);
% readdataopts.as_struct = true;
% 
% column = pkg.fun.read_data2(readdataopts);
% 
% % PRE-PROCESSING:
% % define data channels, variable names, and subfields to be pre-processed:
% regularwaves_pre_opts = struct();
% regularwaves_pre_opts.channels = {7,9,10,11,12,13,14};
% regularwaves_pre_opts.varnames = {'phi','fx','fy','fz','mx','my','mz'};
% regularwaves_pre_opts.subfields = {'position','forceX','forceY','forceZ','momentX','momentY','momentZ'};
% regularwaves_pre_opts.exval_factor = 5;
% 
% % initialize filters for each subfield:
% filtopts = struct();
% filtopts.type = repmat({'butter'},1,length(regularwaves_pre_opts.subfields));
% filtopts.subtype = repmat({'low'},1,length(regularwaves_pre_opts.subfields));
% filtopts.order = {4,4,4,4,4,4,4};
% filtopts.cutoff_margin = {5,5,5,5,5,5,5}; % filtopts.cutoff_margin = {3,[],[],[],[],[],[]}; % filtopts.f_cutoff = {[],10,10,10,10,10,10};
% regularwaves_pre_opts.filters = pkg.fun.init_filters(filtopts);
% 
% % specify start and end times; sampling frequency:
% t0 = 10;
% tf = 40;
% fs = 500;
% 
% % other settings
% plotloop = false;
% verbose = true;
% 
% % call regular waves pre-processing function:
% column = OSWEC_regularwaves_pre(column,regularwaves_pre_opts,t0,tf,fs,plotloop,verbose);
% 
% % POST-PROCESSING:
% % define data channels, variable names, and subfields to be post-processed:
% regularwaves_post_opts.varnames = {'phi','fx','fz','my'};
% regularwaves_post_opts.subfields = {'position','forceX','forceZ','momentY'};
% 
% % plot settings
% plotloop = false;
% verbose = true;
% 
% % call regular waves post-processing function:
% waveenergyprize_c = OSWEC_regularwaves_post(column,regularwaves_post_opts,plotloop,verbose);
% 
% save('waveenergyprize_column.mat','waveenergyprize_c')
% clear all;
%% OSWEC, column with springs
% READ DATA:
directory = 'OSWECwaveenergyprize/column_w_springs/'; 
file = 'all';

% initialize read data options:
readdataopts = pkg.obj.readDataOpt(directory,file);
readdataopts.as_struct = true;

column_w_springs = pkg.fun.read_data2(readdataopts);

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
column_w_springs = OSWEC_regularwaves_pre(column_w_springs,regularwaves_pre_opts,t0,tf,fs,plotloop,verbose);

% POST-PROCESSING:
% define data channels, variable names, and subfields to be post-processed:
regularwaves_post_opts.varnames = {'phi','fx','fz','my'};
regularwaves_post_opts.subfields = {'position','forceX','forceZ','momentY'};
% 
% plot settings
plotloop = false;
verbose = true;

% call regular waves post-processing function:
waveenergyprize_cws = OSWEC_regularwaves_post(column_w_springs,regularwaves_post_opts,plotloop,verbose);

save('waveenergyprize_column_w_springs.mat','waveenergyprize_cws')

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