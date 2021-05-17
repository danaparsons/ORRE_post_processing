%% ------------------------------ Header ------------------------------- %%
% Filename:     NREL_OSWEC.m
% Description:  NREL OSWEC data post-processing
% Author:       J. Davis
% Created on:   5-13-21
% Last updated: 5-13-21 by J. Davis
%% ------------------------------ Inputs ------------------------------- %%

dry_inertia = 0;
free_decay = 0;
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
    directory = 'data\NREL_OSWEC\OSWEC_freedecay\';     % current directory
    file = 'all';
    
    opts = pkg.obj.readDataOpt(directory,file);
    opts.as_struct = true;
    %if ~exist('data','var')
    data = pkg.fun.read_data2(opts);
    %end
    data = OSWEC_regularwaves(data,false);
end
%% ---------------------------- regular ----------------------------- %%
% Define inputs:
directory = 'data\NREL_OSWEC\OSWEC_regularwaves\';     % current directory
file = 'all';

opts = pkg.obj.readDataOpt(directory,file);
opts.as_struct = true;
%if ~exist('data','var')
    data = pkg.fun.read_data2(opts);
%end
data = OSWEC_regularwaves(data,true);