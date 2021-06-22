%% ------------------------------ Header ------------------------------- %%
% Filename:     NREL_OSWEC.m
% Description:  NREL OSWEC data post-processing
% Author:       J. Davis
% Created on:   5-13-21
% Last updated: 5-13-21 by J. Davis
%% ------------------------------ Inputs ------------------------------- %%
dry_inertia = 0;
free_decay = 1;
regularwaves = 0;
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
%     directory = 'data\NREL_OSWEC\OSWEC_regularwaves\5-14-21';
    %directory = 'data\NREL_OSWEC\OSWEC_regularwaves\5-19-21';
    directory = 'C:\Users\orre2\Desktop\NREL_OSWEC\VGOSWEC\VGOSWEC_regularwaves\VGM0';
    file = 'all';
    
    close all
    
    opts = pkg.obj.readDataOpt(directory,file);
    opts.as_struct = true;
    
%     if ~exist('data','var')
        data = pkg.fun.read_data2(opts);
%     end
    
    channels = {7,9,10,11,12,13,14};
    varnames = {'phi','fx','fy','fz','mx','my','mz'};
    subfields = {'position','forceX','forceY','forceZ','momentX','momentY','momentZ'};
    t0 = 10;
    tf = 40;
    fs = 500;
    plotloop = true;
    % fcutoff = 4to5 x  
    data = OSWEC_regularwaves_pre(data,channels,varnames,subfields,t0,tf,fs,plotloop);
        data.T13_A16p75_B2_8.pos.filter.f_cutoff  = 2; data.T13_A16p75_B2_8.filter.order  = 4;
        data.T13_A16p75_B2_14.pos.filter.f_cutoff = 2; data.T13_A16p75_B2_14.filter.order = 4;
    % rerun with modified filters:
    data = OSWEC_regularwaves_pre(data,channels,varnames,subfields,t0,tf,fs,plotloop);
    
    % TO DO:
    % 1) IMPLEMENT PROPER MEAN SUBTRACTION 
    %       (see https://www.mathworks.com/help/matlab/data_analysis/detrending-data.html)
    % 2) CHOP DATA AT A FINITE NUMBER OF CYCLES FOR FINAL FFT
    % 3) REPEAT FOR REMAINING SIGNALS! -> DONE
    
    
end