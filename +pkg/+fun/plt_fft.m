function [f,P1,dominant_periods,Fs,fft_fields] = plt_fft(t,y,varargin)
%% ------------------------------ Header ------------------------------- %%
% Filename:     plt_fft.m    
% Description:  ORRE Post Processing Program function to plot fft.
% Authors:      D. Lukas and J. Davis
% Created on:   7-9-20
% Last updated: 4-28-21 by J. Davis
%% ------------------------------- Use --------------------------------- %%
% The function <plt_fft.m> is designed to have two call methods:
% (1) Pass the function explicit data arrays:
%
%           plt_fft(data.ch1,data.ch2,OPTIONS...)
%
%   **To access additional function options when using method 1, it is
%     neccessary to skip the third input by inserting an empty array [], 
%     as this optional input is reserved for method 2:
%
%           plt_fft(data.ch1,data.ch2,[],option1,option2...)
%
% (2) Alternatively, pass the complete data object and channel indicators:
%
%           plt_fft(1,2,data,OPTIONS...)
%
%     Which is equivalent to the former. Note that the variable "data"
%     references the data object created upon calling <read_data.m>.
%
% The basic syntax for <plt_fft.m> is as follows:
%
%           plt_fft(t,y)
%
%     Where "t" is the independent variable representing time and "y" is
%     the dependent variable.
%
% The complete call options are as follows:
%
%     [f,P1,dominant_period,Fs] = plt_fft(t,y,data,fs,startTime,endTime)
% 
%     Where "Fs" is the desired sample frequency. More options to come...
%% -------------------------- Handle inputs ---------------------------- %%
[t,y,fs,pkpromfactor,startTime,endTime,data] = handleinputs(t,y,varargin{:});

%% ------------------------ Start of function -------------------------- %%
% Adjust time list according to start and end times:
if ~isempty(startTime) && ~isempty(endTime)
   t0 = startTime; tf = endTime;  
elseif ~isempty(startTime)
   t0 = startTime; tf = t(end);
elseif ~isempty(endTime)
   t0 = t(0); tf = endTime;
else
   t0 = t(1); tf = t(end);
end


t = t(t >= t0 & t <= tf);
y = y(t >= t0 & t <= tf);

if t(end) ~= tf
 x   
end
if t(1) ~= t0
x
end


Y = fft(y);
L = length(y);

if isempty(fs)
    try
        Fs = data.fft.fs;
    catch
        Fs = mean(diff(t))^-1;
    end
else
    Fs = fs;
end 

P2 = abs(Y/L);
P1 = P2(1:round(L/2+1));
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:round(L/2))/L;


% fft_fig = figure;
% semilogx(f,P1) 
% title(['Single-Sided Amplitude Spectrum of ',dependent_varname])
% xlabel('f (Hz)')
% ylabel(['|P1(f)| of ',dependent_varname])

pkprom = pkpromfactor*max(P1);

[pk_fft, loc_fft]= findpeaks(P1,f,'MinPeakProminence',pkprom,'Annotate','extents');
dominant_periods = loc_fft.^-1;
peak_amps = pk_fft;

% if ~isempty(data)
%     data.fft.f = f;
%     data.fft.P = P1;
%     data.fft.dominant_periods = dominant_periods;
%     data.fft.peak_amps = peak_amps;
%     data.fft.fs = Fs;
% end

fft_fields = [];

fft_fields.f = f;
fft_fields.P = P1;
fft_fields.dominant_periods = dominant_periods;
fft_fields.peak_amps = peak_amps;
fft_fields.fs = Fs;

end
%% --------------------------- Subfunctions ---------------------------- %%

function bool = checkdata(x)
   bool = false;
   if isstruct(x)
       bool = true;
   elseif isobject(x)
       bool = true;
   else
       error('Input data is not a structure or dataObject.');
   end
end

function [t,y,fs,pkpromfactor,startTime,endTime,data] = handleinputs(t,y,varargin)
%% Input Parsing
% Return an error if minimum number of required arguments is not satisfied:
if nargin < 2
    error('Not enough inputs.')
end
   
% Define default values for optional input arguments:
default_fs = [];
default_pkpromfactor = 0.15;
default_startTime = [];
default_endTime = [];
default_data = struct([]);
% Create input parser object
p = inputParser;

% Define input types:
addRequired(p,'t');
addRequired(p,'y');
addOptional(p,'fs',default_fs,@isnumeric)
addOptional(p,'pkpromfactor',default_pkpromfactor,@isnumeric)
addOptional(p,'startTime',default_startTime,@isnumeric)
addOptional(p,'endTime',default_endTime,@isnumeric)
addOptional(p,'data',default_data,@checkdata)

% Parse the inputs:
parse(p,t,y,varargin{:});

%%% Assign parsed input variables:

% Optional inputs
fs = p.Results.fs;
pkpromfactor = p.Results.pkpromfactor;
startTime = p.Results.startTime;
endTime = p.Results.endTime;
data  = p.Results.data;

%%% Determine whether "t" and "y" are data arrays or channel indicators:

% Function handle for determining if general numeric input is an integer
isaninteger = @(x)isfinite(x) & x==floor(x);

% Handle time variable input:
% Method 1: input is already an array
if length(t) > 1            
    t  = p.Results.t;
    
% Method 2: Input is a channel indicator
elseif isaninteger(t) == 1  
    if isprop(data,(strcat('ch',num2str(t)))) % Check validity of indicator
        t_ch = strcat('ch',num2str(t));	% Create time channel string
        t = data.(t_ch); % Assign specified data channel
    else % Return error if channel is nonexistent                     
        error('The specified channel does not exist in the data object.')
    end 
    
% Return error if neither method 1 or 2 is used properly  
else 
    error('Required input variable "t" is not properly defined as an array or a specific channel indicator.')
end

% Handle dependent variable input (same as above):
if length(y) > 1
    y  = p.Results.y;
elseif isaninteger(y) == 1
    if isprop(data,(strcat('ch',num2str(y))))
        y_ch = strcat('ch',num2str(y));
        y = data.(y_ch);
    else
        error('The specified channel does not exist in the data object.')
    end
% Return error if neither method 1 or 2 is used properly
else
    error('Required input variable "y" is not properly defined as an array or a specific channel indicator.')
end

% method 2 

if ~isempty(data)
    if isobject(data)
        if ~isprop(data,'fft')
            data.addprop('fft');
        end
    elseif isstruct(data)
        if ~isfield(data,'fft')
            data.fft = [];
        end
    end
end

%%% Create variable name strings for plotting purposes:
% % If method 2 is used, use the map to retrieve channel names:
% if isprop(data,'map')
%     dependent_varname = data.map(y_ch);
% % If method 1 is used, default to generic variable name "y(t)": 
% else
%     dependent_varname = 'y(t)';
% end
% 

end
