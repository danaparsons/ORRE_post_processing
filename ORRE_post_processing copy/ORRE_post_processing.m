%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Header %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     ORRE_post_processing.m
% Description:  ORRE Post Processing Program input file (test)
% Authors:      D. Lukas and J. Davis
% Created on:   6-10-20
% Last updated: 6-17-20 by J. Davis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%

close all % close any open figures

% Define inputs:
directory = "./testdata/";     % current directory
filename = "90_deg_reg_run1.txt";
%filename = "3Decay Test Spring 0Deg_U_WaveID_Freq=0.5Hz Amp=0m ang=0rad__20180412_111119_.txt";
datatype = 1;
     % 1 - user-defined (dataClass)
  
% Call the <read_data.m> function to create an instance of the appropriate
% data class:   
data = pkg.fun.read_data(directory,filename,datatype);

%%% Note:
% The function <read_data.m> is designed to take a variable number of input 
% arguments. The complete call options are as follows:
%
% data = pkg.fun.read_data(data_dir,filename,datatype,ntaglines,nheaderlines,tagformat,headerformat,dataformat,commentstyle)
% 
% Only the first three inputs (data_dir,filename, and datatype) are
% required. The remaining inputs are optional and pertain only to the
% user-defined data class (datatype 1)


%%% Example of calling a function

% test of call method 1: direct input of data arrays
dominant_period = pkg.fun.plt_fft(data.ch1,data.ch2);

% test of call method 2: channel indicators
dominant_period = pkg.fun.plt_fft(1,3,data);

% test of bad calls:
dominant_period = pkg.fun.plt_fft(10,2,data); % returns error for nonexistent channel
dominant_period = pkg.fun.plt_fft(1.1,2,data); % returns error for non-int channel indicator



%%% Plotting example with use of data.map feature:

% Hard-coded:
figure
plot(data.ch1,data.ch2)
xlabel(data.map('ch1'))
ylabel(data.map('ch2'))


% Given the desired channel numbers, this is can be dynamically coded 
% (I think I made that term up) as the following:

% user-defined channels to plot:
n = '1';
m = '2';

figure
plot(data.(strcat('ch',n)),data.(strcat('ch',m)))
xlabel(data.map(strcat('ch',n)))
ylabel(data.map(strcat('ch',m)))


run('+app/ORRE_post_processing_app.m');













%%% deleted stuff saved for later:


% Define data directory (here I have added a \testdata folder with an OSWEC 
% file for testing purposes):
% main_dir = ".";     % current directory
% sub_dir = "/testdata";
% filename = "090Deg_U_WaveID_Reg 1__20180413_105125_.txt";
% data_dir = strcat(main_dir,sub_dir);
% 
% % Provide some input on the type of data:
% datatype = 1;
   
% channeltypes = {'t','wp','wp','wp','wp','wp','strpot','strpot','lc'};
% tagtypes = {'flap_orientation','date','type','run'};
% tagformat = "%s%s%s%d";



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