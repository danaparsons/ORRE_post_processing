%startingFolder1 = 'C:\Users\Mike\Google Drive\GRAD\WAVE\Research\W2 testing\WEC testing\Optical Tracking';
% if ~exist(startingFolder1, 'dir')
% 	% If that folder doesn't exist, just start in the current folder.
% 	startingFolder1 = pwd;
% end

close all

startingFolder1 = [pwd];

defaultFileName1 = fullfile(startingFolder1, '.txt');
[starting_file, folder] = uigetfile(defaultFileName1, 'Select a mat file');
if starting_file == 0
	% User clicked the Cancel button.
	return;
end

data_file = starting_file;
i = 1;

full_file = fullfile(folder, data_file);
data = readtable(full_file);
data.Properties.VariableNames = {'Time','East','West'};

% rm first and last 30s
data(data.Time <= 30,:) = [];
data(data.Time>= data.Time(end)-30,:) = [];

[pk_E, loc_E]= findpeaks(data.East);
[pk_W, loc_W]= findpeaks(data.West);

mean_amp_E = mean(pk_E(pk_E>0)) - mean(data.East);
mean_amp_W = mean(pk_W(pk_W>0)) - mean(data.West);

hold on
plot(data.Time,data.East);
%plot(data.Time(loc_E),pk_E,'o')
plot(data.Time,data.West);
%plot(data.Time(loc_W),pk_W,'o')
yline(mean_amp_E,'r','LineWidth',2);
yline(mean_amp_W,'LineWidth',2);
yline(mean(data.East),'r','--','LineWidth',2);
yline(mean(data.West),'--','LineWidth',2);

Y = fft(data.East);
L = length(data.East);
Fs = mean(diff(data.Time))^-1;
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
fft_fig = figure;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

[pk_fft, loc_fft]= findpeaks(P1,f);
wave_period = loc_fft(pk_fft == max(pk_fft))^-1;

disp(['For data file ',num2str(starting_file),', the mean East probe wave amplitude is ', ...
    num2str(mean_amp_E,'%.3f'),' m, and the mean West probe amplitude is ',num2str(mean_amp_W,'%.3f'),' m.',newline,...
    'The period of the wave is ',num2str(wave_period,'%.2f'),' s.'])

% while exist(fullfile(folder, data_file), 'file')
% 
% full_file = fullfile(folder, data_file);
%     
% data = readtable(full_file);
% 
% data.Properties.VariableNames = {'Time','East','West'};;
% 
% hold on
% plot(data.Time,data.East)
% plot(data.Time,data.West)
% 
% data_file = strcat('Run',num2str(i+1),'.txt')
% i = i+1
% end
% storedStructure1 = load(fullFileName1);
% names = fieldnames(storedStructure1);