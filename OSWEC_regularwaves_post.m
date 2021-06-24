%% ------------------------------ Header ------------------------------- %%
% Filename:     OSWEC_regularwaves_post.m
% Description:  Post-process OSWEC-type model regular wave experiments
% Author:       J. Davis
% Created on:   5-18-21
% Last updated: 5-18-21 by J. Davis
%% --------------------------------------------------------------------- %%
function [data] = OSWEC_regularwaves_post(data,dataopts,plotloop)

% extract setnames, channels, variable names, and subfields:
setnames = fieldnames(data);
varnames = dataopts.varnames;
subfields = dataopts.subfields;

% extract number of runs and subfields in the dataset:
numruns = length(setnames); 
numsubfields = length(subfields);

for i = 1:numruns
    % assign current run of the dataset
    currentrun = setnames{i};
    disp(currentrun)
    
    for j = 1:numsubfields
        
    subfield = subfields{j};
    varname = varnames{j};
%     chlabel = data.(run).map(ch);
%         if contains(chlabel,'"')
%             chlabel = strip(chlabel,'"');
%         end
    disp(subfield)
    disp(varname)
    
    % extract data
    y  = data.(currentrun).(subfield).(varname);
    t  = data.(currentrun).(subfield).t;

    % find peaks to slice at integer number of cycles
    pkprom = 0.75*sqrt(2)*rms(y);
    [pk, loc]= findpeaks(y,t,'MinPeakProminence',pkprom,'Annotate','extents');
    
    % update t0 and tf to first and last peak
    t0_fft = loc(2); % take loc(2) since loc(1) could be an end point
    tf_fft = loc(end-1);
    
    % store number of cycles
    ncycles = size(loc(2:end-1),1) - 1;
    
    % reslice t and y at integer cycles
    t_slice = t(t >= t0_fft & t <= tf_fft)-t0_fft;
    y_slice = y(t >= t0_fft & t <= tf_fft);
    
    fs = data.(currentrun).(subfield).fft.pre.fs
    % fft
    pkpromfactor = 0.15; % threshold (as proportion of peak FFT value) below which additional peaks are considered insignificant
    [f,Ma,~,T,A,~,~,fft_out] = functions.plt_fft(t_slice,y_slice,fs,pkpromfactor);
    T_list(i,j) = max(T); % disp(['T = ',num2str(T_list(i,j),2),' s'])
    A_list(i,j) = max(A); % disp(['A = ',num2str(A_list(i,j),2),' m'])
    
    
    
    
    
    
    % figures
    if plotloop == true
        
        fig1 = figure;
        fig1.Position(1) = fig1.Position(1) - fig1.Position(3);
        fig1.Position(2) = fig1.Position(2) - fig1.Position(4)/2;
            plot(t,y,'DisplayName','Original','LineWidth',1.25) 
            legend()
            xlabel('t(s)')
            ylabel(varname)
            legend()
            xlim([min(t_slice),max(t_slice)])
            
            sgtitle(replace(currentrun,'_',' '))

        fig2 = figure;
        fig2.Position(2) = fig2.Position(2) - fig2.Position(4)/2;
            plot(t_slice,y_slice,'DisplayName','Sliced','LineWidth',1.25) 
            yline(A_list(i,j),'DisplayName','Pos Amp')
            yline(-A_list(i,j),'DisplayName','Neg Amp')
            legend()
            xlabel('t(s)')
            ylabel(varname)
            legend()
            xlim([min(t_slice),max(t_slice)])
            
            sgtitle(replace(currentrun,'_',' '))
              
        fig3 = figure;
        fig3.Position(1) = fig3.Position(1) + fig3.Position(3);
        fig3.Position(2) = fig3.Position(2) - fig3.Position(4)/2;
            semilogx(f,Ma,'DisplayName','Sliced','LineWidth',1.25) 
            legend()
            xlabel('f(Hz)')
            ylabel(['Ma ',varname])
            legend()
           
            sgtitle(replace(currentrun,'_',' '))
 
    end
    
    % populate dataset fields
%     data.(currentrun).(subfield).t        = t;
%     data.(currentrun).(subfield).(varname)= y;
%     data.(currentrun).(subfield).slice.t0 = t0;
%     data.(currentrun).(subfield).slice.tf = tf;
%     data.(currentrun).(subfield).fft.post      = fft_out;
%     data.(currentrun).(subfield).filter   = filter;
%     
    end
end
end


function [t0,phi0] = pks(t,phi_raw,phi0sign)
    
    t0   = [];
    phi0 = [];
    
    if phi0sign == 1 % positive
        pkprom = 0.15*abs(min(phi_raw));
        c = [1 -1];
    elseif phi0sign == 2 % negative
        pkprom = 0.15*max(phi_raw);
        c = [-1 1];
    end
    
    [side1pks, side1locs] = findpeaks(c(1)*phi_raw,t,'MinPeakProminence',pkprom,'Annotate','extents');
    [side2pks, side2locs] = findpeaks(c(2)*phi_raw,t,'MinPeakProminence',pkprom,'Annotate','extents');
    
    secondpkloc = max(side2locs(side2pks==max(side2pks)));
    firstpklocs = side1locs(side1locs < secondpkloc);
    firstpkloc = firstpklocs(end);
    firstpk = c(1)*side1pks(side1locs==firstpkloc);
    
    t0 = firstpkloc;
    phi0 = firstpk;
    
    clear side1pks side1locs side2pks side2locs secondpkloc firstpklocs firstpkloc firstpk
end

function bool = checkfieldORprop(structORobj,run,subfield,fieldORprop)
   bool = false;
   try
       if isfield(structORobj.(run).(subfield),fieldORprop)
           bool = true;
       elseif isprop(structORobj.(subfield).(run),fieldORprop)
           bool = true;
       end
   catch
   end
end