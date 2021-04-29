function FFTButtonPushed(app, event)
app.SelectIndependentVariableTimeListBox.ItemsData = 1:numel(app.SelectIndependentVariableTimeListBox.Items);
timevalue = app.SelectIndependentVariableTimeListBox.Value;

app.SelectDependentVariableListBox.ItemsData = 1:numel(app.SelectDependentVariableListBox.Items);
depvalue = app.SelectDependentVariableListBox.Value;

if ~isprop(app.Wavedata,'fft')
    app.Wavedata.addprop('fft')
    app.Wavedata.fft.fs = [];
    app.Wavedata.fft.dominant_periods = cell2table(cell(0,2));
    app.Wavedata.fft.dominant_periods.Properties.VariableNames = {'Channel','T_dominant'};
    app.Wavedata.fft.log = {['Log of fft operations performed by user on <',app.Wavedata.filename,'>']} ;
end

%--UPDATE:
% if ~isempty(app.StartTimeEditField.Value)
%     app.FFTvalue = depvalue(StartTimeEditField.Value:EndTimeEditField.Value);
%     app.Timevalue = timevalue(StartTimeEditField.Value:EndTimeEditField.Value);
% else
%     app.FFTvalue = depvalue;
%     app.Timevalue = timevalue;
% end
%--%
TimeList   = app.Wavedata.(strcat('ch',num2str(timevalue)));
DepVarList = app.Wavedata.(strcat('ch',num2str(depvalue)));

% Extract time and dependent variable lists between specified start and end values:
% TimeList   = TimeList(TimeList >= app.StartTimeEditField.Value & TimeList <= app.EndTimeEditField.Value);
% DepVarList = DepVarList(TimeList >= app.StartTimeEditField.Value & TimeList <= app.EndTimeEditField.Value);
startTime = app.StartTimeEditField.Value;
endTime = app.EndTimeEditField.Value;

if app.FrequencyCheckBox.Value == 1
    app.SelectedFrequency = app.DesiredSampleFrequencyEditField.Value;
    [T_dominant,app.Wavedata.fft.fs] = pkg.fun.plt_fft(timevalue,depvalue,app.Wavedata,app.SelectedFrequency,startTime,endTime);
elseif app.FrequencyCheckBox.Value == 0
    [T_dominant,app.Wavedata.fft.fs] =  pkg.fun.plt_fft(timevalue,depvalue,app.Wavedata,[],startTime,endTime);  
end

% %--UPDATE STUFF BELOW:
% if app.FrequencyCheckBox.Value == 0
%     app.Wavedata.addprop(strcat('DominantPeriod',num2str(app.SelectDependentVariableListBox.Value)));
%     app.Wavedata.addprop(strcat('FS',num2str(app.SelectDependentVariableListBox.Value)));
%     [app.Wavedata.(strcat('DominantPeriod',num2str(app.SelectDependentVariableListBox.ItemsData))),app.Wavedata.(strcat('FS',num2str(app.SelectDependentVariableListBox.ItemsData)))] =  pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata);
% end
% %--%
current_ch = app.Wavedata.map(strcat('ch',num2str(depvalue)));
temp_table = cell2table({current_ch,T_dominant});
temp_table.Properties.VariableNames = {'Channel','T_dominant'};
app.Wavedata.fft.dominant_periods = [app.Wavedata.fft.dominant_periods ; temp_table];
datestr(datetime)

app.Wavedata.fft.log{end+1,1} = ['[',datestr(datetime),']',' fft performed on <',...
    current_ch,'> using a sample frequency of ',num2str(app.Wavedata.fft.fs),...
    ' Hz. T_dominant = ',num2str(T_dominant),' s.'];
end



% app.FFTvalue = depvalue;
% app.Timevalue = timevalue;
% 
% if app.FrequencyCheckBox.Value == 1
%     app.SelectedFrequency = app.DesiredSampleFrequencyEditField.Value;
%     pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata,app.SelectedFrequency);
% end
% if app.FrequencyCheckBox.Value == 0
%     app.Wavedata.addprop('DominantPeriod');
%     app.Wavedata.addprop('FS');
%     [app.Wavedata.DominantPeriod,app.Wavedata.FS] =  pkg.fun.plt_fft(app.Timevalue,app.FFTvalue,app.Wavedata);    
% end

