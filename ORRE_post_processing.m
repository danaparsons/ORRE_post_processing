main_dir = 'C:\Users\jacob\Documents\ORRE_Offline\NREL TCF\OSWEC\W2 Testing\From Mike\WEC testing';
sub_dir = '\Labview DATA\Waves 90Deg';
filename = '090Deg_U_WaveID_Reg 1__20180413_105125_.txt';
% main_dir = '.\testdata';
% sub_dir = '';
% filename = 'testdata1.txt';

datatype = 1;
    % 0 - test data
    % 1 - regular wave response

channeltypes = {'t','wp','wp','wp','wp','wp','strpot','strpot','lc'};
tagtypes = {'flap_orientation','date','type','run'};
data_dir = strcat(main_dir,sub_dir);

data = pkg.fun.read_data(data_dir,filename,datatype,channeltypes,tagtypes);



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