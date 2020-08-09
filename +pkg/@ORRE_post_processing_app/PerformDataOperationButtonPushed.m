function PerformDataOperationButtonPushed(app, event)

if isstring(app.EnterOperationEditField.Value)
    operation_input = app.EnterOperationEditField.Value;
else
    operation_input = app.EnterOperationEditField.Value;
end

if contains(operation_input,'@(x)') == 1
    input_fun = str2func(operation_input);
else
    input_fun = str2func(['@(x)',operation_input]);
end
ch_idx = find(strcmp(app.SelectChannelDropDown.Value,app.Wavedata.headers));
app.Wavedata.(['ch',num2str(ch_idx)]) = arrayfun(input_fun,app.Wavedata.(['ch',num2str(ch_idx)]));

app.Combined_Channels(:,ch_idx) = app.Wavedata.(['ch',num2str(ch_idx)]);
app.UploadDataTable.Data{:,ch_idx} = app.Combined_Channels(:,ch_idx)

% %= array2table(combined_data);
% 
% %app.UITable.Data = array2table(app.Combined_Channels);
% app.UploadDataTable.Data = array2table(combined_data);
% 
% 
% 
% app.SelectIndependentVariableTimeListBox.ItemsData = 1:numel(app.SelectIndependentVariableTimeListBox.Items);
% timevalue = app.SelectIndependentVariableTimeListBox.Value;
% 
% app.SelectDependentVariableListBox.ItemsData = 1:numel(app.SelectDependentVariableListBox.Items);
% depvalue = app.SelectDependentVariableListBox.Value;
% 
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
%     
% end
end
