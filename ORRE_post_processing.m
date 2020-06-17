%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     ORRE_post_processing.m
% Description:  ORRE Post Processing Program input file (test)
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 6-17-20 by J. Davis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%

% Define data directory (here I have added a \testdata folder with an OSWEC 
% file for testing purposes):
main_dir = ".";     % current directory
sub_dir = "/testdata";
filename = "090Deg_U_WaveID_Reg 1__20180413_105125_.txt";
data_dir = strcat(main_dir,sub_dir);

% Provide some input on the type of data:
datatype = 1;
    % 0 - test data
    % 1 - user-defined (dataClass)
    % 2 - signal (signalClass)    
channeltypes = {'t','wp','wp','wp','wp','wp','strpot','strpot','lc'};
tagtypes = {'flap_orientation','date','type','run'};
tagformat = "%s%s%s%d";

% Call the <read_data.m> function to create an instance of the appropriate
% data class:

data = pkg.fun.read_data(data_dir,filename,datatype,channeltypes,tagtypes,tagformat);

%%% Note: add a breakpoint here at line 25, run the program, and "step in"
%%% at this line to enter and follow the read_data function








%%% deleted stuff saved for later:

% fs = 128;
% f = 2; % hz
% tf = 2*f^-1;
% n = fs*tf;
% t = linspace(0,tf-fs^-1,n);
% x = sin(2*pi*f*t);
% 
% signal = pkg.obj.signalClass(t,x); % test constructor without period T
% % signal = pkg.obj.signalClass(t,x,f^-1) % with T 
% 
% plot(signal.t,signal.x,...
%     signal.t,signal.x,'o'); hold on
% plot(signal.t+tf,signal.x,...
%     signal.t+tf,signal.x,'o')
% 
% signal.T = pkg.fun.plt_fft(signal.t,signal.x); % test without providing fs
% 
% 
% signal
% 
% % signal.T = pkg.fun.plt_fft(signal.t,signal.x,fs) % with fs