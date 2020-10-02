function [dominant_period] = plt_wavelet(t,y,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Header %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     plt_wavelet.m    
% Description:  ORRE Post Processing Program function: laplace transform.
% Authors:      D. Lukas and J. Davis
% Created on:   8-05-20
% Last updated: 8-07-20 by D. Lukas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Notes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Return an error if minimum number of required arguments is not satisfied:
if nargin < 2
    error('Not enough inputs.')
end
   
% Define default values for optional input arguments:
default_data = [];
default_fs = [];

% Create input parser object
p = inputParser;

% Define valid input types:
% valid_datatypes = @(x) mustBeMember(x,[0,1,2]); % only accept valid datatypes
% example for a string: checkString = @(s) any(strcmp(s,{'square','rectangle'}));

% Define input types:
% The syntax for <addRequired> is
% addRequired(inputParser,'input',default,validation)
addRequired(p,'t');
addRequired(p,'y');
addOptional(p,'data',default_data)
addOptional(p,'fs',default_fs,@isnumeric)

% Parse the inputs:
parse(p,t,y,varargin{:});

%%% Assign parsed input variables:

% Optional inputs
data  = p.Results.data;
fs = p.Results.fs;

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
else
    error('Required input variable "y" is not properly defined as an array or a specific channel indicator.')
end

%%% Create variable name strings for plotting purposes:
% If method 2 is used, use the map to retrieve channel names:
if isprop(data,'map')
    dependent_varname = data.map(y_ch);

% If method 1 is used, default to generic variable name "y(t)": 
else
    dependent_varname = 'y(t)';
end
%% Beginning of Function


Y = cwt(y);
L = length(y);

if isempty(fs)
    Fs = mean(diff(t))^-1;
else
    Fs = fs;
end 

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
wavelet_fig = figure;
plot(f,P1) 
title(['Wavelet Transform of ',dependent_varname])
xlabel('Time (s)') %%what should these units be
ylabel('Wavelet') %%what should these units be

[pk_wavelet, loc_wavelet]= findpeaks(P1,f); %%should this part be included?:
dominant_period = loc_wavelet(pk_wavelet == max(pk_wavelet))^-1;
end